//
//  AFJSONRPCClient.h
//  Japancar
//
//  Created by Admin on 27.03.12.
//  Copyright (c) 2012 JustCommunication. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface AFJSONRPCClient : NSObject {
@private
    NSURL *_endpointURL;
    NSOperationQueue *_operationQueue;
}

@property (nonatomic, retain) NSURL *endpointURL;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

- (id)initWithURL:(NSURL *)url;

- (void)call:(NSString *)method 
  parameters:(NSArray *)parameters
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method 
                                parameters:(NSArray *)parameters;

@end
