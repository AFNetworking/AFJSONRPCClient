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
#import <objc/runtime.h>

NSString * const AFJSONRPCErrorDomain = @"com.alamofire.networking.json-rpc";

@interface AFJSONRPCProxy : NSProxy {
    Protocol *implementedProtocol;
}

- (id)initWithClient:(AFJSONRPCClient *)client protocol:(Protocol*) protocol;

@property (readwrite, nonatomic, strong) AFJSONRPCClient *client;
@end

@implementation AFJSONRPCProxy

- (id)initWithClient:(AFJSONRPCClient*) client protocol:(Protocol*) protocol
{
    //self = [super init];
    if (self)
    {
        _client = client;
        implementedProtocol = protocol;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description omd = protocol_getMethodDescription(implementedProtocol, aSelector, YES, YES);
    //    NSLog(@"%@ => objc_method_description->name: %@", NSStringFromSelector(aSelector), NSStringFromSelector(omd.name));
    return omd.name!=NULL;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    //    struct objc_method_description omd = protocol_getMethodDescription(implementedProtocol, sel, YES, YES);
    //    NSLog(@"%@ => objc_method_description->name: %@", NSStringFromSelector(sel), NSStringFromSelector(omd.name));
    //    NSLog(@"selector -> %@", NSStringFromSelector(sel));
    
    // 0:v->RET || 1:@->self || 2::->SEL || 3:@->arg#0 (NSArray) || 4/5:^v->arg#1/2 (block)
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:@^v^v"];
    return sig;
}

- (void) forwardInvocation:(NSInvocation *)invocation;
{
    NSString *message = NSStringFromSelector([invocation selector]);
    NSArray *messSplit = [message componentsSeparatedByString:@":"];
    NSString *jsonMethod = [messSplit objectAtIndex:0];
    
    //NSLog(@"message -> %s %@" ,sel_getName(invocation.selector), jsonMethod );
    __unsafe_unretained id arguments;
    __unsafe_unretained  afproxy_success_callback_t success_callback;
    __unsafe_unretained  afproxy_failure_callback_t failure_callback;
    
    NSAssert(invocation.methodSignature.numberOfArguments==5, @"numberOfArguments != 5");
    [invocation getArgument:&arguments atIndex:2]; // 0 und 1 sind SELF / SEL
    [invocation getArgument:&success_callback atIndex:3];
    [invocation getArgument:&failure_callback atIndex:4];
    
    __block afproxy_success_callback_t success_callback_copy = [success_callback copy];
    __block afproxy_failure_callback_t failure_callback_copy = [failure_callback copy];
    
    [_client invokeMethod:jsonMethod withParameters:arguments success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success_callback_copy!=NULL) success_callback_copy(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(failure_callback_copy!=NULL) failure_callback_copy(error);
    }];
    [invocation invokeWithTarget:nil];
}

@end

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
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self invokeMethod:method withParameters:parameters requestId:[NSNumber numberWithInteger:1] success:success failure:failure];
}

- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
           requestId:(id)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self requestWithMethod:method parameters:parameters requestId:requestId];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(id)parameters
                                 requestId:(id)requestId
{
    NSParameterAssert(method);

    if (!parameters) {
        parameters = [NSArray array];
    }

    NSAssert([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSArray class]], @"Expect NSArray or NSDictionary in JSONRPC parameters");

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

- (id) proxyWithProtocol:(Protocol*) protocol
{
    return [[AFJSONRPCProxy alloc] initWithClient:self protocol:protocol];
}


@end
