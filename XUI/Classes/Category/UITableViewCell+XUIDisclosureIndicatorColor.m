//
//  UITableViewCell+XUIDisclosureIndicatorColor.m
//  XUI
//
//  Created by Zheng Wu on 13/10/2017.
//

#import "UITableViewCell+XUIDisclosureIndicatorColor.h"

@implementation UITableViewCell (XUIDisclosureIndicatorColor)

- (void)setXui_disclosureIndicatorColor:(UIColor *)xui_disclosureIndicatorColor {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator || self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
    {
        if (@available(iOS 13.0, *)) {
            UIImage *image = [UIImage systemImageNamed:@"chevron.right"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.tintColor = xui_disclosureIndicatorColor;
            self.accessoryView = imageView;
        } else {
            UIButton *arrowButton = [self arrowButton];
            UIImage *image = [arrowButton backgroundImageForState:UIControlStateNormal];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            arrowButton.tintColor = xui_disclosureIndicatorColor;
            [arrowButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
}

- (UIColor *)xui_disclosureIndicatorColor {
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator || self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
    {
        if (@available(iOS 13.0, *)) {
            if ([self.accessoryView isKindOfClass:[UIImageView class]]) {
                return self.accessoryView.tintColor;
            }
        } else {
            UIButton *arrowButton = [self arrowButton];
            return arrowButton.tintColor;
        }
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
