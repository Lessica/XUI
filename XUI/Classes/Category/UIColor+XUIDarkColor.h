//
//  UIColor+XUIDarkColor.h
//  XXTExplorer
//
//  Created by Zheng Wu on 14/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XUIDarkColor)

- (BOOL)xui_isDarkColor;
- (UIImage *)xui_image;
+ (UIColor *)xui_colorWithHex:(NSString *)representation;

@end
