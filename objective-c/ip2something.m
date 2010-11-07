//
//  ip2something.m
//  ip2something
//
//  Created by Mathieu on 05/11/10.
//  Copyright 2010 garambrogne.net. All rights reserved.
//

#import "ip2something.h"


@implementation Ip2something
-(id) init {
    return [self initWithPath: @"~/.ip2something"];
}

-(id) initWithPath: (NSString *) path {
    folder = [path stringByExpandingTildeInPath];
    NSLog(@"ip db is here : %@", folder);
    datas = [NSFileHandle fileHandleForReadingAtPath: [NSString stringWithFormat: @"%@/ip.data", folder]];
    keys = [NSFileHandle fileHandleForReadingAtPath: [NSString stringWithFormat: @"%@/ip.keys", folder]];
    return self;
}

-(NSData *) getKey:(NSUInteger) n {
    [keys seekToFileOffset: n * 10];
    return [keys readDataOfLength: 4];
}

-(NSString *) getData:(NSUInteger) n {
    [keys seekToFileOffset: n * 10 + 4];
    NSData * pozSize = [keys readDataOfLength:6];
    NSLog(@"%@", pozSize);
    unsigned int poz;
    [pozSize getBytes:&poz length:4];
    NSLog(@"poz : %u", poz);
    short size;
    [pozSize getBytes:&size range:NSMakeRange(4,2) ];
    NSLog(@"size : %hu", size);
    [datas seekToFileOffset:poz];
    return [[NSString alloc] initWithData:[datas readDataOfLength:size] encoding:NSUTF8StringEncoding];
}

-(NSDictionary *) search:(NSString *) ip {
    return [NSDictionary new];
}
@end
