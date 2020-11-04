//
//  HippyAppDelegateService.h
//  HippyDemo
//
//  Created by mt010 on 2020/8/17.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HippyAppDelegateManager.h"
#import "HippyRootView.h"


@interface HippyAppDelegateService : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign)BOOL allowRotation;//是否允许转向
@end
