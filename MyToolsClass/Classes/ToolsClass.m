//
//  ToolsClass.m
//  HippyDemo
//
//  Created by mt010 on 2020/6/1.
//  Copyright © 2020 tencent. All rights reserved.
//

#import "ToolsClass.h"

//沙盒文件夹Data
static NSString * dataFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *dataFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!dataFolder) {
            NSString *dataDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
            
            dataFolder = dataDir;
        }
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:dataFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", dataFolder);
            dataFolder = nil;
        }
    });
    return dataFolder;
}

//缓存文件夹Data
static NSString * cacheFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheFolder) {
            NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            
            cacheFolder = cachesPath;
        }
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", cacheFolder);
            cacheFolder = nil;
        }
    });
    return cacheFolder;
}
//App下文件夹app
static NSString * privateFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *privateFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!privateFolder) {
            NSString *privatePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            
            privateFolder = privatePath;
        }
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:privateFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", privateFolder);
            privateFolder = nil;
        }
    });
    return privateFolder;
}
// 本地文件管理的data路径
static NSString * LocalDataFileModulePath() {
    return dataFolder();
}
// 本地文件管理的Cache路径
static NSString * LocalCacheFileModulePath() {
    return cacheFolder();
}
// 本地文件管理的App下的路径
static NSString * LocalPrivateFileModulePath() {
    return privateFolder();
}

@implementation ToolsClass

/**
*  计算图片的大小 并压缩到指定大小
*/
+ (double)calulateImageFileSize:(UIImage *)image isCompress:(BOOL)isCompress size:(CGFloat)Size{
    //计算图片的data长度
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);
    }
    double dataLength = [data length] * 1.0;
    dataLength = dataLength / 1024;
    if (Size == 0){
        return dataLength;
    }
    NSLog(@"image = %.2fkb",dataLength);
    if (isCompress) {
        Size = Size * 1024; //kb转换成dataLength
        data = [image compressQualityWithMaxLength:Size];
        return data.length / 1024;
    }else{
        return dataLength;
    }
}
/**
*  压缩图片尺寸
*/
-(NSData *)compressBySizeWithMaxLength:(NSUInteger)maxLength{
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return data;
}

+ (NSString *)getHttpIpValue{
    NSString *ip = [[NSString alloc] initWithFormat:@"http://%@/",[[NSUserDefaults standardUserDefaults] stringForKey:@"remoteIp"]];
    return ip;
}

/**
*  将当前的ip 存入缓存中 后续进行判断 存储
*/
+ (void) setIpValue :(NSString *)ipStr{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"remoteIp"] isEqualToString:ipStr]){
        return;
    }
    NSString *ip = [[NSString alloc] initWithFormat:@"%@",ipStr];
    //NSString *ip = @"http://192.168.1.177:38989/";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:ip forKey:@"remoteIp"];
    [defaults synchronize];
}

/**
*  获取当前的ip 组成当前bundle的路径
**/
+ (NSString *)getIpBundle:(NSString *)bundleName{
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@.bundle",[ToolsClass getHttpIpValue],bundleName];
    return urlString;
}

/**
*  NSData转换成base64的data形式
**/
+ (NSData *)getBase64Data:(NSData *)data{
    NSData *base64;
    base64 = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return base64;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
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

/**
*  根据CIImage生成指定大小的UIImage
*
*  @param image CIImage
*  @param size  图片宽度
*
*  @return 生成高清的UIImage
*/
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1. 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
     NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
     if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
         return @"webp";
     }
     return nil;
    }
    return nil;
}
//传入src 判断是否为http请求 如果是
+ (BOOL)smartURLForString:(NSString *)str
{
    if(str == nil)
        
        return NO;

    NSString *url;

    if (str.length>4 && [[str substringToIndex:4] isEqualToString:@"www."]) {

        url = [NSString stringWithFormat:@"http://%@",str];

    }else{

        url = str;

    }
    NSString *urlRegex = @"(^(http|https|mtLocal)://[\\w\\W]+.svga$)";

    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];

    return [urlTest evaluateWithObject:url];
}
//生成UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}
// 获取底部安全距离
+ (CGFloat)getSafeAreaInsesBottom{
    CGFloat safeNum = 0;
        //判断版本
        if (@available(iOS 11.0, *)) {
            //通过系统方法keyWindow来获取safeAreaInsets
            UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
            safeNum = safeArea.bottom;
        }
    return safeNum;
}

// 获取头部安全距离
+ (CGFloat)getSafeAreaInsesTop{
    CGFloat safeNum = 0;
        //判断版本
        if (@available(iOS 11.0, *)) {
            //通过系统方法keyWindow来获取safeAreaInsets
            UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
            safeNum = safeArea.top;
        }
    return safeNum;
}

/*
 @Param ::
    localhostUrl(String) :
        前端传输的特殊路径格式 例如 data://test/1.png data://代表着根目录 后面的路径代表着根目录下的文件夹
 @Describe :
    将特殊路径格式转换成沙盒路径格式进行操作
 */
+ (NSString *)localhostUrlChange:(NSString *)mt_FilePath{
    NSMutableString *fileLocalhostUrl = [NSMutableString new];
    if ([mt_FilePath containsString:@"mtData://"])
    {
        [fileLocalhostUrl appendString:LocalDataFileModulePath()];
        [fileLocalhostUrl appendFormat:@"/%@",[mt_FilePath componentsSeparatedByString:@"mtData://"][1]];
    }else if ([mt_FilePath containsString:@"mtCache://"])
    {
        [fileLocalhostUrl appendString:LocalCacheFileModulePath()];
        [fileLocalhostUrl appendFormat:@"/%@",[mt_FilePath componentsSeparatedByString:@"mtCache://"][1]];
    }else if ([mt_FilePath containsString:@"mtFile://"])
    {
        [fileLocalhostUrl appendString:LocalPrivateFileModulePath()];
        [fileLocalhostUrl appendFormat:@"/%@",[mt_FilePath componentsSeparatedByString:@"mtFile://"][1]];
    }
    else if ([mt_FilePath containsString:@"mtLocal://"])
    {
        #ifdef DEBUG
            NSString *ip = [ToolsClass getHttpIpValue];
            [fileLocalhostUrl appendString:ip];
            [fileLocalhostUrl appendFormat:@"%@",[mt_FilePath componentsSeparatedByString:@"mtLocal://"][1]];
        #else
            NSArray *file_array = [mt_FilePath componentsSeparatedByString:@"/"];
            NSString *file_str = [file_array lastObject];
            NSString *real_file_str = [[NSBundle mainBundle] pathForResource:[file_str componentsSeparatedByString:@"."][0] ofType:[file_str componentsSeparatedByString:@"."][1]];
            fileLocalhostUrl = real_file_str;
        #endif
        
    }
    else if ([mt_FilePath containsString:@"http://"] || [mt_FilePath containsString:@"https://"])
    {
        return mt_FilePath;
    }
    else{
        //NSLog(@"路径不是指定的mtLocal mtData mtCache mtFile http https 路径 返回原来的路径");
        return mt_FilePath;
    }
    return fileLocalhostUrl;
}
/*
@Param ::
   localhostUrl(String) :
       本地路径
@Describe :
   将本地路径转化成前端特殊路径
*/

+ (NSString *)vueUrlChangeLocal:(NSString *)localhostUrl{
    NSMutableString *fileVueUrl = [NSMutableString new];
    if ([localhostUrl containsString:LocalDataFileModulePath()]){
        //@"mtData://" 路径 mtData://
        [fileVueUrl appendString:@"mtData://"];
        [fileVueUrl appendFormat:@"%@",[localhostUrl componentsSeparatedByString:LocalDataFileModulePath()][1]];
    }
    else if ([localhostUrl containsString:LocalCacheFileModulePath()])
    {
        //@"mtCache://" 路径 mtCache://
        [fileVueUrl appendString:@"mtCache://"];
        [fileVueUrl appendFormat:@"%@",[localhostUrl componentsSeparatedByString:LocalCacheFileModulePath()][1]];
    }
    else if ([localhostUrl containsString:LocalPrivateFileModulePath()])
    {
        //@"mtFile://" 路径 mtFile://
        [fileVueUrl appendString:@"mtFile://"];
        [fileVueUrl appendFormat:@"%@",[localhostUrl componentsSeparatedByString:LocalPrivateFileModulePath()][1]];
    }
    else if ([localhostUrl containsString:[ToolsClass getHttpIpValue]])
    {
        //包含了ip地址就是 当前局域网内的资源访问 mtLocal://
        [fileVueUrl appendString:@"mtLocal://"];
        [fileVueUrl appendFormat:@"%@",[localhostUrl componentsSeparatedByString:[ToolsClass getHttpIpValue]][1]];
    }
    else if ([localhostUrl containsString:[[NSBundle mainBundle] bundlePath]])
    {
        //@"mtLocal://" mtLocal://
        [fileVueUrl appendString:@"mtLocal://"];
        [fileVueUrl appendFormat:@"%@",[localhostUrl componentsSeparatedByString:[[NSBundle mainBundle] bundlePath]][1]];
        
    }
    else if ([localhostUrl containsString:@"http://"] || [localhostUrl containsString:@"https://"])
    {
        //http路径 http://
        fileVueUrl = [[NSMutableString alloc] initWithString:localhostUrl];
    }
    else{
        NSLog(@"路径不是沙盒路径 或者http路径  返回传回的路径");
        return @"";
    }
    return fileVueUrl;
}
@end
