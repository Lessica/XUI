//
//  XUIOrderedOptionViewController.h
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIViewController.h"
#import "XUIOrderedOptionCell.h"

@class XUIOrderedOptionViewController;

@protocol XUIOrderedOptionViewControllerDelegate <NSObject>

- (void)orderedOptionViewController:(XUIOrderedOptionViewController *)controller didSelectOption:(NSArray <NSNumber *> *)optionIndexes;

@end

@interface XUIOrderedOptionViewController : XUIViewController

@property (nonatomic, weak) id <XUIOrderedOptionViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) XUIOrderedOptionCell *cell;
- (instancetype)initWithCell:(XUIOrderedOptionCell *)cell;

@end
