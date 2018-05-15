//
//  XUITextFieldCell.h
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"
#import "XUITextField.h"

@interface XUITextFieldCell : XUIBaseCell <UITextFieldDelegate>

@property (strong, nonatomic) XUITextField *cellTextField;

@property (nonatomic, strong) NSString * xui_alignment;
@property (nonatomic, strong) NSString * xui_keyboard;
@property (nonatomic, strong) NSString * xui_placeholder;
@property (nonatomic, strong) NSNumber * xui_isSecure;

@property (nonatomic, strong) NSNumber *xui_maxLength;
@property (nonatomic, strong) NSString *xui_clearButtonMode;

// Prompt
@property (nonatomic, strong) NSString *xui_prompt;
@property (nonatomic, strong) NSString *xui_message;
@property (nonatomic, strong) NSString *xui_okTitle;
@property (nonatomic, strong) NSString *xui_cancelTitle;

+ (void)reloadTextAttributes:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell;
+ (void)reloadPlaceholderAttributes:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell;
+ (void)reloadTextFieldStatus:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell isPrompt:(BOOL)prompt;

+ (void)savePrompt:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell;

// Validation
@property (nonatomic, strong) NSString *xui_validationRegex;

@end
