//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIAdapter_plist.h"
#import "XUIBaseCell.h"

// Root
// PreferenceSpecifiers -> items
// StringsTable -> stringsTable

// Specifiers
// PSTextFieldSpecifier -> TextField
// PSTitleValueSpecifier -> TitleValue
// PSToggleSwitchSpecifier -> Switch
// PSSliderSpecifier -> Slider
// PSMultiValueSpecifier -> MultipleOption
// PSRadioGroupSpecifier -> Option
// PSGroupSpecifier -> Group
// PSChildPaneSpecifier -> Link

@implementation XUIAdapter_plist

@synthesize rawEntry = _rawEntry;

- (BOOL)setupWithError:(NSError **)error {
    if (![super setupWithError:error]) {
        return NO;
    }
    id value = [[NSDictionary alloc] initWithContentsOfFile:self.path];
    if (![value isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (value[@"PreferenceSpecifiers"])
    { // Apple Settings Application Schema
        _rawEntry = [self xuiSchemaForSchema:value];
    }
    else if (value[@"items"])
    { // XUI Schema
        _rawEntry = value;
    }
    else
    { // Unknown Schema
        return NO;
    }
    return YES;
}

- (NSDictionary *)xuiSchemaForSchema:(NSDictionary *)raw {
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc] init];
    if ([raw[@"PreferenceSpecifiers"] isKindOfClass:[NSDictionary class]])
    {
        NSArray <NSDictionary *> *specifiers = raw[@"PreferenceSpecifiers"];
        NSMutableArray <NSDictionary *> *mutableSpecifiers = [[NSMutableArray alloc] init];
        for (NSDictionary *specifier in specifiers) {
            if (![specifier isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            NSDictionary *newSpecifier = [self xuiItemForSchemaItem:specifier];
            if (newSpecifier) {
                mutableSpecifiers = newSpecifier;
            }
        }
        mutable[@"items"] = [mutableSpecifiers copy];
    }
    else
    {
        mutable[@"items"] = @[];
    }
    if ([raw[@"StringsTable"] isKindOfClass:[NSString class]])
    {
        mutable[@"stringsTable"] = raw[@"StringsTable"];
    }
    return [mutable copy];
}

- (NSDictionary *)xuiItemForSchemaItem:(NSDictionary *)specifier {
    NSString *specType = specifier[@"Type"];
    if (![specType isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSMutableDictionary *xuiItem = [[NSMutableDictionary alloc] init];
    if ([specType isEqualToString:@"PSTextFieldSpecifier"])
    {
        specType = @"TextField";
    }
    for (NSString *specKey in specifier) {
        id specValue = specifier[specKey];
        if ([specKey isEqualToString:@"Type"]) {
            xuiItem[@"cell"] = specType;
        }
        else if ([specKey isEqualToString:@"Title"]) {
            xuiItem[@"label"] = specValue;
        }
        else if ([specKey isEqualToString:@"Key"]) {
            xuiItem[@"key"] = specValue;
        }
        else if ([specKey isEqualToString:@"DefaultValue"]) {
            xuiItem[@"default"] = specValue;
        }
        else if ([specKey isEqualToString:@"IsSecure"]) {
            xuiItem[@"isSecure"] = specValue;
        }
        else if ([specKey isEqualToString:@"KeyboardType"]) {
            xuiItem[@"keyboard"] = specValue;
        }
    }
    return [xuiItem copy];
}

@end
