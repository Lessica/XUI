//
//  UIScrollView+IndicatorColor.m
//  XUI
//
//  Created by Rachel on 3/15/22.
//

#import "UIScrollView+IndicatorColor.h"

@implementation UIScrollView (IndicatorColor)

- (UIView *)verticalScrollIndicators
{
    if (self.subviews.count < 2) {
        return nil;
    }
    
    NSUInteger verticalScrollViewIndicatorPosition = self.subviews.count - 1;
    UIView *verticalScrollIndicator = nil;
    
    UIView *viewForVerticalScrollViewIndicator = self.subviews[verticalScrollViewIndicatorPosition];
    BOOL isIndicator13 = NO;
    if (@available(iOS 13.0, *)) {
        isIndicator13 = [viewForVerticalScrollViewIndicator isKindOfClass:NSClassFromString(@"_UIScrollViewScrollIndicator")];
    }
    if (isIndicator13 || [viewForVerticalScrollViewIndicator isKindOfClass:[UIImageView class]]) {
        verticalScrollIndicator = viewForVerticalScrollViewIndicator.subviews[0];
    }
    
    return verticalScrollIndicator;
}

@end
