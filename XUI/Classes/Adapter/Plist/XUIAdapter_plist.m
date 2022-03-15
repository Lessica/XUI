//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIAdapter_plist.h"
#import "XUIBaseCell.h"
#import "XUIOptionModel.h"

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
    NSMutableDictionary *mutable = [[NSMutableDictionary alloc] initWithDictionary:raw];
    if ([raw[@"PreferenceSpecifiers"] isKindOfClass:[NSArray class]])
    {
        NSArray <NSDictionary *> *specifiers = raw[@"PreferenceSpecifiers"];
        NSMutableArray <NSDictionary *> *mutableSpecifiers = [[NSMutableArray alloc] init];
        for (NSDictionary *specifier in specifiers) {
            if (![specifier isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            NSDictionary *newSpecifier = [self xuiItemForSchemaItem:specifier];
            if (newSpecifier) {
                [mutableSpecifiers addObject:newSpecifier];
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
    if (![specType isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    NSMutableDictionary *xuiItem = [[NSMutableDictionary alloc] init];
    BOOL shouldProcessOptions = NO;
    
    if ([specType isEqualToString:@"PSGroupSpecifier"])
    {
        specType = @"Group";
    }
    else if ([specType isEqualToString:@"PSChildPaneSpecifier"])
    {
        specType = @"Link";
    }
    else if ([specType isEqualToString:@"PSToggleSwitchSpecifier"])
    {
        specType = @"Switch";
    }
    else if ([specType isEqualToString:@"PSSliderSpecifier"])
    {
        specType = @"Slider";
    }
    else if ([specType isEqualToString:@"PSTitleValueSpecifier"])
    {
        specType = @"TitleValue";
    }
    else if ([specType isEqualToString:@"PSTextFieldSpecifier"])
    {
        specType = @"TextField";
    }
    else if ([specType isEqualToString:@"PSMultiValueSpecifier"])
    {
        specType = @"Option";
        shouldProcessOptions = YES;
    }
    else if ([specType isEqualToString:@"PSRadioGroupSpecifier"])
    {
        specType = @"Option";
        shouldProcessOptions = YES;
    }
    else if ([specType isEqualToString:@"PSCheckboxGroupSpecifier"])
    {
        specType = @"MultipleOption";
        shouldProcessOptions = YES;
    }
    else
    { // not supported
        return nil;
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
        // Group
        else if ([specKey isEqualToString:@"FooterText"]) {
            xuiItem[@"footerText"] = specValue;
        }
        // Link
        else if ([specKey isEqualToString:@"File"]) {
            if ([specValue isKindOfClass:[NSString class]]) {
                xuiItem[@"url"] = [specValue stringByAppendingPathExtension:@"plist"];
            }
        }
        // Switch
        else if ([specKey isEqualToString:@"TrueValue"]) {
            xuiItem[@"trueValue"] = specValue;
        }
        else if ([specKey isEqualToString:@"FalseValue"]) {
            xuiItem[@"falseValue"] = specValue;
        }
        // Slider
        else if ([specKey isEqualToString:@"MinimumValue"]) {
            xuiItem[@"min"] = specValue;
        }
        else if ([specKey isEqualToString:@"MaximumValue"]) {
            xuiItem[@"max"] = specValue;
        }
        // TitleValue
        // -
        // TextField
        else if ([specKey isEqualToString:@"IsSecure"]) {
            xuiItem[@"isSecure"] = specValue;
        }
        else if ([specKey isEqualToString:@"KeyboardType"]) {
            xuiItem[@"keyboard"] = specValue;
        }
        // MultipleOption
        // Option
        else if ([specKey isEqualToString:@"Values"]) {
            continue; // skip
        }
        else if ([specKey isEqualToString:@"Titles"]) {
            continue; // skip
        }
        else if ([specKey isEqualToString:@"ShortTitles"]) {
            continue; // skip
        }
        else if ([specKey isEqualToString:@"Icons"]) {
            continue; // skip
        }
        // Additional properties
        else {
            xuiItem[specKey] = specValue;
        }
    }
    
    // Processing options
    NSArray *rawValues = specifier[@"Values"];
    NSArray <NSString *> *rawTitles = specifier[@"Titles"];
    NSArray <NSString *> *rawShortTitles = specifier[@"ShortTitles"];
    NSArray <NSString *> *rawIcons = specifier[@"Icons"];
    if (
        shouldProcessOptions && // type contains options
        [rawValues isKindOfClass:[NSArray class]] && // raw values must be an array
        [rawTitles isKindOfClass:[NSArray class]] && // raw titles must be an array
        rawTitles.count == rawValues.count && // raw values and raw titles must match
        (!rawShortTitles || // raw short titles can be null
         ( // but if raw short titles exist
          [rawShortTitles isKindOfClass:[NSArray class]] && // it should be an array
          rawShortTitles.count == rawValues.count // and raw values and raw short titles must match
          )) &&
        (!rawIcons || // raw icons can be null
         ( // but if raw icons exist
          [rawIcons isKindOfClass:[NSArray class]] && // it should be an array
          rawIcons.count == rawValues.count // and raw values and raw short titles must match
          ))
        )
    {
        NSMutableArray <NSDictionary *> *xuiOptions = [[NSMutableArray alloc] init];
        for (NSUInteger idx = 0; idx < rawValues.count; idx++) {
            NSMutableDictionary *optionItem = [[NSMutableDictionary alloc] init];
            id rawValue = rawValues[idx];
            optionItem[XUIOptionValueKey] = rawValue;
            NSString *rawTitle = rawTitles[idx];
            if ([rawTitle isKindOfClass:[NSString class]]) {
                optionItem[XUIOptionTitleKey] = rawTitle;
            }
            if (rawShortTitles) {
                NSString *rawShortTitle = rawShortTitles[idx];
                if ([rawShortTitle isKindOfClass:[NSString class]]) {
                    optionItem[XUIOptionShortTitleKey] = rawShortTitle;
                }
            }
            if (rawIcons) {
                NSString *rawIcon = rawIcons[idx];
                if ([rawIcon isKindOfClass:[NSString class]]) {
                    optionItem[XUIOptionIconKey] = rawIcon;
                }
            }
            [xuiOptions addObject:[optionItem copy]];
        }
        xuiItem[@"options"] = [xuiOptions copy];
    }
    
    return [xuiItem copy];
}

@end
