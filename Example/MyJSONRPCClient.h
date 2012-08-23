//
//  MyJSONRPCClient.h
//  Localeezy
//
//  Created by Clément Dal Palu on 22/08/12.
//  Copyright (c) 2012 Localeezy. All rights reserved.
//

#import "AFJSONRPCClient.h"

@interface MyJSONRPCClient : AFJSONRPCClient

+ (MyJSONRPCClient *)sharedInstance;

- (void)summ:(NSNumber *)number1
  withNumber:(NSNumber *)number2
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
