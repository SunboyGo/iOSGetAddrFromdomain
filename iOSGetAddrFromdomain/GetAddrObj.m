//
//  GetAddrObj.m
//  iOSGetAddrFromdomain
//
//  Created by zk on 14-8-29.
//  Copyright (c) 2014年 zk. All rights reserved.
//

#import "GetAddrObj.h"

@implementation GetAddrObj


- (NSError *)gaiError:(int)gai_error
{
	NSString *errMsg = [NSString stringWithCString:gai_strerror(gai_error) encoding:NSASCIIStringEncoding];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
	
	return [NSError errorWithDomain:@"kCFStreamErrorDomainNetDB" code:gai_error userInfo:userInfo];
}


-(NSString*)getaddr:(NSString*)host andport:(uint16_t)port{
    NSError *error = nil;
    NSString *portStr = [NSString stringWithFormat:@"%hu", port];
    NSData *address4 = nil;
	NSData *address6 = nil;
    
    struct addrinfo hints, *res, *res0;
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_family   = PF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = IPPROTO_TCP;
    
    int gai_error = getaddrinfo([host UTF8String], [portStr UTF8String], &hints, &res0);
    
    if (gai_error)
    {
        error = [self gaiError:gai_error];
    }
    else
    {
        for(res = res0; res; res = res->ai_next)
        {
            if ((address4 == nil) && (res->ai_family == AF_INET))
            {
                // Found IPv4 address
                // Wrap the native address structure
                address4 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
                
            }
            else if ((address6 == nil) && (res->ai_family == AF_INET6))
            {
                // Found IPv6 address
                // Wrap the native address structure
                address6 = [NSData dataWithBytes:res->ai_addr length:res->ai_addrlen];
            }
        }
        freeaddrinfo(res0);
        
        if ((address4 == nil) && (address6 == nil))
        {
            error = [self gaiError:EAI_FAIL];
        }
    }
    if (address4) {
        NSString *lastaddr = [[NSString alloc] init];
        [self getHost:&lastaddr port:nil fromAddress:address4];
        NSLog(@"lastaddr=%@",lastaddr);
        return lastaddr;
    }else{
        return nil;
    }
}

- (NSString *)hostFromSockaddr4:(const struct sockaddr_in *)pSockaddr4
{
	char addrBuf[INET_ADDRSTRLEN];
	
	if (inet_ntop(AF_INET, &pSockaddr4->sin_addr, addrBuf, (socklen_t)sizeof(addrBuf)) == NULL)
	{
		addrBuf[0] = '\0';
	}
	
	return [NSString stringWithCString:addrBuf encoding:NSASCIIStringEncoding];
}


- (BOOL)getHost:(NSString **)hostPtr port:(uint16_t *)portPtr fromAddress:(NSData *)address
{
	if ([address length] >= sizeof(struct sockaddr))
	{
		const struct sockaddr *sockaddrX = [address bytes];
		
		if (sockaddrX->sa_family == AF_INET)
		{
			if ([address length] >= sizeof(struct sockaddr_in))
			{
				struct sockaddr_in sockaddr4;
				memcpy(&sockaddr4, sockaddrX, sizeof(sockaddr4));
				
				if (hostPtr) *hostPtr = [self hostFromSockaddr4:&sockaddr4];
				
				return YES;
			}
		}
	}
	
	return NO;
}


@end
