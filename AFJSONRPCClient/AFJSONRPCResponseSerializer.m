//
//  AFJSONRPCResponseSerializer.m
//
//
//  Created by Ignacio Inglese on 10/17/13.
//  Copyright (c) 2013 Ignacio Inglese Inc. All rights reserved.
//

#import "AFJSONRPCResponseSerializer.h"

@implementation AFJSONRPCResponseSerializer

- (instancetype)init {
    if (self = [super init]) {
        NSMutableSet * mutableContentTypes = [NSMutableSet setWithSet:self.acceptableContentTypes];
        [mutableContentTypes addObjectsFromArray:@[@"application/json-rpc", @"application/jsonrequest"]];
        self.acceptableContentTypes = [NSSet setWithSet:mutableContentTypes];
    }
    return self;
}

@end
