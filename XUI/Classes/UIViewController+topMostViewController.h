//
//  UIViewController+topMostViewController.h
//  XXTExplorer
//
//  Created by Zheng on 06/01/2018.
//  Copyright © 2018 Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (topMostViewController)

- (UIViewController *)xui_topMostViewController;
- (void)xui_dismissModalStackAnimated:(BOOL)animated;

@end
