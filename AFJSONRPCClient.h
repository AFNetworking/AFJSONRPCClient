//
//  AFJSONRPCClient.h
//  Japancar
//
//  Created by wiistriker@gmail.com on 27.03.12.
//  Copyright (c) 2012 JustCommunication. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface AFJSONRPCClient : NSObject

+ (AFJSONRPCClient*)clientWithBaseUrl:(NSURL*)url;
- (id)initWithBaseUrl:(NSURL*)url;

- (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
       withRequestId:(NSString *)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
