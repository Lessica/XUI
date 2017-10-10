//
//  XUITextFieldCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITextFieldCell.h"
#import "XUILogger.h"

@interface XUITextFieldCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellTextField;

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
      @"autoCaps": [NSString class],
      @"placeholder": [NSString class],
      @"noAutoCorrect": [NSNumber class],
      @"isIP": [NSNumber class],
      @"isURL": [NSNumber class],
      @"isNumeric": [NSNumber class],
      @"isDecimalPad": [NSNumber class],
      @"isEmail": [NSNumber class],
      @"value": [NSString class]
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    NSString *checkType = kXUICellFactoryErrorDomain;
    @try {
        NSString *alignmentString = cellEntry[@"alignment"];
        if (alignmentString) {
            NSArray <NSString *> *validAlignment = @[ @"left", @"right", @"center", @"natural", @"justified" ];
            if (![validAlignment containsObject:alignmentString]) {
                superResult = NO;
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, [NSBundle bundleForClass:[self class]], nil), @"alignment", alignmentString];
            }
        }
        NSString *keyboardString = cellEntry[@"keyboard"];
        if (keyboardString) {
            NSArray <NSString *> *validKeyboard = @[ @"numbers", @"phone", @"ascii", @"default" ];
            if (![validKeyboard containsObject:keyboardString]) {
                superResult = NO;
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, [NSBundle bundleForClass:[self class]], nil), @"keyboard", keyboardString];
            }
        }
        NSString *autoCapsString = cellEntry[@"autoCaps"];
        if (autoCapsString) {
            NSArray <NSString *> *validAutoCaps = @[ @"sentences", @"words", @"all", @"none" ];
            if (![validAutoCaps containsObject:autoCapsString]) {
                superResult = NO;
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, [NSBundle bundleForClass:[self class]], nil), @"autoCaps", autoCapsString];
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
    self.cellTextField.delegate = self;
    self.cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setXui_keyboard:(NSString *)xui_keyboard {
    _xui_keyboard = xui_keyboard;
    if ([xui_keyboard isEqualToString:@"numbers"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"phone"]) {
        self.cellTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"ascii"]) {
        self.cellTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        self.cellTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setXui_autoCaps:(NSString *)xui_autoCaps {
    _xui_autoCaps = xui_autoCaps;
    if ([xui_autoCaps isEqualToString:@"sentences"]) {
        self.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([xui_autoCaps isEqualToString:@"words"]) {
        self.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([xui_autoCaps isEqualToString:@"all"]) {
        self.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    else if ([xui_autoCaps isEqualToString:@"none"]) {
        self.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else {
        self.cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
}

- (void)setXui_placeholder:(NSString *)xui_placeholder {
    _xui_placeholder = xui_placeholder;
    self.cellTextField.placeholder = xui_placeholder;
}

- (void)setXui_noAutoCorrect:(NSNumber *)xui_noAutoCorrect {
    _xui_noAutoCorrect = xui_noAutoCorrect;
    BOOL noAutoCorrect = [xui_noAutoCorrect boolValue];
    self.cellTextField.autocorrectionType = noAutoCorrect ? UITextAutocorrectionTypeNo : UITextAutocorrectionTypeYes;
}

- (void)setXui_isIP:(NSNumber *)xui_isIP {
    _xui_isIP = xui_isIP;
    self.cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setXui_isURL:(NSNumber *)xui_isURL {
    _xui_isURL = xui_isURL;
    self.cellTextField.keyboardType = UIKeyboardTypeURL;
}

- (void)setXui_isEmail:(NSNumber *)xui_isEmail {
    _xui_isEmail = xui_isEmail;
    self.cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)setXui_isNumeric:(NSNumber *)xui_isNumeric {
    _xui_isNumeric = xui_isNumeric;
    self.cellTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setXui_isDecimalPad:(NSNumber *)xui_isDecimalPad {
    _xui_isDecimalPad = xui_isDecimalPad;
    self.cellTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"left"]) {
        self.cellTextField.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"center"]) {
        self.cellTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"right"]) {
        self.cellTextField.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"natural"]) {
        self.cellTextField.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"justified"]) {
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
