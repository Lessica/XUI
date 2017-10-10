//
//  XUITextareaViewController.h
//  XXTExplorer
//
//  Created by Zheng on 10/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"

@class XUITextareaViewController, XUITextareaCell;

@protocol XUITextareaViewControllerDelegate <NSObject>

- (void)textareaViewControllerTextDidChanged:(XUITextareaViewController *)controller;

@end

@interface XUITextareaViewController : XUIViewController

@property (nonatomic, weak) id <XUITextareaViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) XUITextareaCell *cell;
- (instancetype)initWithCell:(XUITextareaCell *)cell;

@end
