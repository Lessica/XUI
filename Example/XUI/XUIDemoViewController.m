//
//  XUIDemoViewController.m
//  XUI
//
//  Created by Lessica on 10/10/2017.
//  Copyright (c) 2017 Lessica. All rights reserved.
//

#import "XUIDemoViewController.h"
#import <XUI/XUI.h>

@interface XUIDemoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *demoButton;

@end

@implementation XUIDemoViewController

- (IBAction)demoButtonTapped:(id)sender {
    // real XUI
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"bundle"];
    NSString *xuiPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"interface.xui" ofType:@"json"];
    XUIListViewController *xuiController = [[XUIListViewController alloc] initWithPath:xuiPath withBundlePath:bundlePath];
    XUINavigationController *navController = [[XUINavigationController alloc] initWithRootViewController:xuiController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)schemaButtonTapped:(id)sender {
    // Settings.bundle
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *xuiPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"Root" ofType:@"plist"];
    XUIListViewController *xuiController = [[XUIListViewController alloc] initWithPath:xuiPath withBundlePath:bundlePath];
    // Feel relaxed to set the custom adapter, theme, or logger here...
    XUINavigationController *navController = [[XUINavigationController alloc] initWithRootViewController:xuiController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
