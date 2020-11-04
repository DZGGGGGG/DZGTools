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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (_allowRotation == YES) {   // 如果属性值为YES,仅允许屏幕向左旋转,否则仅允许竖屏
        return UIInterfaceOrientationMaskLandscapeRight;  // 这里是屏幕要旋转的方向
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([url query]){
        UIWindow *topWindow = [[[UIApplication sharedApplication] delegate] window];
         UIViewController *FirstView = [self getCurrentVCFrom:topWindow.rootViewController];
         NSArray *subViewsArray = [FirstView.view subviews];
         for (HippyRootView *view in subViewsArray) {
             if ([view isKindOfClass:[HippyRootView class]]) {
                 view.appProperties = @{@"H5Params" : [url query]};
             }
         }
    }else{
        NSLog(@"没有参数");
    }
   
    return YES;
}


- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    return currentVC;
}
@end
