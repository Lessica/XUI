//
// Created by Zheng on 28/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"
#import "XUILogger.h"
#import "XUIPrivate.h"

#import <objc/runtime.h>
#import "UITableViewCell+XUIDisclosureIndicatorColor.h"

NSString * XUIBaseCellReuseIdentifier = @"XUIBaseCellReuseIdentifier";

@interface XUIBaseCell ()

@property (nonatomic, strong) XUITheme *theme;

@end

@implementation XUIBaseCell {

}

+ (BOOL)xibBasedLayout {
    return NO;
}

+ (UINib *)cellNib {
    if ([[self class] xibBasedLayout]) {
        static NSMutableDictionary <NSString *, UINib *> *cellNibs = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cellNibs = [[NSMutableDictionary alloc] init];
        });
        NSString *cellName = NSStringFromClass([self class]);
        if (cellNibs[cellName]) {
            return cellNibs[cellName];
        }
        NSBundle *nibBundle = FRAMEWORK_BUNDLE;
        if (!( [nibBundle pathForResource:cellName ofType:@"nib"] )) {
            nibBundle = [NSBundle bundleForClass:[self class]];
        }
        if (!( [nibBundle pathForResource:cellName ofType:@"nib"] )) {
            NSAssert(YES, @"XUI cannot find the xib of \"%@\", please inherit +[XUIBaseCell cellNib] to specify it.", cellName);
            return nil;
        }
        if (nibBundle) {
            UINib *cellNib = [UINib nibWithNibName:cellName bundle:nibBundle];
            if (cellNib) {
                [cellNibs setObject:cellNib forKey:cellName];
                return cellNib;
            }
        }
    }
    return nil;
}

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (BOOL)layoutUsesAutoResizing {
    if (XUI_SYSTEM_8) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSDictionary <NSString *, NSString *> *)entryValueTypes {
    return @{};
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    NSMutableDictionary *baseTypes =
    [@{
      @"cell": [NSString class],
      @"label": [NSString class],
      @"defaults": [NSString class],
      @"key": [NSString class],
      @"icon": [NSString class],
      @"enabled": [NSNumber class],
      @"height": [NSNumber class]
      } mutableCopy];
    [baseTypes addEntriesFromDictionary:[self.class entryValueTypes]];
    BOOL checkResult = YES;
    NSString *checkType = kXUICellFactoryErrorDomain;
    @try {
        for (NSString *pairKey in cellEntry.allKeys) {
            Class pairClass = baseTypes[pairKey];
            if (pairClass) {
                if (![cellEntry[pairKey] isKindOfClass:pairClass]) {
                    checkType = kXUICellFactoryErrorInvalidTypeDomain;
                    @throw [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\", should be \"%@\".", nil, FRAMEWORK_BUNDLE, nil), pairKey, NSStringFromClass(pairClass)];
                }
            }
        }
    } @catch (NSString *exceptionReason) {
        checkResult = NO;
        NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: exceptionReason }];
        if (error) {
            *error = exceptionError;
        }
    } @finally {
        
    }
    return checkResult;
}

- (NSString *)xui_cell {
    return NSStringFromClass([self class]);
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupCell];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self setupCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCell];
}

- (void)setupCell {
    _xui_readonly = @NO;
    if ([self.class layoutRequiresDynamicRowHeight]) {
        _xui_height = @(-1);
    } else {
        _xui_height = @44.f; // standard cell height
    }
    if ([self.class layoutNeedsTextLabel]) {
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            self.textLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightLight];
        } else {
            self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
        }
        XUI_END_IGNORE_PARTIAL
        self.textLabel.text = nil;
        
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_9) {
            self.detailTextLabel.font = [UIFont systemFontOfSize:17.f weight:UIFontWeightLight];
        } else {
            self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.f];
        }
        XUI_END_IGNORE_PARTIAL
        self.detailTextLabel.textColor = UIColor.grayColor;
        self.detailTextLabel.text = nil;
    }
    UIView *selectionBackground = [[UIView alloc] init];
    self.selectedBackgroundView = selectionBackground;
}

- (void)configureCellWithEntry:(NSDictionary *)entry {
    for (NSString *itemKey in entry) {
        if ([itemKey isEqualToString:@"value"]) continue;
        NSString *propertyName = [NSString stringWithFormat:@"xui_%@", itemKey];
        if (class_getProperty([self class], [propertyName UTF8String])) {
            id itemValue = entry[itemKey];
            [self setValue:itemValue forKey:propertyName];
        }
    }
    self.xui_value = entry[@"value"]; // do not change its order
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil; // do nothing
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

- (void)setXui_icon:(NSString *)xui_icon {
    _xui_icon = xui_icon;
    if ([self.class layoutNeedsImageView]) {
        if (xui_icon) {
            NSString *imagePath = [self.adapter.bundle pathForResource:xui_icon ofType:nil];
            self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        } else {
            self.imageView.image = nil;
        }
    }
}

- (void)setXui_label:(NSString *)xui_label {
    _xui_label = xui_label;
    if ([self.class layoutNeedsTextLabel]) {
        self.textLabel.text = [self.adapter localizedStringForKey:xui_label value:xui_label];
    }
}

- (void)setXui_value:(id)xui_value {
    _xui_value = xui_value;
}

- (void)setTheme:(XUITheme *)theme {
    _theme = theme;
    self.tintColor = theme.tintColor;
    self.contentView.tintColor = theme.tintColor;
    self.backgroundColor = theme.backgroundColor;
    self.textLabel.textColor = theme.labelColor;
    self.detailTextLabel.textColor = theme.valueColor;
    self.xui_disclosureIndicatorColor = theme.disclosureIndicatorColor;
    self.selectedBackgroundView.backgroundColor = theme.selectedColor;
}

- (BOOL)canDelete {
    return NO;
}

@end
