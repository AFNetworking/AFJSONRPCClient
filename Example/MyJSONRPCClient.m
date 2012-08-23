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
        _sharedInstance = [[MyJSONRPCClient alloc] initWithBaseUrl:[NSURL URLWithString:kMyClientURL]];
    });
    
    return _sharedInstance;
}

#pragma mark -
#pragma mark Static functions

+ (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[MyJSONRPCClient sharedInstance] invokeMethod:method withParameters:[NSArray array] withRequestId:@"1" success:success failure:failure];
}

+ (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[MyJSONRPCClient sharedInstance] invokeMethod:method withParameters:parameters withRequestId:@"1" success:success failure:failure];
}

+ (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
       withRequestId:(NSString *)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [[MyJSONRPCClient sharedInstance] invokeMethod:method withParameters:parameters withRequestId:requestId success:success failure:failure];
}

@end
