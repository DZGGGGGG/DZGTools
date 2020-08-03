//
//  ToolsClass.h
//  HippyDemo
//
//  Created by mt010 on 2020/6/1.
//  Copyright © 2020 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIImage+WLCompress.h"
NS_ASSUME_NONNULL_BEGIN

@interface ToolsClass : NSObject
+ (double)calulateImageFileSize:(UIImage *)image isCompress:(BOOL)isCompress size:(CGFloat)Size;
+ (NSString *)getIpBundle:(NSString *)bundleName;
+ (void) setIpValue :(NSString *)ipStr;
+ (NSString *)getHttpIpValue;
+ (UIViewController *)getCurrentVC;
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;
+ (NSString *)contentTypeForImageData:(NSData *)data;
+ (BOOL)smartURLForString:(NSString *)str;
+ (NSString *)uuidString;
+ (CGFloat)getSafeAreaInsesBottom;
+ (CGFloat)getSafeAreaInsesTop;
+ (NSString *)localhostUrlChange:(NSString *)localhostUrl;
@end

NS_ASSUME_NONNULL_END
