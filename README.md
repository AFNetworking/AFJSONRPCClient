# AFJSONRPCClient

**A [JSON-RPC](http://json-rpc.org/) Client built on [AFNetworking](https://github.com/AFNetworking/AFNetworking)**

> [JSON-RPC](http://json-rpc.org/) is a [remote procedure call](http://en.wikipedia.org/wiki/Remote_procedure_call) protocol encoded in [JSON](http://en.wikipedia.org/wiki/JSON). It is a simple protocol (and very similar to [XML-RPC](http://en.wikipedia.org/wiki/XML-RPC)), defining only a handful of data types and commands. JSON-RPC allows for notifications (info sent to the server that does not require a response) and for multiple calls to be sent to the server which may be answered out of order.

## Example Usage

``` objective-c
AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:@"http://path.to/json-rpc/service/"]];

// Invocation
[client invokeMethod:@"method.name"
    success:^(AFHTTPRequestOperation *operation, id responseObject)
{
    // ...
}   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    // ...
}];

// Invocation with Parameters
[client invokeMethod:@"method.name"
          parameters:@{@"foo" : @"bar", @"baz" : @(13)}
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
    // ...
}   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    // ...
}];

// Invocation with Parameters and Request ID
[client invokeMethod:@"method.name"
          parameters:@[@(YES), @(42)]
           requestId:@(2)
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
    // ...
}   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    // ...
}];
```

## Using Protocol & NSProxy

Combine your JSON-RPC client with an Objective-C protocol for fun and profit!

``` objective-c
@protocol ArithemeticProtocol
- (void)sum:(NSArray *)numbers
    success:(void (^)(NSNumber *sum))success;
    failure:(void (^)(NSError *error))failure;
@end

AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:@"http://path.to/json-rpc/service/"]];

[[client proxyForProtocol:@protocol(ArithemeticProtocol)] sum:@[@(1), @(2)]
    success:^(NSNumber *sum) {
    // ...
}   failure:^(NSError *error) {
    // ...
}];
```

## Subclassing

You can also subclass `AFJSONRPCClient` for shared class and service-related methods:

``` objective-c
MyJSONRPCClient *client = [MyJSONRPCClient sharedClient];

[client sum:@[@(1), @(2)]
    success:^(NSNumber *sum) {
    // ...
}   failure:^(NSError *error) {
    // ...
}];
```

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add AFJSONRPCClient to your project.

Here's an example podfile that installs AFJSONRPCClient and its dependency, AFNetworking.

### Podfile

```ruby
platform :ios, '5.0'

pod 'AFJSONRPCClient', '0.1.0'
```

Note the specification of iOS 5.0 as the platform; leaving out the 5.0 will cause CocoaPods to fail with the following message:

> [!] AFJSONRPCClient is not compatible with iOS 4.3.

## License

AFJSONRPCClient and AFNetworking are available under the MIT license. See the LICENSE file for more info.
