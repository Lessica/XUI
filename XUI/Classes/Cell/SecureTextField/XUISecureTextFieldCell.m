//
//  XUISecureTextFieldCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUISecureTextFieldCell.h"
#import "XUIPrivate.h"
#import "XUIAdapter.h"
#import "XUILogger.h"

@interface XUISecureTextFieldCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellSecureTextField;

@end

@implementation XUISecureTextFieldCell

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
    
    UITextField *textField = self.cellSecureTextField;
    textField.delegate = self;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    XUI_START_IGNORE_PARTIAL
    if ([textField respondsToSelector:@selector(smartDashesType)]) {
        textField.smartDashesType = UITextSmartDashesTypeNo;
        textField.smartQuotesType = UITextSmartQuotesTypeNo;
        textField.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    }
    XUI_END_IGNORE_PARTIAL
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setXui_keyboard:(NSString *)xui_keyboard {
    _xui_keyboard = xui_keyboard;
    if ([xui_keyboard isEqualToString:@"Default"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([xui_keyboard isEqualToString:@"ASCIICapable"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([xui_keyboard isEqualToString:@"NumbersAndPunctuation"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([xui_keyboard isEqualToString:@"URL"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeURL;
    }
    else if ([xui_keyboard isEqualToString:@"NumberPad"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"PhonePad"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"NamePhonePad"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"EmailAddress"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([xui_keyboard isEqualToString:@"DecimalPad"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([xui_keyboard isEqualToString:@"Alphabet"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setXui_placeholder:(NSString *)xui_placeholder {
    _xui_placeholder = xui_placeholder;
    self.cellSecureTextField.placeholder = xui_placeholder;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"Left"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentJustified;
    }
    else {
        self.cellSecureTextField.textAlignment = NSTextAlignmentNatural;
    }
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellSecureTextField.enabled = !readonly;
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    self.cellSecureTextField.text = xui_value;
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellSecureTextField.tintColor = theme.tintColor;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.xui_value = textField.text;
    [self.adapter saveDefaultsFromCell:self];
}

@end
