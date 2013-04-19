//
//  AFJSONRPCProxy.m
//
//  Created by Andreas Böckler on 17.04.2013.
//

#import "AFJSONRPCProxy.h"
#import <objc/runtime.h>

@interface  AFJSONRPCProxy () {
    Protocol *implementedProtocol;
}

@end 

@implementation AFJSONRPCProxy

- (id)initWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol
{
    //self = [super init];
    if (self)
    {
        _client = [AFJSONRPCClient clientWithEndpointURL:URL];
        implementedProtocol = protocol;
    }
    return self;
}

+ (id) proxyWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol
{
    return [[self alloc] initWithEndpointURL:URL protocol:protocol];
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
