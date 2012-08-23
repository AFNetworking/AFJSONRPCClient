//
//  MyJSONRPCClient.h
//  Localeezy
//
//  Created by Clément Dal Palu on 22/08/12.
//  Copyright (c) 2012 Localeezy. All rights reserved.
//

#import "AFJSONRPCClient.h"

@interface MyJSONRPCClient : AFJSONRPCClient

+ (MyJSONRPCClient *)sharedInstance;

+ (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
       withRequestId:(NSString *)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
