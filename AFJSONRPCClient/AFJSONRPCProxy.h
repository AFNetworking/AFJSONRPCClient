//
//  AFJSONRPCProxy.h
//
//  Created by Andreas Böckler on 17.04.2013.
//

#import <Foundation/Foundation.h>
#import "AFJSONRPCClient.h"

typedef void (^afproxy_success_callback_t)(id responseObject);
typedef void (^afproxy_failure_callback_t)(NSError *error);

@interface AFJSONRPCProxy : NSProxy

+ (id)proxyWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol;
- (id)initWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol;

@property AFJSONRPCClient *client;

@end
