//
//  GetAddrObj.h
//  iOSGetAddrFromdomain
//
//  Created by zk on 14-8-29.
//  Copyright (c) 2014年 zk. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <netinet/tcp.h>
#include <netinet/in.h>
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif

#import <arpa/inet.h>
#import <fcntl.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <netinet/in.h>
#import <net/if.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/poll.h>
#import <sys/uio.h>
#import <unistd.h>

@interface GetAddrObj : NSObject

-(NSString*)getaddr:(NSString*)host andport:(uint16_t)port;

@end
