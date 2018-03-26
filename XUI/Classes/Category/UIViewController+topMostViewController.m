//
//  UIViewController+topMostViewController.m
//  XXTExplorer
//
//  Created by Zheng on 06/01/2018.
//  Copyright © 2018 Zheng. All rights reserved.
//

#import "UIViewController+topMostViewController.h"

@implementation UIViewController (topMostViewController)

- (UIViewController *)xui_topMostViewController {
    if (self.presentedViewController == nil) {
        return self;
    }
    if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        return [navigationController.visibleViewController xui_topMostViewController];
    }
    if ([self.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)self.presentedViewController;
        if (tabBarController.selectedViewController) {
            return [tabBarController.selectedViewController xui_topMostViewController];
        } else {
            return [tabBarController xui_topMostViewController];
        }
    }
    if ([self.presentedViewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.presentedViewController;
        if (splitViewController.viewControllers.count > 0) {
            return [splitViewController.viewControllers[0] xui_topMostViewController];
        } else {
            return [splitViewController xui_topMostViewController];
        }
    }
    return [self.presentedViewController xui_topMostViewController];
}

- (void)xui_dismissModalStackAnimated:(BOOL)animated {
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:animated completion:nil];
}

@end
