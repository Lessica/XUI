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
      @"autoCaps": [NSString class],
      @"placeholder": [NSString class],
      @"bestGuess": [NSString class],
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
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"alignment", alignmentString];
            }
        }
        NSString *keyboardString = cellEntry[@"keyboard"];
        if (keyboardString) {
            NSArray <NSString *> *validKeyboard = @[ @"numbers", @"phone", @"ascii", @"default" ];
            if (![validKeyboard containsObject:keyboardString]) {
                superResult = NO;
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"keyboard", alignmentString];
            }
        }
        NSString *autoCapsString = cellEntry[@"autoCaps"];
        if (autoCapsString) {
            NSArray <NSString *> *validAutoCaps = @[ @"sentences", @"words", @"all", @"none" ];
            if (![validAutoCaps containsObject:autoCapsString]) {
                superResult = NO;
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"autoCaps", alignmentString];
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
    self.cellSecureTextField.delegate = self;
    self.cellSecureTextField.secureTextEntry = YES;
    self.cellSecureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)setXui_keyboard:(NSString *)xui_keyboard {
    _xui_keyboard = xui_keyboard;
    if ([xui_keyboard isEqualToString:@"numbers"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"phone"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"ascii"]) {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        self.cellSecureTextField.keyboardType = UIKeyboardTypeDefault;
    }
}

- (void)setXui_autoCaps:(NSString *)xui_autoCaps {
    _xui_autoCaps = xui_autoCaps;
    if ([xui_autoCaps isEqualToString:@"sentences"]) {
        self.cellSecureTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([xui_autoCaps isEqualToString:@"words"]) {
        self.cellSecureTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([xui_autoCaps isEqualToString:@"all"]) {
        self.cellSecureTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    else {
        self.cellSecureTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
}

- (void)setXui_placeholder:(NSString *)xui_placeholder {
    _xui_placeholder = xui_placeholder;
    self.cellSecureTextField.placeholder = xui_placeholder;
}

- (void)setXui_bestGuess:(NSString *)xui_bestGuess {
    _xui_bestGuess = xui_bestGuess;
    self.cellSecureTextField.text = xui_bestGuess;
}

- (void)setXui_noAutoCorrect:(NSNumber *)xui_noAutoCorrect {
    _xui_noAutoCorrect = xui_noAutoCorrect;
    BOOL noAutoCorrect = [xui_noAutoCorrect boolValue];
    self.cellSecureTextField.autocorrectionType = noAutoCorrect ? UITextAutocorrectionTypeNo : UITextAutocorrectionTypeYes;
}

- (void)setXui_isIP:(NSNumber *)xui_isIP {
    _xui_isIP = xui_isIP;
    self.cellSecureTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setXui_isURL:(NSNumber *)xui_isURL {
    _xui_isURL = xui_isURL;
    self.cellSecureTextField.keyboardType = UIKeyboardTypeURL;
}

- (void)setXui_isEmail:(NSNumber *)xui_isEmail {
    _xui_isEmail = xui_isEmail;
    self.cellSecureTextField.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)setXui_isNumeric:(NSNumber *)xui_isNumeric {
    _xui_isNumeric = xui_isNumeric;
    self.cellSecureTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)setXui_isDecimalPad:(NSNumber *)xui_isDecimalPad {
    _xui_isDecimalPad = xui_isDecimalPad;
    self.cellSecureTextField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    if ([xui_alignment isEqualToString:@"left"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"center"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"right"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"natural"]) {
        self.cellSecureTextField.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"justified"]) {
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
