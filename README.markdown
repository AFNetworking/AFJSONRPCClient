Simple JSON-RPC Client based on top of AFNetworking (<a href="https://github.com/AFNetworking/AFNetworking">https://github.com/AFNetworking/AFNetworking</a>)

You have to Subclass AFJSONRPCCLient to use it.

<a href="http://json-rpc.org/">http://json-rpc.org/</a>

A good example can be found in the Example folder

## Example Usage

``` objective-c
// You can use the Example way :
[MyJSONRPCClient invokeMethod:@"method.name"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Or you can just use the sharedInstance
[MyJSONRPCClient sharedInstance] invokeMethod:@"method.name"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call without parameters
[MyJSONRPCClient invokeMethod:@"method.name"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with parameters
[MyJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSArray arrayWithObjects:@"1", @"2", nil]
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with named parameters
[MyJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSDictionary dictionaryWithObject:@"object" forKey:@"param.name"]
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];

// Call with request ID
[MyJSONRPCClient invokeMethod:@"method.name"
                   withParameters:[NSDictionary dictionaryWithObject:@"object" forKey:@"param.name"]
                    withRequestId:@"2"
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSLog(@"Success !");
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              NSLog(@"Fail...");
                          }];
```