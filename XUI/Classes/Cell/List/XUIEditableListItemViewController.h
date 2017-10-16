//
//  XUIEditableListItemViewController.h
//  XUI
//
//  Created by Zheng Wu on 16/10/2017.
//

#import <XUI/XUI.h>

@class XUIEditableListItemViewController;

@protocol XUIEditableListItemViewControllerDelegate <NSObject>

- (void)editableListItemViewController:(XUIEditableListItemViewController *)controller contentUpdated:(NSString *)content;

@end

@interface XUIEditableListItemViewController : XUIViewController

@property (nonatomic, assign, readonly, getter=isAddMode) BOOL addMode;
@property (nonatomic, weak) id <XUIEditableListItemViewControllerDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *content;
- (instancetype)initWithContent:(NSString *)content;

@end
