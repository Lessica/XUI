//
//  XUIListViewController+XUITextFieldCell.m
//  Pods
//
//  Created by Zheng on 2018/5/15.
//

#import "XUIListViewController+XUITextFieldCell.h"
#import "XUIPrivate.h"

@implementation XUIListViewController (XUITextFieldCell)

XUI_START_IGNORE_PARTIAL
- (void)tableView:(UITableView *)tableView XUITextFieldCell:(UITableViewCell *)cell
{
    XUITextFieldCell *textFieldCell = (XUITextFieldCell *)cell;
    if (textFieldCell.xui_prompt.length == 0) return;
    
    BOOL readonly = (textFieldCell.xui_readonly != nil && [textFieldCell.xui_readonly boolValue] == YES);
    if (readonly) return;
    
    NSUInteger maxLength = UINT_MAX;
    if (textFieldCell.xui_maxLength)
        maxLength = [textFieldCell.xui_maxLength unsignedIntegerValue];
    
    if (!XUI_SYSTEM_8)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[XUIStrings localizedStringForString:@"XUI Error"] message:[NSString stringWithFormat:[XUIStrings localizedStringForString:@"This feature requires iOS %@ or later."], @"8.0"] delegate:nil cancelButtonTitle:[XUIStrings localizedStringForString:@"OK"] otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSString *alertTitle = textFieldCell.xui_prompt ? [NSString stringWithString:textFieldCell.xui_prompt] : nil;
    NSString *alertBody = textFieldCell.xui_message ? [NSString stringWithString:textFieldCell.xui_message] : nil;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [XUITextFieldCell reloadTextAttributes:textField forTextFieldCell:textFieldCell];
        [XUITextFieldCell reloadPlaceholderAttributes:textField forTextFieldCell:textFieldCell];
        [XUITextFieldCell reloadTextFieldStatus:textField forTextFieldCell:textFieldCell isPrompt:YES];
        textField.delegate = textFieldCell;
    }];
    NSString *cancelTitle = textFieldCell.xui_cancelTitle ? [NSString stringWithString:textFieldCell.xui_cancelTitle] : nil;
    if (cancelTitle.length == 0) cancelTitle = [XUIStrings localizedStringForString:@"Cancel"];
    [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // cancel action
    }]];
    NSString *okTitle = textFieldCell.xui_okTitle ? [NSString stringWithString:textFieldCell.xui_okTitle] : nil;
    if (okTitle.length == 0) okTitle = [XUIStrings localizedStringForString:@"OK"];
    __weak UIAlertController *alertRef = alertController; // avoid memory leak
    [alertController addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = [alertRef.textFields firstObject];
        if (textField)
        {
            [XUITextFieldCell savePrompt:textField forTextFieldCell:textFieldCell];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
XUI_END_IGNORE_PARTIAL

@end
