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
    self.cellStaticTextView.scrollEnabled = NO;
    XUI_START_IGNORE_PARTIAL
    if (@available(iOS 10.0, *)) {
        self.cellStaticTextView.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightLight];
    } else {
        BOOL selectable = self.cellStaticTextView.selectable;
        self.cellStaticTextView.selectable = YES;
        self.cellStaticTextView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
        self.cellStaticTextView.selectable = selectable;
    }
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
    if ([xui_alignment isEqualToString:@"Left"]) {
        self.cellStaticTextView.textAlignment = NSTextAlignmentLeft;
    }
    else if ([xui_alignment isEqualToString:@"Center"]) {
        self.cellStaticTextView.textAlignment = NSTextAlignmentCenter;
    }
    else if ([xui_alignment isEqualToString:@"Right"]) {
        self.cellStaticTextView.textAlignment = NSTextAlignmentRight;
    }
    else if ([xui_alignment isEqualToString:@"Natural"]) {
        self.cellStaticTextView.textAlignment = NSTextAlignmentNatural;
    }
    else if ([xui_alignment isEqualToString:@"Justified"]) {
        self.cellStaticTextView.textAlignment = NSTextAlignmentJustified;
    }
    else {
        self.cellStaticTextView.textAlignment = NSTextAlignmentNatural;
    }
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
