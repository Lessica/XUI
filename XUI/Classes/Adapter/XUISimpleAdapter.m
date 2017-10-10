//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUISimpleAdapter.h"
#import "XUIBaseCell.h"
#import "XUIPrivate.h"

#import <sys/stat.h>

@interface XUISimpleAdapter ()

@property (nonatomic, strong) NSString *defaultsPath;

@end


@implementation XUISimpleAdapter {

}

@synthesize path = _path, bundle = _bundle, stringsTable = _stringsTable;

- (instancetype)initWithXUIPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
        _bundle = [NSBundle mainBundle];
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        _defaultsPath = [libraryPath stringByAppendingPathComponent:@"uicfg"];
        BOOL setupResult = [self setupWithError:nil];
        if (!setupResult) return nil;
    }
    return self;
}

- (instancetype)initWithXUIPath:(NSString *)path Bundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        _path = path;
        _bundle = bundle ? bundle : [NSBundle mainBundle];
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        _defaultsPath = [libraryPath stringByAppendingPathComponent:@"uicfg"];
        BOOL setupResult = [self setupWithError:nil];
        if (!setupResult) return nil;
    }
    return self;
}

- (BOOL)setupWithError:(NSError **)error {
    if (0 == access(self.defaultsPath.UTF8String, F_OK)) {
        return YES;
    } else if (0 == mkdir(self.defaultsPath.UTF8String, 0755)) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)rootEntryWithError:(NSError **)error {
    NSDictionary *value = self.rawEntry;
    NSMutableDictionary *newValue = [[NSMutableDictionary alloc] initWithDictionary:value];
    NSArray <NSDictionary *> *items = value[@"items"];
    if (![items isKindOfClass:[NSArray class]]) {
        return value;
    }
    NSMutableArray <NSDictionary *> *fixedItems = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (NSDictionary *item in items) {
        id itemFixedValue = item[@"value"];
        if (!itemFixedValue) { // fill with back store
            NSString *itemKey = item[@"key"];
            NSString *itemDefaults = item[@"defaults"];
            id itemRawValue = [self objectForKey:itemKey Defaults:itemDefaults];
            if (itemRawValue) {
                itemFixedValue = itemRawValue;
            }
        }
        if (!itemFixedValue) { // fill with default
            id itemDefaultValue = item[@"default"];
            if (itemDefaultValue) {
                itemFixedValue = itemDefaultValue;
            }
        }
        if (itemFixedValue) {
            NSMutableDictionary *newItem = [[NSMutableDictionary alloc] initWithDictionary:item];
            newItem[@"value"] = itemFixedValue;
            [fixedItems addObject:[newItem copy]];
        } else {
            [fixedItems addObject:item];
        }
    }
    newValue[@"items"] = [fixedItems copy];
    NSString *stringsTable = newValue[@"stringsTable"];
    if ([stringsTable isKindOfClass:[NSString class]]) {
        _stringsTable = stringsTable;
    }
    return [newValue copy];
}

- (void)saveDefaultsFromCell:(XUIBaseCell *)cell {
    [self setObject:cell.xui_value forKey:cell.xui_key Defaults:cell.xui_defaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:XUINotificationEventValueChanged object:cell userInfo:@{}];
}

- (id)objectForKey:(NSString *)key Defaults:(NSString *)identifier {
    NSString *specComponent = nil;
    if (!specComponent) specComponent = identifier;
    if (!specComponent) return nil;
    assert([specComponent isKindOfClass:[NSString class]] && specComponent.length > 0);
    NSString *specPath = [self.defaultsPath stringByAppendingPathComponent:specComponent];
    NSString *specPathExt = [specPath stringByAppendingPathExtension:@"plist"];
    NSMutableDictionary *specDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:specPathExt];
    if (!specDictionary) specDictionary = [@{} mutableCopy];
    NSString *specKey = key;
    if (!specKey) return nil;
    assert ([specKey isKindOfClass:[NSString class]] && specKey.length > 0);
    return specDictionary[specKey];
}

- (void)setObject:(id)obj forKey:(NSString *)key Defaults:(NSString *)identifier {
    NSString *specComponent = nil;
    if (!specComponent) specComponent = identifier;
    if (!specComponent) return;
    assert([specComponent isKindOfClass:[NSString class]] && specComponent.length > 0);
    NSString *specPath = [self.defaultsPath stringByAppendingPathComponent:specComponent];
    NSString *specPathExt = [specPath stringByAppendingPathExtension:@"plist"];
    NSMutableDictionary *specDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:specPathExt];
    if (!specDictionary) specDictionary = [@{} mutableCopy];
    NSString *specKey = key;
    if (!specKey) return;
    assert ([specKey isKindOfClass:[NSString class]] && specKey.length > 0);
    id specValue = obj;
    if (!specValue) return;
    specDictionary[specKey] = specValue;
    [specDictionary writeToFile:specPathExt atomically:YES];
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSString *localized = [self.bundle localizedStringForKey:key value:value table:self.stringsTable];
    return localized ? localized : value;
}

@end
