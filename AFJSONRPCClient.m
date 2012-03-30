//
//  AFJSONRPCClient.m
//  Japancar
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

- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:[NSArray array] withRequestId:@"1" success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(NSArray *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:parameters withRequestId:@"1" success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method 
      withParameters:(NSArray *)parameters
       withRequestId:(NSString *)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSURLRequest *request = [self requestWithMethod:method parameters:parameters requestId:requestId];
    
    AFJSONRequestOperation *operation = [[[AFJSONRequestOperation alloc] initWithRequest:request] autorelease];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id result = [responseObject objectForKey:@"result"];
            id error = [responseObject objectForKey:@"error"];
            
            if (result && result != [NSNull null]) {
                if (success) {
                    success(operation, result);
                }
            } else if (error && error != [NSNull null]) {
                if (failure) {
                    NSInteger errorCode = 0;
                    NSString *errorMessage;
                
                    if ([error isKindOfClass:[NSDictionary class]] && [error objectForKey:@"code"] && [error objectForKey:@"message"]) {
                        errorCode = [[error objectForKey:@"code"] intValue];
                        errorMessage = [error objectForKey:@"message"];
                    } else {
                        errorMessage = @"Unknown error";
                    }
                    
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:AFJSONRPCErrorDomain code:errorCode userInfo:userInfo];
                    failure(operation, error);
                }
            } else {
                if (failure) {
                    NSInteger errorCode = 0;
                    NSString *errorMessage = @"Unknown json-rpc response";
                    
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:AFJSONRPCErrorDomain code:errorCode userInfo:userInfo];
                    failure(operation, error);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    [self.operationQueue addOperation:operation];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method 
                                parameters:(NSArray *)parameters
                                 requestId:(NSString *)requestId
{	
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:self.endpointURL] autorelease];
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
