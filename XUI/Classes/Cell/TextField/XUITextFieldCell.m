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

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleWidthConstraint;

@property (nonatomic, assign) NSUInteger maxLength;

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
      @"value": [NSString class],
      @"maxLength": [NSNumber class],
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    if (superResult) {
        NSString *checkType = kXUICellFactoryErrorDomain;
        {
            NSString *alignmentString = cellEntry[@"alignment"];
            if (alignmentString) {
                NSArray <NSString *> *validAlignment = @[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ];
                if (![validAlignment containsObject:alignmentString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"alignment", alignmentString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
        {
            NSString *keyboardString = cellEntry[@"keyboard"];
            if (keyboardString) {
                NSArray <NSString *> *validKeyboard = @[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ];
                if (![validKeyboard containsObject:keyboardString]) {
                    checkType = kXUICellFactoryErrorUnknownEnumDomain;
                    NSString *errorReason = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"keyboard", keyboardString];
                    NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                    if (error) *error = exceptionError;
                    return NO;
                }
            }
        }
    }
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.cellTitleLabel.text = @"";
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *textField = self.cellTextField;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    XUI_START_IGNORE_PARTIAL
    if ([textField respondsToSelector:@selector(setSmartDashesType:)]) {
        textField.smartDashesType = UITextSmartDashesTypeNo;
        textField.smartQuotesType = UITextSmartQuotesTypeNo;
        textField.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    }
    XUI_END_IGNORE_PARTIAL
#endif
    
    [self.cellTitleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.cellTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.cellTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.cellTextField setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    self.titleWidthConstraint = [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cellTitleLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    if (XUI_SYSTEM_8) {
        [self.cellTitleLabel addConstraint:self.titleWidthConstraint];
    } else {
        
    }
    
    _maxLength = UINT_MAX;
    [self reloadLeftConstraints];
}

- (void)reloadLeftConstraints {
    if (self.cellTitleLabel.text.length == 0) {
        self.leftConstraint.constant = 0.0;
        if (XUI_SYSTEM_8) {
            self.titleWidthConstraint.active = YES;
        } else {
            if ([self.cellTitleLabel.constraints containsObject:self.titleWidthConstraint]) {
                [self.cellTitleLabel removeConstraint:self.titleWidthConstraint];
            }
        }
    } else {
        self.leftConstraint.constant = self.separatorInset.left; // 20.0 or 15.0, depends on screen size
        if (XUI_SYSTEM_8) {
            self.titleWidthConstraint.active = NO;
        } else {
            if (![self.cellTitleLabel.constraints containsObject:self.titleWidthConstraint]) {
                [self.cellTitleLabel addConstraint:self.titleWidthConstraint];
            }
        }
    }
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
    [self reloadPlaceholderAttributes];
}

- (void)setXui_isSecure:(NSNumber *)xui_isSecure {
    _xui_isSecure = xui_isSecure;
    BOOL isSecure = [xui_isSecure boolValue];
    self.cellTextField.secureTextEntry = isSecure;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    UITextField *textField = self.cellTextField;
    NSTextAlignment alignment = NSTextAlignmentNatural;
    if ([xui_alignment isEqualToString:@"Left"]) {
        alignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        alignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        alignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        alignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        alignment = NSTextAlignmentJustified;
    }
    else {
        alignment = NSTextAlignmentNatural;
    }
    textField.textAlignment = alignment;
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    BOOL readonly = [xui_readonly boolValue];
    self.cellTextField.enabled = !readonly;
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellTitleLabel.text = xui_label;
    [self reloadLeftConstraints];
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    self.cellTextField.text = xui_value;
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellTextField.tintColor = theme.caretColor;
    self.cellTitleLabel.textColor = theme.labelColor;
    self.cellTextField.textColor = theme.textColor;
    [self.cellTextField setColorButtonClearNormal:[theme.textColor colorWithAlphaComponent:0.6]];
    [self.cellTextField setColorButtonClearHighlighted:theme.textColor];
    [self reloadPlaceholderAttributes];
}

- (void)setXui_maxLength:(NSNumber *)xui_maxLength {
    _xui_maxLength = xui_maxLength;
    if (xui_maxLength) {
        _maxLength = [xui_maxLength unsignedIntegerValue];
    }
}

- (void)reloadPlaceholderAttributes {
    UIFont *placeholderFont = nil;
    XUI_START_IGNORE_PARTIAL
    if (XUI_SYSTEM_8_2) {
        placeholderFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
    } else {
        placeholderFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
    }
    XUI_END_IGNORE_PARTIAL
    NSString *placeholder = self.xui_placeholder;
    UIColor *placeholderColor = self.theme.placeholderColor;
    if (placeholder.length > 0 && placeholderColor && placeholderFont) {
        NSDictionary *attributes = @{ NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont };
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:attributes];
        self.cellTextField.attributedPlaceholder = attributedPlaceholder;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.xui_value = textField.text;
    [self.adapter saveDefaultsFromCell:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return textField.text.length + (string.length - range.length) <= self.maxLength;
}

@end
