//
//  HippyAppDelegateService.m
//  HippyDemo
//
//  Created by mt010 on 2020/8/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "HippyAppDelegateService.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation HippyAppDelegateService


#pragma mark -
#pragma mark Method Resolution

- (NSArray<NSString *> *)appDelegateMethods {
    static NSMutableArray *methods = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unsigned int methodCount = 0;
        struct objc_method_description *methodList = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &methodCount);
        methods = [NSMutableArray arrayWithCapacity:methodCount];
        for (int i = 0; i < methodCount; i ++) {
            struct objc_method_description md = methodList[i];
            [methods addObject:NSStringFromSelector(md.name)];
        }
        free(methodList);
    });
    return methods;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL canResponse = [self methodForSelector:aSelector] != nil && [self methodForSelector:aSelector] != _objc_msgForward;
    if (! canResponse && [[self appDelegateMethods] containsObject:NSStringFromSelector(aSelector)]) {
        canResponse = [[HippyAppDelegateManager sharedManager] proxyCanResponseToSelector:aSelector];
    }
    return canResponse;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [[HippyAppDelegateManager sharedManager] proxyForwardInvocation:anInvocation];
}

@end
