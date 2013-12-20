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

#import "AFHTTPRequestOperationManager.h"

/**
 AFJSONRPCClient objects communicate with web services using the JSON-RPC 2.0 protocol.
 
 @see http://www.jsonrpc.org/specification
 */
@interface AFJSONRPCClient : AFHTTPRequestOperationManager

/**
 The endpoint URL for the webservice.
 */
@property (readonly, nonatomic, strong) NSURL *endpointURL;

/**
 Creates and initializes a JSON-RPC client with the specified endpoint.
 
 @param URL The endpoint URL.
 
 @return An initialized JSON-RPC client.
 */
+ (instancetype)clientWithEndpointURL:(NSURL *)URL;

/**
 Initializes a JSON-RPC client with the specified endpoint.
 
 @param URL The endpoint URL.
 
 @return An initialized JSON-RPC client.
 */
- (id)initWithEndpointURL:(NSURL *)URL;

/**
 Creates a request with the specified HTTP method, parameters, and request ID.
 
 @param method The HTTP method. Must not be `nil`.
 @param parameters The parameters to encode into the request. Must be either an `NSDictionary` or `NSArray`.
 @param requestId The ID of the request.
 
 @return A JSON-RPC-encoded request.
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                parameters:(id)parameters
                                 requestId:(id)requestId;

/**
 Creates a request with the specified method, and enqueues a request operation for it.
 
 @param method The HTTP method. Must not be `nil`.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 */
- (void)invokeMethod:(NSString *)method
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates a request with the specified method and parameters, and enqueues a request operation for it.

 @param method The HTTP method. Must not be `nil`.
 @param parameters The parameters to encode into the request. Must be either an `NSDictionary` or `NSArray`.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 */
- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 Creates a request with the specified method and parameters, and enqueues a request operation for it.

 @param method The HTTP method. Must not be `nil`.
 @param parameters The parameters to encode into the request. Must be either an `NSDictionary` or `NSArray`.
 @param requestId The ID of the request.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the request operation, and the response object created by the client response serializer.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the request operation and the error describing the network or parsing error that occurred.
 */
- (void)invokeMethod:(NSString *)method
      withParameters:(id)parameters
           requestId:(id)requestId
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///----------------------
/// @name Method Proxying
///----------------------

/**
 Returns a JSON-RPC client proxy object with methods conforming to the specified protocol.

 @param protocol The protocol.

 @discussion This approach allows Objective-C messages to be transparently forwarded as JSON-RPC calls.
 */
- (id)proxyWithProtocol:(Protocol *)protocol;

@end

///----------------
/// @name Constants
///----------------

/**
 AFJSONRPCClient errors.
 */
extern NSString * const AFJSONRPCErrorDomain;
