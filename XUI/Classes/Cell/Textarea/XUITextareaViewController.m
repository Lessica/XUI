//
//  XUITextareaViewController.m
//  XXTExplorer
//
//  Created by Zheng on 10/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITextareaViewController.h"
#import "XUITextareaCell.h"
#import "XUIPrivate.h"

@interface XUITextareaViewController () <UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) NSUInteger maxLength;

@end

@implementation XUITextareaViewController

- (instancetype)initWithCell:(XUITextareaCell *)cell {
    self = [super init];
    if (self) {
        _cell = cell;
        
        _maxLength = UINT_MAX;
        if (cell.xui_maxLength != nil) {
            _maxLength = [cell.xui_maxLength unsignedIntegerValue];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerKeyboardNotifications];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self dismissKeyboardNotifications];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textView = self.textView;
    
    self.view.backgroundColor = UIColor.whiteColor;
    if ([self.cell.xui_value isKindOfClass:[NSString class]]) {
        textView.text = self.cell.xui_value;
    }
    
    BOOL xui_readonly = [self.cell.xui_readonly boolValue];
    textView.editable = !xui_readonly;
    
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    XUI_START_IGNORE_PARTIAL
    if ([textView respondsToSelector:@selector(smartDashesType)]) {
        textView.smartDashesType = UITextSmartDashesTypeNo;
        textView.smartQuotesType = UITextSmartQuotesTypeNo;
        textView.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    }
    XUI_END_IGNORE_PARTIAL
#endif
    
    XUITheme *theme = self.theme;
    self.view.backgroundColor = theme.backgroundColor;
    textView.backgroundColor = theme.backgroundColor;
    textView.textColor = theme.textColor;
    textView.tintColor = theme.caretColor;
    
    NSString *xui_alignment = self.cell.xui_alignment;
    if ([xui_alignment isEqualToString:@"Left"]) {
        textView.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        textView.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        textView.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        textView.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        textView.textAlignment = NSTextAlignmentJustified;
    }
    else {
        textView.textAlignment = NSTextAlignmentNatural;
    }
    
    NSString *xui_keyboard = self.cell.xui_keyboard;
    if ([xui_keyboard isEqualToString:@"Default"]) {
        textView.keyboardType = UIKeyboardTypeDefault;
    }
    else if ([xui_keyboard isEqualToString:@"ASCIICapable"]) {
        textView.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else if ([xui_keyboard isEqualToString:@"NumbersAndPunctuation"]) {
        textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else if ([xui_keyboard isEqualToString:@"URL"]) {
        textView.keyboardType = UIKeyboardTypeURL;
    }
    else if ([xui_keyboard isEqualToString:@"NumberPad"]) {
        textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"PhonePad"]) {
        textView.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"NamePhonePad"]) {
        textView.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"EmailAddress"]) {
        textView.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if ([xui_keyboard isEqualToString:@"DecimalPad"]) {
        textView.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else if ([xui_keyboard isEqualToString:@"Alphabet"]) {
        textView.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        textView.keyboardType = UIKeyboardTypeDefault;
    }
    
    NSString *xui_autoCorrection = self.cell.xui_autoCorrection;
    if ([xui_autoCorrection isEqualToString:@"Default"]) {
        textView.autocorrectionType = UITextAutocorrectionTypeDefault;
    }
    else if ([xui_autoCorrection isEqualToString:@"No"]) {
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    else if ([xui_autoCorrection isEqualToString:@"Yes"]) {
        textView.autocorrectionType = UITextAutocorrectionTypeYes;
    }
    else {
        textView.autocorrectionType = UITextAutocorrectionTypeDefault;
    }
    
    NSString *xui_autoCapitalization = self.cell.xui_autoCapitalization;
    if ([xui_autoCapitalization isEqualToString:@"Sentences"]) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([xui_autoCapitalization isEqualToString:@"Words"]) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([xui_autoCapitalization isEqualToString:@"AllCharacters"]) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    else if ([xui_autoCapitalization isEqualToString:@"None"]) {
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else {
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.textView];
}

#pragma mark - Keyboard Events

- (void)registerKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dismissKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardDidAppear:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.textView.contentInset = contentInsets;
    self.textView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    UITextView *textView = self.textView;
    UITextRange * selectionRange = [textView selectedTextRange];
    CGRect selectionStartRect = [textView caretRectForPosition:selectionRange.start];
    CGRect selectionEndRect = [textView caretRectForPosition:selectionRange.end];
    CGPoint selectionCenterPoint = (CGPoint){(selectionStartRect.origin.x + selectionEndRect.origin.x)/2,(selectionStartRect.origin.y + selectionStartRect.size.height / 2)};
    
    if (!CGRectContainsPoint(aRect, selectionCenterPoint) ) {
        [textView scrollRectToVisible:CGRectMake(selectionStartRect.origin.x, selectionStartRect.origin.y, selectionEndRect.origin.x - selectionStartRect.origin.x, selectionStartRect.size.height) animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillDisappear:(NSNotification *)aNotification
{
    UITextView *textView = self.textView;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    textView.contentInset = contentInsets;
    textView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UIView Getters

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        
        textView.tintColor = self.theme.foregroundColor;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyDefault;
        textView.dataDetectorTypes = UIDataDetectorTypeNone;
        textView.autocorrectionType = NO;
        textView.autocapitalizationType = NO;
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        textView.alwaysBounceVertical = YES;
        
        textView.textColor = UIColor.blackColor;
        textView.font = [UIFont systemFontOfSize:14.f];
        textView.textContainerInset = UIEdgeInsetsMake(12.0, 8.0, 12.0, 8.0);
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        XUI_START_IGNORE_PARTIAL
        if ([textView respondsToSelector:@selector(smartDashesType)]) {
            textView.smartDashesType = UITextSmartDashesTypeNo;
            textView.smartQuotesType = UITextSmartQuotesTypeNo;
            textView.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
        }
        XUI_END_IGNORE_PARTIAL
#endif
        
        _textView = textView;
    }
    return _textView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.textView) {
        self.cell.xui_value = textView.text;
        if ([_delegate respondsToSelector:@selector(textareaViewControllerTextDidChanged:)]) {
            [_delegate textareaViewControllerTextDidChanged:self];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= self.maxLength;
}

@end
