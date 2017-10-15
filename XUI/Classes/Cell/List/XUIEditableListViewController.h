//
//  XUIEditableListViewController.h
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import <XUI/XUI.h>

@class XUIEditableListViewController, XUIEditableListCell;

@protocol XUIEditableListViewControllerDelegate <NSObject>

- (void)editableListViewControllerContentListChanged:(XUIEditableListViewController *)controller;

@end

@interface XUIEditableListViewController : XUIViewController

@property (nonatomic, strong) NSArray <NSString *> *contentList;
@property (nonatomic, weak) id <XUIEditableListViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) XUIEditableListCell *cell;
- (instancetype)initWithCell:(XUIEditableListCell *)cell;

@end
