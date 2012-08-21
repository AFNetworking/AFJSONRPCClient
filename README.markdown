Simple JSON-RPC Client based on top of AFNetworking (<a href="https://github.com/AFNetworking/AFNetworking">https://github.com/AFNetworking/AFNetworking</a>)

Class moved to a Singleton for easier use.

<a href="http://json-rpc.org/">http://json-rpc.org/</a>

## Example Usage

``` objective-c
#import "AFJSONRPCClient.h"

// First, set the base URL for your RPC Server
[AFJSONRPCClient setBaseUrl:[NSURL URLWithString:@"http://json.rpc.server/api/"]];

// Call without parameters
[AFJSONRPCClient invokeMethod:@"method.name"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with parameters
[AFJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSArray arrayWithObjects:@"1", @"2", nil]
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with named parameters
[AFJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSDictionary dictionaryWithObject:@"object" forKey:@"param.name"]
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with request ID
[AFJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSDictionary dictionaryWithObject:@"object" forKey:@"param.name"]
                    withRequestId:@"2"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];
```