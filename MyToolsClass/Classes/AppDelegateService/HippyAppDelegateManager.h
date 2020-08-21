//
//  HippyAppDelegateManager.h
//  HippyDemo
//
//  Created by mt010 on 2020/8/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ML_EXPORT_SERVICE(name) \
+ (void)load {[[MLAppServiceManager sharedManager] registerService:[self new]];} \
- (NSString *)serviceName { return @#name; }

NS_ASSUME_NONNULL_BEGIN

@protocol MLAppService <UIApplicationDelegate>

@required
- (NSString *)serviceName;

@end


@interface HippyAppDelegateManager : NSObject


+ (instancetype)sharedManager;

- (void)registerService:(id<MLAppService>)service;

- (BOOL)proxyCanResponseToSelector:(SEL)aSelector;
- (void)proxyForwardInvocation:(NSInvocation *)anInvocation;
@end

NS_ASSUME_NONNULL_END
