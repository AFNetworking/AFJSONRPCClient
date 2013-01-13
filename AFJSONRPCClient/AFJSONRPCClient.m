// AFJSONRPCClient.m
// 
// Created by wiistriker@gmail.com
// Copyright (c) 2013 JustCommunication
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFJSONRPCClient.h"
#import "AFJSONRequestOperation.h"

NSString * const AFJSONRPCErrorDomain = @"com.alamofire.networking.json-rpc";

@interface AFJSONRPCClient ()
@property (readwrite, nonatomic, strong) NSURL *endpointURL;
@end

@implementation AFJSONRPCClient
@synthesize endpointURL = _endpointURL;

+ (void)initialize {
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json-rpc", @"application/jsonrequest", nil]];
}

+ (instancetype)clientWithEndpointURL:(NSURL *)URL {
    return [[self alloc] initWithEndpointURL:URL];
}

- (id)initWithEndpointURL:(NSURL *)URL {
    NSParameterAssert(URL);

    self = [super initWithBaseURL:URL];
    if (!self) {
        return nil;
    }

    self.parameterEncoding = AFJSONParameterEncoding;

    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];

    self.endpointURL = URL;

    return self;
}

- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:[NSArray array] success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(NSArray *)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:parameters requestId:[NSNumber numberWithInteger:1] success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(NSArray *)parameters
           requestId:(id)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters requestId:requestId];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(NSArray *)parameters
                                 requestId:(id)requestId
{
    NSParameterAssert(method);

    if (!parameters) {
        parameters = [NSArray array];
    }

    if (!requestId) {
        requestId = [NSNumber numberWithInteger:1];
    }

    NSDictionary *payload = [NSMutableDictionary dictionary];
    [payload setValue:@"2.0" forKey:@"jsonrpc"];
    [payload setValue:method forKey:@"method"];
    [payload setValue:parameters forKey:@"params"];
    [payload setValue:[requestId description] forKey:@"id"];

    return [self requestWithMethod:@"POST" path:[self.endpointURL absoluteString] parameters:payload];
}

#pragma mark - AFHTTPClient

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [super HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger errorCode = 0;
        NSString *errorMessage = nil;

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
                    errorMessage = NSLocalizedStringFromTable(@"Unknown Error", @"AFJSONRPCClient", nil);
                }
            } else {
                errorMessage = NSLocalizedStringFromTable(@"Unknown JSON-RPC Response", @"AFJSONRPCClient", nil);
            }
        } else {
            errorMessage = NSLocalizedStringFromTable(@"Unknown JSON-RPC Response", @"AFJSONRPCClient", nil);
        }

        if (errorMessage && failure) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:errorMessage forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:AFJSONRPCErrorDomain code:errorCode userInfo:userInfo];

            failure(operation, error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

@end
