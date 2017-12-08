//
//  XUIStaticTextCell.m
//  XXTExplorer
//
//  Created by Zheng on 29/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIStaticTextCell.h"
#import "XUIPrivate.h"
#import "XUILogger.h"

static UIEdgeInsets const XUIStaticTextCellPadding = { 8.f, 0.f, 8.f, 0.f };

@interface XUIStaticTextCell ()

@property (weak, nonatomic) IBOutlet UITextView *cellStaticTextView;

@end

@implementation XUIStaticTextCell

+ (BOOL)xibBasedLayout {
    return YES;
}

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return YES;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"alignment": [NSString class],
      @"selectable": [NSNumber class],
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    if (superResult) {
        NSString *checkType = kXUICellFactoryErrorDomain;
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
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    UITextView *textView = self.cellStaticTextView;
    textView.scrollEnabled = NO;
    textView.textContainerInset = XUIStaticTextCellPadding;
    textView.layoutManager.hyphenationFactor = 1.0f;
    UIFont *font = [UIFont systemFontOfSize:17.f];
    BOOL selectable = textView.selectable;
    textView.selectable = YES;
    XUI_START_IGNORE_PARTIAL
    if ([[UIFont class] respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        font = [UIFont systemFontOfSize:17.f weight:UIFontWeightLight];
        textView.font = font;
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
        textView.font = font;
    }
    textView.selectable = selectable;
    XUI_END_IGNORE_PARTIAL
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setXui_label:(NSString *)xui_label {
    [super setXui_label:xui_label];
    NSString *localizedLabel = [self.adapter localizedStringForKey:xui_label value:xui_label];
    self.cellStaticTextView.text = localizedLabel;
}

- (void)setXui_alignment:(NSString *)xui_alignment {
    _xui_alignment = xui_alignment;
    UITextView *textView = self.cellStaticTextView;
    BOOL selectable = textView.selectable;
    textView.selectable = YES;
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
    textView.selectable = selectable;
}

- (void)setXui_selectable:(NSNumber *)xui_selectable {
    _xui_selectable = xui_selectable;
    self.cellStaticTextView.selectable = [xui_selectable boolValue];
}

- (void)setTheme:(XUITheme *)theme {
    [super setTheme:theme];
    self.cellStaticTextView.textColor = theme.labelColor;
    self.cellStaticTextView.tintColor = theme.tintColor;
}

@end
