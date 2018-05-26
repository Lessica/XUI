//
//  XUINavigationController.m
//  Courtesy
//
//  Created by Zheng on 8/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import "XUINavigationController.h"
#import "XUIViewController.h"
#import "XUIPrivate.h"
#import "UIColor+XUIDarkColor.h"


@interface XUINavigationController () <UINavigationControllerDelegate>

@end

@implementation XUINavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}

#pragma mark - Initializer

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.topViewController isKindOfClass:[XUIViewController class]])
    {
        XUIViewController *xuiController = (XUIViewController *)self.topViewController;
        [self renderNavigationBarTheme:xuiController];
    }
}

#pragma mark - View Style

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

#pragma mark - Navigation Bar Transition

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id <UIViewControllerTransitionCoordinator> coordinator = viewController.transitionCoordinator;
    if (!coordinator) return;
    if (![viewController isKindOfClass:[XUIViewController class]]) return;
    XUIViewController *xuiController = (XUIViewController *)viewController;
    if (coordinator.interactive) {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            [self renderNavigationBarTheme:xuiController];
        } completion:nil];
    } else {
        [self renderNavigationBarTheme:xuiController];
        return;
    }
    void (^transitionBlock)(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) =
    ^void (id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            UIViewController *contextController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            if (![contextController isKindOfClass:[XUIViewController class]]) return;
            XUIViewController *contextXUIController = (XUIViewController *)contextController;
            [self renderNavigationBarTheme:contextXUIController];
        }
    };
    if (@available(iOS 10.0, *)) {
        [viewController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:transitionBlock];
    } else {
        [viewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:transitionBlock];
    }
}

- (void)renderNavigationBarTheme:(XUIViewController *)controller {
    UIColor *backgroundColor = [controller preferredNavigationBarColor];
    UIColor *foregroundColor = [controller preferredNavigationBarTintColor];
    { // title color
        [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : foregroundColor }];
    }
    { // bar color
        self.navigationBar.tintColor = foregroundColor;
        self.navigationBar.barTintColor = backgroundColor;
    }
    { // item color
        {
            controller.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
            controller.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
            controller.navigationItem.backBarButtonItem.tintColor = foregroundColor;
            for (UIBarButtonItem *item in controller.navigationItem.leftBarButtonItems) {
                item.tintColor = foregroundColor;
            }
            for (UIBarButtonItem *item in controller.navigationItem.rightBarButtonItems) {
                item.tintColor = foregroundColor;
            }
        }
        {
            self.navigationItem.leftBarButtonItem.tintColor = foregroundColor;
            self.navigationItem.rightBarButtonItem.tintColor = foregroundColor;
            self.navigationItem.backBarButtonItem.tintColor = foregroundColor;
            for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems) {
                item.tintColor = foregroundColor;
            }
            for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                item.tintColor = foregroundColor;
            }
        }
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
