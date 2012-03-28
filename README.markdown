Simple JSON-RPC Client based on top of AFNetworking (<a href="https://github.com/AFNetworking/AFNetworking">https://github.com/AFNetworking/AFNetworking</a>)

<a href="http://json-rpc.org/">http://json-rpc.org/</a>

## Example Usage

``` objective-c
AFJSONRPCClient *client = [[AFJSONRPCClient alloc] initWithURL:[NSURL URLWithString:@"http://path.to/json-rpc/service/"]];
[client call:@"method.name" parameters:[NSArray arrayWithObject:@"1"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //success handling
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //error handling
}];
```