

#import "UIColor+colorChange.h"


@implementation UIColor (colorChange)
+ (UIColor *)colorWithHexString : (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    NSDictionary *colorDict = @{@"maroon":@"#800000",@"darkred":@"#8B0000",@"brown":@"#A52A2A",@"firebrick":@"#B22222",@"crimson":@"#DC143C",@"red":@"#FF0000",@"mediumvioletred":@"#C71585",@"palevioletred":@"#D87093",@"deeppink":@"#FF1493",@"fuchsia":@"#FF00FF",@"magenta":@"#FF00FF",@"hotpink":@"#FF69B4",@"pink":@"#FFC0CB",@"lightpink":@"#FFB6C1",@"mistyrose":@"#FFE4E1",@"lavenderblush":@"#FFF0F5",@"indigo":@"#4B0082",@"purple":@"#800080",@"darkmagenta":@"#8B008B",@"darkorchid":@"#9932CC",@"blueviolet":@"#8A2BE2",@"darkviolet":@"#9400D3",@"slateblue":@"#6A5ACD",@"mediumpurple":@"#9370DB",@"mediumslateblue":@"#7B68EE",@"mediumorchid":@"#BA55D3",@"violet":@"#EE82EE",@"plum":@"#DDA0DD",@"thistle":@"#D8BFD8",@"lavender":@"#E6E6FA",@"saddlebrown":@"#8B4513",@"sienna":@"#A0522D",@"chocolate":@"#D2691E",@"indianred":@"#CD5C5C",@"rosybrown":@"#BC8F8F",@"lightcorol":@"#F08080 ",@"salmon":@"#FA8072",@"lightsalmon":@"#FFA07A",@"orangered":@"#FF4500",@"tomato":@"#FF6347",@"coral":@"#FF7F50",@"darkorange":@"#FF8C00",@"sandybrown":@"#F4A460",@"peru":@"#CD853F",@"tan":@"#D2B48C",@"burlywood":@"#DEB887",@"wheat":@"#F5DEB3",@"moccasin":@"#FFE4B5",@"navajowhite":@"#FFDEAD",@"peachpuff":@"#FFDAB9",@"bisque":@"#FFE4C4",@"antuquewhite":@"#FAEBD7",@"papayawhip":@"#FFEFD5",@"cornsilk":@"#FFF8DC ",@"oldlace":@"#FDF5E6",@"linen":@"#FAF0E6",@"seashell":@"#FFF5EE",@"snow":@"#FFFAFA",@"floralwhite":@"#FFFAF0",@"ivory":@"#FFFFF0",@"mintcream":@"#F5FFFA",@"darkgoldenrod":@"#B8860B",@"goldenrod":@"#DAA520",@"gold":@"#FFD700",@"yellow":@"#FFFF00",@"darkkhaki":@"#BDB76B",@"khaki":@"#F0E68C",@"palegoldenrod":@"#EEE8AA ",@"beige":@"#F5F5DC",@"lemonchiffon":@"#FFFACD",@"lightgoldenrodyellow":@"#FAFAD2",@"lightyellow ":@"#FFFFE0",@"darkslategray":@"#2F4F4F",@"darkolivegreen":@"#556B2F",@"olive":@"#808000",@"darkgreen":@"#006400",@"forestgreen":@"#228B22",@"seagreen":@"#2E8B57 ",@"green(teal)":@"#008080",@"lightseagreen":@"#20B2AA",@"madiumaquamarine":@"#66CDAA",@"mediumseagreen":@"#3CB371",@"darkseagreen":@"#8FBC8F",@"yellowgreen":@"#9ACD32",@"limegreen":@"#32CD32",@"lime":@"#00FF00",@"chartreuse":@"#7FFF00",@"lawngreen":@"#7CFC00",@"greenyellow":@"#ADFF2F ",@"mediumspringgreen":@"#00FA9A",@"springgreen":@"#00FF7F",@"lightgreen ":@"#90EE90",@"palegreen":@"#98F898",@"aquamarine":@"#7FFFD4",@"honeydew":@"#F0FFF0",@"midnightblue":@"#191970",@"navy":@"#000080",@"darkblue":@"#00008B",@"darkslateblue":@"#483D8B",@"mediumblue":@"#0000CD",@"royalblue":@"#4169E1",@"dodgerblue":@"#1E90FF",@"cornflowerblue":@"#6495ED",@"deepskyblue":@"#00BFFF",@"lightskyblue":@"#87CEFA",@"lightsteelblue":@"#B0C4DE",@"lightblue":@"#ADD8E6",@"steelblue":@"#4682B4",@"darkcyan":@"#008B8B",@"cadetblue":@"#5F9EA0",@"darkturquoise":@"#00CED1",@"mediumturquoise":@"#48D1CC",@"turquoise":@"#40E0D0",@"skyblue":@"#87CECB",@"powderblue":@"#B0E0E6",@"paleturquoise":@"#AFEEEE",@"lightcyan":@"#E0FFFF",@"azure":@"#F0FFFF",@"aliceblue":@"#F0F8FF",@"aqua(cyan)":@"#00FFFF",@"black":@"#000000",@"dimgray":@"#696969",@"gray":@"#808080",@"slategray":@"#708090",@"lightslategray":@"#778899",@"dakgray":@"#A9A9A9",@"silver":@"#C0C0C0",@"lightgray":@"#D3D3D3",@"gainsboro":@"#DCDCDC",@"whitesmoke":@"#F5F5F5",@"ghostwhite":@"#F8F8FF",@"white":@"#FFFFFF"};
    if (colorDict[[cString lowercaseString]]){
        return [UIColor colorWithHexString:colorDict[[cString lowercaseString]]];
    }else if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
        return [self getColor:cString];
    }else if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
        return [self getColor:cString];
        
    }else if ([cString hasPrefix:@"rgb"]){
        NSMutableString *colorMuStr = [[NSMutableString alloc] initWithString:cString];
        NSRange r1 = [colorMuStr rangeOfString:@"rgb"];//查找字符串（返回一个结构体（起始位置及长度））
        NSRange r2 = [colorMuStr rangeOfString:@"("];//查找字符串（返回一个结构体（起始位置及长度））
        NSRange r3 = [colorMuStr rangeOfString:@")"];//查找字符串（返回一个结构体（起始位置及长度））
        [colorMuStr deleteCharactersInRange:r1];
        [colorMuStr deleteCharactersInRange:r2];
        [colorMuStr deleteCharactersInRange:r3];
        NSArray *colorRgb = [colorMuStr componentsSeparatedByString:@","];
        CGFloat r = [[colorRgb[0] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        CGFloat g = [[colorRgb[1] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        CGFloat b = [[colorRgb[2] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        CGFloat a = 1;
        if (colorRgb[3]){
            a = [[colorRgb[3] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
        }
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }else{
        return [UIColor colorWithHexString:colorDict[@"gray"]];
    }
}
+ (UIColor *)getColor:(NSString *)cString{
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end