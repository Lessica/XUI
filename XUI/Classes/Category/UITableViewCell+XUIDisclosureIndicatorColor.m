//
//  UITableViewCell+XUIDisclosureIndicatorColor.m
//  XUI
//
//  Created by Zheng Wu on 13/10/2017.
//

#import "UITableViewCell+XUIDisclosureIndicatorColor.h"

@implementation UITableViewCell (XUIDisclosureIndicatorColor)

- (void)setXui_disclosureIndicatorColor:(UIColor *)xui_disclosureIndicatorColor {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator || self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
        UIButton *arrowButton = [self arrowButton];
        UIImage *image = [arrowButton backgroundImageForState:UIControlStateNormal];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        arrowButton.tintColor = xui_disclosureIndicatorColor;
        [arrowButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (UIColor *)xui_disclosureIndicatorColor {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator || self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton) {
        UIButton *arrowButton = [self arrowButton];
        return arrowButton.tintColor;
    }
    return nil;
}

- (UIButton *)arrowButton {
    for (UIView *view in self.subviews)
        if ([view isKindOfClass:[UIButton class]])
            return (UIButton *)view;
    return nil;
}

@end
