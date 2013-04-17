//
//  AFJSONRPCProxy.m
//
//  Created by Andreas Böckler on 17.04.2013.
//

#import "AFJSONRPCProxy.h"
#import <objc/runtime.h>
@interface NSMethodSignature (objctypes)
+(NSMethodSignature*)signatureWithObjCTypes:(const char*)types;
@end
@interface  AFJSONRPCProxy () {
    Protocol *iProtocol;
}

@end 

@implementation AFJSONRPCProxy

- (id)initWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol
{
    //self = [super init];
    if (self)
    {
        _client = [AFJSONRPCClient clientWithEndpointURL:URL];
        _interceptedMessageStrings = [NSMutableArray array];
        iProtocol = protocol;
    }
    return self;
}

+ (id) proxyWithEndpointURL:(NSURL *)URL protocol:(Protocol*) protocol
{
    return [[self alloc] initWithEndpointURL:URL protocol:protocol];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    struct objc_method_description omd = protocol_getMethodDescription(iProtocol, aSelector, YES, YES);
//    NSLog(@"%@ => objc_method_description->name: %@", NSStringFromSelector(aSelector), NSStringFromSelector(omd.name));
    return omd.name!=NULL;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
//    struct objc_method_description omd = protocol_getMethodDescription(iProtocol, sel, YES, YES);
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

    NSLog(@"message -> %s %@" ,sel_getName(invocation.selector), jsonMethod );
    NSArray *argArray;
    NSMethodSignature *signature = invocation.methodSignature;
    NSAssert(invocation.methodSignature.numberOfArguments==5, @"numberOfArguments != 5");
    [invocation getArgument:&argArray atIndex:2]; // 0 und 1 sind SELF / SEL
    NSLog(@"array? %@",argArray);
//    void *pointer;
//    for (int index=0; index < signature.numberOfArguments; index++) {
//        const char *typeEncoding = [signature getArgumentTypeAtIndex:index];
//        [invocation getArgument:&pointer atIndex:index];
//        NSLog(@"#%i %s -> 0x%x", index, typeEncoding, pointer);
//    }
    [self.interceptedMessageStrings addObject:message];
    [invocation invokeWithTarget:nil];
}

@end
