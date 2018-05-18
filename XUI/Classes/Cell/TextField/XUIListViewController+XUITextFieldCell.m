//
//  XUIListViewController+XUITextFieldCell.m
//  Pods
//
//  Created by Zheng on 2018/5/15.
//

#import "XUIListViewController+XUITextFieldCell.h"
#import "XUIPrivate.h"

@implementation XUIListViewController (XUITextFieldCell)

- (void)tableView:(UITableView *)tableView XUITextFieldCell:(UITableViewCell *)cell
{
    
    if (!XUI_SYSTEM_8)
    {
        return;
    }
    
    XUITextFieldCell *textFieldCell = (XUITextFieldCell *)cell;
    if (textFieldCell.xui_prompt.length == 0) return;
    
    BOOL readonly = (textFieldCell.xui_readonly != nil && [textFieldCell.xui_readonly boolValue] == YES);
    if (readonly) return;
    
    NSString *regexString = textFieldCell.xui_validationRegex;
    NSRegularExpression *validationRegex = nil;
    if (regexString.length > 0)
    {
        NSError *regexError = nil;
        validationRegex = [[NSRegularExpression alloc] initWithPattern:regexString options:0 error:&regexError];
        if (!validationRegex)
        {
            [self presentErrorAlertController:regexError];
            return;
        }
    }
    
    NSUInteger maxLength = UINT_MAX;
    if (textFieldCell.xui_maxLength)
        maxLength = [textFieldCell.xui_maxLength unsignedIntegerValue];
    
    NSString *raw = textFieldCell.xui_value;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    XUI_START_IGNORE_PARTIAL
    NSString *alertTitle = textFieldCell.xui_prompt ? [self.adapter localizedString:[NSString stringWithString:textFieldCell.xui_prompt]] : nil;
    NSString *alertBody = textFieldCell.xui_message ? [self.adapter localizedString:[NSString stringWithString:textFieldCell.xui_message]] : nil;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:alertBody preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [XUITextFieldCell resetTextFieldStatus:textField];
        [XUITextFieldCell reloadTextAttributes:textField forTextFieldCell:textFieldCell];
        [XUITextFieldCell reloadPlaceholderAttributes:textField forTextFieldCell:textFieldCell];
        [XUITextFieldCell reloadTextFieldStatus:textField forTextFieldCell:textFieldCell isPrompt:YES];
        textField.delegate = textFieldCell;
    }];
    NSString *cancelTitle = textFieldCell.xui_cancelTitle ? [self.adapter localizedString:[NSString stringWithString:textFieldCell.xui_cancelTitle]] : nil;
    if (cancelTitle.length == 0) cancelTitle = [XUIStrings localizedStringForString:@"Cancel"];
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [center removeObserver:strongSelf name:UITextFieldTextDidChangeNotification object:nil];
    }]];
    NSString *okTitle = textFieldCell.xui_okTitle ? [self.adapter localizedString:[NSString stringWithString:textFieldCell.xui_okTitle]] : nil;
    if (okTitle.length == 0) okTitle = [XUIStrings localizedStringForString:@"OK"];
    __weak UIAlertController *alertRef = alertController; // avoid memory leak
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        UITextField *textField = [alertRef.textFields firstObject];
        if (textField)
        {
            [XUITextFieldCell savePrompt:textField forTextFieldCell:textFieldCell];
        }
        [center removeObserver:strongSelf name:UITextFieldTextDidChangeNotification object:nil];
    }];
    submitAction.enabled = NO;
    [alertController addAction:submitAction];
    [self presentViewController:alertController animated:YES completion:nil];
    XUI_END_IGNORE_PARTIAL
    
    [center addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull aNotification) {
        UITextField *textField = (UITextField *)aNotification.object;
        NSString *content = textField.text;
        if ([content isEqualToString:raw]) {
            submitAction.enabled = NO;
        } else {
            if (validationRegex)
            {
                NSTextCheckingResult *result
                = [validationRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
                if (!result)
                { // validation failed
                    submitAction.enabled = NO;
                }
                else
                {
                    submitAction.enabled = YES;
                }
            }
            else
            {
                submitAction.enabled = YES;
            }
        }
    }];
    
}

@end
