//
//  AFJSONRPCClient.m
//  JustCommunication.com
//
//  Created by wiistriker@gmail.com on 27.03.12.
//  Copyright (c) 2012 JustCommunication. All rights reserved.
//

#import "AFJSONRPCClient.h"
#import "AFJSONUtilities.h"

NSString * const AFJSONRPCErrorDomain = @"org.json-rpc";

@implementation AFJSONRPCClient

@synthesize endpointURL = _endpointURL;
@synthesize operationQueue = _operationQueue;

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.endpointURL = url;
    
    self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
    [self.operationQueue setMaxConcurrentOperationCount:4];
    
    return self;
}

- (void)setEndpointURL:(NSURL*)url
{
    self.endpointURL = url;
}

- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:[NSArray array] withRequestId:@"1" success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:parameters withRequestId:@"1" success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(NSObject *)parameters
       withRequestId:(NSString *)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:method parameters:parameters requestId:requestId];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger errorCode = 0;
        NSString *errorMessage;
    
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id result = [responseObject objectForKey:@"result"];
            id error = [responseObject objectForKey:@"error"];
            
            if (result && result != [NSNull null]) {
                if (success) {
                    success(operation, result);
                }
            } else if (error && error != [NSNull null]) {
                if ([error isKindOfClass:[NSDictionary class]] && [error objectForKey:@"code"] && [error objectForKey:@"message"]) {
                    errorCode = [[error objectForKey:@"code"] intValue];
                    errorMessage = [error objectForKey:@"message"];
                } else {
                    errorMessage = @"Unknown error";
                }
            } else {
                errorMessage = @"Unknown json-rpc response";
            }
        } else {
            errorMessage = @"Unknown json-rpc response";
        }
        
        if (errorMessage && failure) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil];
            NSError *error = [NSError errorWithDomain:AFJSONRPCErrorDomain code:errorCode userInfo:userInfo];
            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    [self.operationQueue addOperation:operation];
    [operation release];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSObject *)parameters
                                 requestId:(NSString *)requestId
{
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:self.endpointURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *JSONRPCStruct = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"2.0", @"jsonrpc",
                     method, @"method",
                     parameters, @"params",
                     requestId, @"id",
                     nil];
    
    NSError *error = nil;
    NSData *JSONData = AFJSONEncode(JSONRPCStruct, &error);
    if (!error) {
        [request setHTTPBody:JSONData];
    }
    
    return request;
}

- (void)dealloc
{
    [_endpointURL release];
    [_operationQueue release];
    [super dealloc];
}

@end
