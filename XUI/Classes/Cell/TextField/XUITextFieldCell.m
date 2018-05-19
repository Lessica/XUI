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

@interface XUITextFieldCell ()

@property (strong, nonatomic) UILabel *cellTitleLabel;
@property (strong, nonatomic) NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *titleWidthConstraint;

@property (nonatomic, assign) NSUInteger maxLength;

@end

@implementation XUITextFieldCell

@synthesize xui_value = _xui_value;

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
      @"clearButtonMode": [NSString class],
      @"prompt": [NSString class],
      @"message": [NSString class],
      @"okTitle": [NSString class],
      @"cancelTitle": [NSString class],
      @"validationRegex": [NSString class],
      };
}

+ (BOOL)testValue:(id)value forKey:(NSString *)key error:(NSError **)error {
    if ([key isEqualToString:@"alignment"]) {
        if (NO == [@[ @"Left", @"Right", @"Center", @"Natural", @"Justified" ] containsObject:value]) {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"alignment", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"keyboard"]) {
        if (NO == [@[ @"Default", @"ASCIICapable", @"NumbersAndPunctuation", @"URL", @"NumberPad", @"PhonePad", @"NamePhonePad", @"EmailAddress", @"DecimalPad", @"Alphabet" ] containsObject:value]) {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"keyboard", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"clearButtonMode"]) {
        if (NO == [@[ @"Never", @"WhileEditing", @"UnlessEditing", @"Always" ] containsObject:value]) {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"clearButtonMode", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorUnknownEnumDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    else if ([key isEqualToString:@"validationRegex"]) {
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:value options:0 error:nil];
        if (!regex)
        {
            NSString *errorReason
            = [NSString stringWithFormat:[XUIStrings localizedStringForString:@"key \"%@\" (\"%@\") is invalid."], @"validationRegex", value];
            NSError *exceptionError
            = [NSError errorWithDomain:kXUICellFactoryErrorInvalidValueDomain code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
            if (error) *error = exceptionError;
            return NO;
        }
    }
    return [super testValue:value forKey:key error:error];
}

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    
    self.cellTitleLabel.text = @"";
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField *textField = self.cellTextField;
    textField.delegate = self;
    [self.class resetTextFieldStatus:textField];
    
    _maxLength = UINT_MAX;
    
    [self.contentView addSubview:self.cellTextField];
    [self.contentView addSubview:self.cellTitleLabel];
    {
        [self.cellTitleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        self.leftConstraint = [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          self.leftConstraint,
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cellTextField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    {
        [self.cellTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.cellTextField setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellTextField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
          ];
        [self.contentView addConstraints:constraints];
    }
    
    self.titleWidthConstraint = [NSLayoutConstraint constraintWithItem:self.cellTitleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    if (XUI_SYSTEM_8) {
        [self.contentView addConstraint:self.titleWidthConstraint];
    }
    
    [self reloadLeftConstraints];
}

- (void)reloadLeftConstraints {
    if (self.cellTitleLabel.text.length == 0) {
        self.leftConstraint.constant = 0.0;
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8) {
            self.titleWidthConstraint.active = YES;
        } else {
            if (![self.contentView.constraints containsObject:self.titleWidthConstraint]) {
                [self.contentView addConstraint:self.titleWidthConstraint];
            }
        }
        XUI_END_IGNORE_PARTIAL
    } else {
        self.leftConstraint.constant = self.separatorInset.left; // 20.0 or 15.0, depends on screen size
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8) {
            self.titleWidthConstraint.active = NO;
        } else {
            if ([self.contentView.constraints containsObject:self.titleWidthConstraint]) {
                [self.contentView removeConstraint:self.titleWidthConstraint];
            }
        }
        XUI_END_IGNORE_PARTIAL
    }
}

#pragma mark - UIView Getters

- (XUITextField *)cellTextField {
    if (!_cellTextField) {
        _cellTextField = [[XUITextField alloc] init];
        _cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _cellTextField.spellCheckingType = UITextSpellCheckingTypeNo;
        _cellTextField.translatesAutoresizingMaskIntoConstraints = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        XUI_START_IGNORE_PARTIAL
        if ([_cellTextField respondsToSelector:@selector(setSmartDashesType:)]) {
            _cellTextField.smartDashesType = UITextSmartDashesTypeNo;
            _cellTextField.smartQuotesType = UITextSmartQuotesTypeNo;
            _cellTextField.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
        }
        XUI_END_IGNORE_PARTIAL
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
        XUI_START_IGNORE_PARTIAL
        if ([_cellTextField respondsToSelector:@selector(setTextContentType:)]) {
            _cellTextField.textContentType = @"";
        }
        XUI_END_IGNORE_PARTIAL
#endif
        [_cellTextField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _cellTextField;
}

- (UILabel *)cellTitleLabel {
    if (!_cellTitleLabel) {
        _cellTitleLabel = [[UILabel alloc] init];
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            _cellTitleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        } else {
            _cellTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
        }
        XUI_END_IGNORE_PARTIAL
        _cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        _cellTitleLabel.numberOfLines = 1;
        _cellTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _cellTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellTitleLabel;
}

#pragma mark - Setters

- (void)setXui_keyboard:(NSString *)xui_keyboard {
    _xui_keyboard = xui_keyboard;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_clearButtonMode:(NSString *)xui_clearButtonMode {
    _xui_clearButtonMode = xui_clearButtonMode;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_placeholder:(NSString *)xui_placeholder {
    _xui_placeholder = xui_placeholder;
    [self.class reloadPlaceholderAttributes:self.cellTextField forTextFieldCell:self];
}

- (void)setXui_isSecure:(NSNumber *)xui_isSecure {
    _xui_isSecure = xui_isSecure;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_readonly:(NSNumber *)xui_readonly {
    [super setXui_readonly:xui_readonly];
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    self.cellTitleLabel.text = xui_label;
    [self reloadLeftConstraints];
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
    [self.class reloadTextAttributes:self.cellTextField forTextFieldCell:self];
}

- (void)setInternalTheme:(XUITheme *)theme {
    [super setInternalTheme:theme];
    self.cellTitleLabel.textColor = theme.labelColor;
    XUITextField *textField = self.cellTextField;
    [textField setColorButtonClearNormal:[theme.textColor colorWithAlphaComponent:0.6]];
    [textField setColorButtonClearHighlighted:theme.textColor];
    [self.class reloadTextAttributes:textField forTextFieldCell:self];
    [self.class reloadPlaceholderAttributes:textField forTextFieldCell:self];
}

- (void)setXui_maxLength:(NSNumber *)xui_maxLength {
    _xui_maxLength = xui_maxLength;
    if (xui_maxLength) {
        _maxLength = [xui_maxLength unsignedIntegerValue];
    }
}

- (void)setXui_prompt:(NSString *)xui_prompt {
    _xui_prompt = xui_prompt;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_message:(NSString *)xui_message {
    _xui_message = xui_message;
    [self.class reloadTextFieldStatus:self.cellTextField forTextFieldCell:self isPrompt:NO];
}

- (void)setXui_validationRegex:(NSString *)xui_validationRegex {
    _xui_validationRegex = xui_validationRegex;
    _validationRegex = [[NSRegularExpression alloc] initWithPattern:xui_validationRegex options:0 error:nil];
}

+ (void)reloadTextAttributes:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell {
    [self reloadTextAttributes:textField forTextFieldCell:cell text:[cell.xui_value copy] theme:cell.theme];
}

+ (void)reloadTextAttributes:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell text:(NSString *)text theme:(XUITheme *)theme {
    UIFont *font = nil;
    XUI_START_IGNORE_PARTIAL
    if (XUI_SYSTEM_8_2) {
        font = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
    }
    XUI_END_IGNORE_PARTIAL
    if (theme.textColor && theme.caretColor && font) {
        NSDictionary *attributes = @{ NSForegroundColorAttributeName: theme.textColor, NSFontAttributeName: font };
        textField.font = font;
        textField.textColor = theme.textColor;
        textField.tintColor = theme.caretColor;
        textField.typingAttributes = attributes;
        if (text)
        {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
            textField.attributedText = attributedText;
        }
    } else if (text) {
        textField.text = text;
    }
    if (theme.isBackgroundDark) {
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
    } else {
        textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    }
}

+ (void)reloadPlaceholderAttributes:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell {
    UIFont *placeholderFont = nil;
    XUI_START_IGNORE_PARTIAL
    if (XUI_SYSTEM_8_2) {
        placeholderFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
    } else {
        placeholderFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
    }
    XUI_END_IGNORE_PARTIAL
    NSString *placeholder = [cell.xui_placeholder copy];
    UIColor *placeholderColor = [cell.theme.placeholderColor copy];
    if (placeholderColor && placeholderFont) {
        NSDictionary *attributes = @{ NSForegroundColorAttributeName: placeholderColor, NSFontAttributeName: placeholderFont };
        if (placeholder) {
            NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:attributes];
            textField.attributedPlaceholder = attributedPlaceholder;
        }
    } else if (placeholder) {
        textField.placeholder = placeholder;
    }
}

+ (void)resetTextFieldStatus:(UITextField *)textField {
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.returnKeyType = UIReturnKeyDone;
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
}

+ (void)reloadTextFieldStatus:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell isPrompt:(BOOL)prompt
{
    BOOL readonly = (cell.xui_readonly != nil && [cell.xui_readonly boolValue] == YES);
    
    if (!prompt) {
        if (XUI_SYSTEM_8 && ((cell.xui_prompt && cell.xui_prompt.length != 0) ||
                             (cell.xui_message && cell.xui_message.length != 0) ||
                             (readonly)))
        {
            textField.enabled = NO;
            if (readonly) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
        }
        else
        {
            textField.enabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSTextAlignment alignment = NSTextAlignmentNatural;
        if ([cell.xui_alignment isEqualToString:@"Left"]) {
            alignment = NSTextAlignmentLeft;
        }
        else if ([cell.xui_alignment isEqualToString:@"Center"]) {
            alignment = NSTextAlignmentCenter;
        }
        else if ([cell.xui_alignment isEqualToString:@"Right"]) {
            alignment = NSTextAlignmentRight;
        }
        else if ([cell.xui_alignment isEqualToString:@"Natural"]) {
            alignment = NSTextAlignmentNatural;
        }
        else if ([cell.xui_alignment isEqualToString:@"Justified"]) {
            alignment = NSTextAlignmentJustified;
        }
        else {
            alignment = NSTextAlignmentNatural;
        }
        textField.textAlignment = alignment;
    }
    
    BOOL isSecure = (cell.xui_isSecure != nil && [cell.xui_isSecure boolValue] == YES);
    textField.secureTextEntry = isSecure;
    
    UIKeyboardType keyboardType = UIKeyboardTypeDefault;
    if ([cell.xui_keyboard isEqualToString:@"Default"]) {
        keyboardType = UIKeyboardTypeDefault;
    }
    else if ([cell.xui_keyboard isEqualToString:@"ASCIICapable"]) {
        keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([cell.xui_keyboard isEqualToString:@"NumbersAndPunctuation"]) {
        keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([cell.xui_keyboard isEqualToString:@"URL"]) {
        keyboardType = UIKeyboardTypeURL;
    }
    else if ([cell.xui_keyboard isEqualToString:@"NumberPad"]) {
        keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([cell.xui_keyboard isEqualToString:@"PhonePad"]) {
        keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([cell.xui_keyboard isEqualToString:@"NamePhonePad"]) {
        keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if ([cell.xui_keyboard isEqualToString:@"EmailAddress"]) {
        keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([cell.xui_keyboard isEqualToString:@"DecimalPad"]) {
        keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([cell.xui_keyboard isEqualToString:@"Alphabet"]) {
        keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        keyboardType = UIKeyboardTypeDefault;
    }
    textField.keyboardType = keyboardType;
    
    UITextFieldViewMode clearButtonMode = UITextFieldViewModeNever;
    if ([cell.xui_clearButtonMode isEqualToString:@"Never"]) {
        clearButtonMode = UITextFieldViewModeNever;
    } else if ([cell.xui_clearButtonMode isEqualToString:@"Always"]) {
        clearButtonMode = UITextFieldViewModeAlways;
    } else if ([cell.xui_clearButtonMode isEqualToString:@"WhileEditing"]) {
        clearButtonMode = UITextFieldViewModeWhileEditing;
    } else if ([cell.xui_clearButtonMode isEqualToString:@"UnlessEditing"]) {
        clearButtonMode = UITextFieldViewModeUnlessEditing;
    }
    textField.clearButtonMode = clearButtonMode;
}

- (void)setValidated:(BOOL)validated {
    [super setValidated:validated];
    if (validated) {
        self.cellTitleLabel.textColor = self.theme.labelColor;
        self.cellTextField.textColor = self.theme.textColor;
    } else {
        self.cellTitleLabel.textColor = self.theme.dangerColor;
        self.cellTextField.textColor = self.theme.dangerColor;
    }
}

+ (void)savePrompt:(UITextField *)textField forTextFieldCell:(XUITextFieldCell *)cell {
    NSString *content = textField.text;
    cell.xui_value = content ? [NSString stringWithString:content] : nil;
    [cell.adapter saveDefaultsFromCell:cell];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField == self.cellTextField)
    {
        NSString *raw = self.xui_value;
        NSRegularExpression *validationRegex = self.validationRegex;
        NSString *content = textField.text;
        if ([content isEqualToString:raw]) {
            [self setValidated:YES];
        } else {
            if (validationRegex)
            {
                NSTextCheckingResult *result
                = [validationRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
                if (!result)
                { // validation failed, show red
                    [self setValidated:NO];
                }
                else
                { // restore color
                    [self setValidated:YES];
                }
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.cellTextField)
    {
        NSString *raw = self.xui_value;
        NSRegularExpression *validationRegex = self.validationRegex;
        NSString *content = textField.text;
        if ([content isEqualToString:raw]) {
            return; // skip save
        } else {
            if (validationRegex)
            {
                NSTextCheckingResult *result
                = [validationRegex firstMatchInString:content options:0 range:NSMakeRange(0, content.length)];
                if (!result)
                { // validation failed, restore to raw content.
                    textField.text = raw;
                    [self setValidated:YES];
                    return;
                }
            }
        }
        [self setValidated:YES];
        [self.class savePrompt:textField forTextFieldCell:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return textField.text.length + (string.length - range.length) <= self.maxLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
