//
//  UIColor+XUIDarkColor.m
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "UIColor+XUIDarkColor.h"

@implementation UIColor (XUIDarkColor)

- (BOOL)xui_isDarkColor
{
    CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
    if (NO == [self getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]])
    {
        if ([self getWhite:&components[0] alpha:&components[3]])
        {
            components[1] = components[0];
            components[2] = components[0];
        }
    }
    CGFloat colorBrightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000.f;
    return (colorBrightness < 0.7);
}

- (UIImage *)xui_image {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIColor *)xui_colorWithHex:(NSString *)representation {
    NSString *hex = representation;
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    } else if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    NSUInteger length = hex.length;
    if (length != 3 && length != 6 && length != 8)
        return nil;
    if (length == 3) {
        NSString *r = [hex substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hex substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hex substringWithRange:NSMakeRange(2, 1)];
        hex = [NSString stringWithFormat:@"%@%@%@%@%@%@ff", r, r, g, g, b, b];
    } else if (length == 6) {
        hex = [NSString stringWithFormat:@"%@ff", hex];
    }
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    unsigned int rgbaValue = 0;
    [scanner scanHexInt:&rgbaValue];
    return [self colorWithRed:((rgbaValue & 0xFF000000) >> 24) / 255.f
                        green:((rgbaValue & 0xFF0000) >> 16) / 255.f
                         blue:((rgbaValue & 0xFF00) >> 8) / 255.f
                        alpha:((rgbaValue & 0xFF)) / 255.f];
}

@end
