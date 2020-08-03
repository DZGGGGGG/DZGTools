//
//  UIImage+WLCompress.m
//  HippyDemo
//
//  Created by mt010 on 2020/6/1.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "UIImage+WLCompress.h"
/**
*  压缩图片到指定大小 并返回大小  将NSData / 1024 就可以获得图片的kb大小
*/
@implementation UIImage (WLCompress)
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
    maxLength = maxLength * 1024;
   CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}
/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
-(void)imageYaSuo:(CGSize)size{
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    
    // 将图片按照指定大小绘制
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
//    // 从当前图片上下文中导出图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
}


//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
