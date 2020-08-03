//
//  UIImage+WLCompress.h
//  HippyDemo
//
//  Created by mt010 on 2020/6/1.
//  Copyright © 2020 tencent. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WLCompress)
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength ;
-(void)imageYaSuo:(CGSize)size;
-(UIImage*)scaleToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
