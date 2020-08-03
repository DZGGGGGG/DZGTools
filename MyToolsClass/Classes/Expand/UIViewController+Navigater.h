//
//  UIViewController+Navigater.h
//  HippyDemo
//
//  Created by mt010 on 2020/7/1.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (Navigater) <BackButtonHandlerProtocol>
- (void)dismissViewControllerWithCount:(NSInteger)count animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
