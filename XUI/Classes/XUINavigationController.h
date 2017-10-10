//
//  XUINavigationController.h
//  Courtesy
//
//  Created by Zheng on 8/10/16.
//  Copyright © 2016 82Flex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUINavigationController : UINavigationController

- (BOOL)shouldAutorotate;
- (UIStatusBarStyle)preferredStatusBarStyle;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@end
