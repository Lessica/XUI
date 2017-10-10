//
//  XUITextareaViewController.m
//  XXTExplorer
//
//  Created by Zheng on 10/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUITextareaViewController.h"
#import "XUITextareaCell.h"

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
    
    self.view.backgroundColor = UIColor.whiteColor;
    if ([self.cell.xui_value isKindOfClass:[NSString class]]) {
        self.textView.text = self.cell.xui_value;
    }
    
    BOOL xui_readonly = [self.cell.xui_readonly boolValue];
    self.textView.editable = !xui_readonly;
    
    NSString *xui_alignment = self.cell.xui_alignment;
    if ([xui_alignment isEqualToString:@"left"]) {
        self.textView.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"center"]) {
        self.textView.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"right"]) {
        self.textView.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"natural"]) {
        self.textView.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"justified"]) {
        self.textView.textAlignment = NSTextAlignmentJustified;
    }
    else {
        self.textView.textAlignment = NSTextAlignmentNatural;
    }
    
    NSString *xui_keyboard = self.cell.xui_keyboard;
    if ([xui_keyboard isEqualToString:@"numbers"]) {
        self.textView.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if ([xui_keyboard isEqualToString:@"phone"]) {
        self.textView.keyboardType = UIKeyboardTypePhonePad;
    }
    else if ([xui_keyboard isEqualToString:@"ascii"]) {
        self.textView.keyboardType = UIKeyboardTypeASCIICapable;
    }
    else {
        self.textView.keyboardType = UIKeyboardTypeDefault;
    }
    
    BOOL xui_noAutoCorrect = [self.cell.xui_noAutoCorrect boolValue];
    self.textView.autocorrectionType = xui_noAutoCorrect ? UITextAutocorrectionTypeNo : UITextAutocorrectionTypeYes;
    
    NSString *xui_autoCaps = self.cell.xui_autoCaps;
    if ([xui_autoCaps isEqualToString:@"sentences"]) {
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    }
    else if ([xui_autoCaps isEqualToString:@"words"]) {
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }
    else if ([xui_autoCaps isEqualToString:@"all"]) {
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }
    else if ([xui_autoCaps isEqualToString:@"none"]) {
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    else {
        self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
        
        textView.tintColor = self.theme.tintColor;
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
        
        if (@available(iOS 11.0, *)) {
            textView.smartDashesType = UITextSmartDashesTypeNo;
            textView.smartQuotesType = UITextSmartQuotesTypeNo;
            textView.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
        }
        
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
