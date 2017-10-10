//
//  XUIOptionViewController.h
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"

@class XUIOptionViewController, XUIOptionCell;

@protocol XUIOptionViewControllerDelegate <NSObject>

- (void)optionViewController:(XUIOptionViewController *)controller didSelectOption:(NSInteger)optionIndex;

@end

@interface XUIOptionViewController : XUIViewController

@property (nonatomic, weak) id <XUIOptionViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) XUIOptionCell *cell;
- (instancetype)initWithCell:(XUIOptionCell *)cell;

@end
