//
//  MyJSONRPCClient.m
//  Localeezy
//
//  Created by Clément Dal Palu on 22/08/12.
//  Copyright (c) 2012 Localeezy. All rights reserved.
//

#import "MyJSONRPCClient.h"

@implementation MyJSONRPCClient

static NSString * const kMyClientURL = @"http://Your.RPC-Server.URL";

+ (MyJSONRPCClient *)sharedInstance
{
    static MyJSONRPCClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MyJSONRPCClient alloc] initWithUrl:[NSURL URLWithString:kMyClientURL]];
    });
    
    return _sharedInstance;
}

- (void)summ:(NSNumber *)number1
  withNumber:(NSNumber *)number2
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:@"math.sum"
        withParameters:[NSArray arrayWithObjects:number1, number2, nil]
               success:success
               failure:failure];
}

@end