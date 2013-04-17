//
//  AFJSONRPCProxy.h
//
//  Created by Andreas Böckler on 17.04.2013.
//

#import <Foundation/Foundation.h>
#import "AFJSONRPCClient.h"
@interface AFJSONRPCProxy : NSProxy

+ (instancetype)proxyWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol;
- (id)initWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol;

@property AFJSONRPCClient *client;

@property (nonatomic, readonly) NSMutableArray *interceptedMessageStrings;

@end
