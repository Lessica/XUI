//
//  XUITextFieldCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITextFieldCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

@interface XUITextFieldCell () <UITextFieldDelegate>

@end

@implementation XUITextFieldCell

@synthesize xui_value = _xui_value;

+ (BOOL)xibBasedLayout {
    return YES;
}

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"alignment": [NSString class],
      @"keyboard": [NSString class],
      @"placeholder": [NSString class],
      @"value": [NSString class]
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    NSString *checkType = kXUICellFactoryErrorDomain;
    @try {
        {
            NSString *alignmentString = cellEntry[@"alignment"];
            if (alignmentString) {
                NSArray <NSString *> *validAlignment = @[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ];
                if (![validAlignment containsObject:alignmentString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"alignment", alignmentString];
                }
            }
        }
        {
            NSString *keyboardString = cellEntry[@"keyboard"];
            if (keyboardString) {
                NSArray <NSString *> *validKeyboard = @[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ];
                if (![validKeyboard containsObject:keyboardString]) {
                    superResult = NO;
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"keyboard", keyboardString];
                }
            }
        }
    } @catch (NSString *exceptionReason) {
        NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: exceptionReason }];
        if (error) {
            *error = exceptionError;
        }
    } @finally {
        
    }
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *textField = self.cellTextField;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    XUI_START_IGNORE_PARTIAL
    if ([textField respondsToSelector:@selector(smartDashesType)]) {
        textField.smartDashesType = UITextSmartDashesTypeNo;
        textField.smartQuotesType = UITextSmartQuotesTypeNo;
        textField.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    }
    XUI_END_IGNORE_PARTIAL
#endif
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setXui_keyboard:(NSString *)xui_keyboard {
    _xui_keyboard = xui_keyboard;
    if ([xui_keyboard isEqualToString:@"Default"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([xui_keyboard isEqualToString:@"ASCIICapable"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([xui_keyboard isEqualToString:@"NumbersAndPunctuation"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([xui_keyboard isEqualToString:@"URL"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeURL;
    }
    else if ([xui_keyboard isEqualToString:@"NumberPad"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"PhonePad"]) {
        self.cellTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"NamePhonePad"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"EmailAddress"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([xui_keyboard isEqualToString:@"DecimalPad"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([xui_keyboard isEqualToString:@"Alphabet"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        self.cellTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setXui_placeholder:(NSString *)xui_placeholder {
    _xui_placeholder = xui_placeholder;
    self.cellTextField.placeholder = xui_placeholder;
}

- (void)setXui_isSecure:(NSNumber *)xui_isSecure {
    _xui_isSecure = xui_isSecure;
    BOOL isSecure = [xui_isSecure boolValue];
    self.cellTextField.secureTextEntry = isSecure;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"Left"]) {
        self.cellTextField.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        self.cellTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        self.cellTextField.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        self.cellTextField.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        self.cellTextField.textAlignment = NSTextAlignmentJustified;
    }
    else {
        self.cellTextField.textAlignment = NSTextAlignmentNatural;
    }
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellTextField.enabled = !readonly;
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    self.cellTextField.text = xui_value;
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellTextField.tintColor = theme.tintColor;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.xui_value = textField.text;
    [self.adapter saveDefaultsFromCell:self];
}

@end
