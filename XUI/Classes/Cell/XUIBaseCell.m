//
// Created by Zheng on 28/07/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIBaseCell.h"
#import "XUILogger.h"
#import "XUIPrivate.h"
#import "XUICellFactory.h"

#import <objc/runtime.h>
#import "UITableViewCell+XUIDisclosureIndicatorColor.h"

NSString * XUIBaseCellReuseIdentifier = @"XUIBaseCellReuseIdentifier";

@interface XUIBaseCell ()

@end

@implementation XUIBaseCell {

}

#pragma mark - Layouts

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

#pragma mark - Property Tests

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
      @"iconRenderingMode": [NSString class],
      @"enabled": [NSNumber class],
      @"height": [NSNumber class]
      } mutableCopy];
    [baseTypes addEntriesFromDictionary:[self.class entryValueTypes]];
    NSString *checkType = kXUICellFactoryErrorDomain;
    for (NSString *pairKey in cellEntry.allKeys) {
        Class pairClass = baseTypes[pairKey];
        if (pairClass) {
            if (![cellEntry[pairKey] isKindOfClass:pairClass]) {
                checkType = kXUICellFactoryErrorInvalidTypeDomain;
                NSString *errorReason = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\", should be \"%@\".", nil, FRAMEWORK_BUNDLE, nil), pairKey, NSStringFromClass(pairClass)];
                NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                if (error) *error = exceptionError;
                return NO;
            }
        }
    }
    {
        NSString *renderingModeString = cellEntry[@"iconRenderingMode"];
        if (renderingModeString) {
            NSArray <NSString *> *validRenderingModes = @[ @"Automatic", @"AlwaysOriginal", @"AlwaysTemplate", ];
            if (![validRenderingModes containsObject:renderingModeString]) {
                checkType = kXUICellFactoryErrorUnknownEnumDomain;
                NSString *errorReason = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"key \"%@\" (\"%@\") is invalid.", nil, FRAMEWORK_BUNDLE, nil), @"iconRenderingMode", renderingModeString];
                NSError *exceptionError = [NSError errorWithDomain:checkType code:400 userInfo:@{ NSLocalizedDescriptionKey: errorReason }];
                if (error) *error = exceptionError;
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Initializers

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
        if (XUI_SYSTEM_8_2) {
            self.textLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        } else {
            self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
        }
        XUI_END_IGNORE_PARTIAL
        self.textLabel.text = nil;
        
        XUI_START_IGNORE_PARTIAL
        if (XUI_SYSTEM_8_2) {
            self.detailTextLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightLight];
        } else {
            self.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
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

#pragma mark - Key Value

- (id)valueForUndefinedKey:(NSString *)key {
    return nil; // do nothing
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

#pragma mark - XUI Setters

- (void)setXui_icon:(NSString *)xui_icon {
    _xui_icon = xui_icon;
    if ([self.class layoutNeedsImageView]) {
        if (xui_icon) {
            NSString *imagePath = [self.adapter.bundle pathForResource:xui_icon ofType:nil];
            self.imageView.image = [self imageWithCurrentRenderingMode:[UIImage imageWithContentsOfFile:imagePath]];
        } else {
            self.imageView.image = nil;
        }
    }
}

- (void)setXui_iconRenderingMode:(NSString *)xui_iconRenderingMode {
    _xui_iconRenderingMode = xui_iconRenderingMode;
    if ([self.class layoutNeedsImageView]) {
        UIImage *originalImage = self.imageView.image;
        if (originalImage)
        {
            self.imageView.image = [self imageWithCurrentRenderingMode:originalImage];
        }
    }
}

- (UIImage *)imageWithCurrentRenderingMode:(UIImage *)image {
    NSString *renderingModeString = _xui_iconRenderingMode;
    UIImageRenderingMode renderingMode = UIImageRenderingModeAutomatic;
    if ([renderingModeString isEqualToString:@"AlwaysOriginal"]) {
        renderingMode = UIImageRenderingModeAlwaysOriginal;
    } else if ([renderingModeString isEqualToString:@"AlwaysTemplate"]) {
        renderingMode = UIImageRenderingModeAlwaysTemplate;
    }
    return [image imageWithRenderingMode:renderingMode];
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

#pragma mark - Overrides

- (BOOL)canDelete {
    return NO;
}

#pragma mark - Internals

- (void)setInternalTheme:(XUITheme *)theme {
    _internalTheme = theme;
    self.tintColor = theme.foregroundColor;
    self.contentView.tintColor = theme.foregroundColor;
    self.backgroundColor = theme.cellBackgroundColor;
    self.textLabel.textColor = theme.labelColor;
    self.detailTextLabel.textColor = theme.valueColor;
    self.xui_disclosureIndicatorColor = theme.disclosureIndicatorColor;
    self.selectedBackgroundView.backgroundColor = theme.selectedColor;
}

- (void)setInternalIconPath:(NSString *)internalIconPath {
    _internalIconPath = internalIconPath;
    if ([self.class layoutNeedsImageView]) {
        if (internalIconPath) {
            NSString *imagePath = [FRAMEWORK_BUNDLE pathForResource:internalIconPath ofType:nil];
            self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        } else {
            self.imageView.image = nil;
        }
    }
}

#pragma mark - Default Values

- (XUITheme *)theme {
    return self.factory.theme;
}

- (id <XUIAdapter>)adapter {
    return self.factory.adapter;
}

- (XUILogger *)logger {
    return self.factory.logger;
}

@end
