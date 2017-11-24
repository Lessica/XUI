//
//  XUICellFactory.m
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <objc/runtime.h>
#import "XUIPrivate.h"
#import "XUICellFactory.h"
#import "XUIBaseCell.h"
#import "XUIGroupCell.h"
#import "XUILogger.h"
#import "XUITheme.h"

void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
//    XUICellFactory *cellFactory = (__bridge XUICellFactory *)(observer);
    
}

@interface XUICellFactory ()

@end

@implementation XUICellFactory

#pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
        _parsed = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuiValueChanged:) name:XUINotificationEventValueChanged object:nil];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), notificationCallback, ((__bridge CFStringRef)@""), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    }
    return self;
}

- (void)dealloc {
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), ((__bridge CFStringRef)@""), NULL);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Parse

- (void)parsePath:(NSString *)path Bundle:(NSBundle *)bundle {
    assert(!self.parsed);
    NSBundle *frameworkBundle = FRAMEWORK_BUNDLE;
    NSAssert(frameworkBundle, @"Cannot find XUI Framework Bundle.");
    
    if (!_adapter) {
        NSString *entryExtension = [path pathExtension];
        NSString *adapterName = [NSString stringWithFormat:@"XUIAdapter_%@", [entryExtension lowercaseString]];
        Class adapterClass = NSClassFromString(adapterName);
        if (!adapterClass) {
            [self callbackWithErrorReason:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Cannot find suitable adapter for \"%@\".", nil, frameworkBundle, nil), path]];
            return;
        }
        id <XUIAdapter> adapter = (id <XUIAdapter>) [[(id)adapterClass alloc] initWithXUIPath:path Bundle:bundle];
        if (!adapter) {
            [self callbackWithErrorReason:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Cannot initialize \"%@\".", nil, frameworkBundle, nil), adapterName]];
            return;
        }
        _adapter = adapter;
    }
    if (!_logger) {
        _logger = [[XUILogger alloc] init];
    }
    if (!_theme) {
        _theme = [[XUITheme alloc] init];
    }
    {
        _rootEntry = nil;
        NSError *adapterError = nil;
        NSDictionary *rootEntry = [self.adapter rootEntryWithError:&adapterError];
        if (adapterError) {
            [self callbackWithErrorReason:[adapterError localizedDescription]];
            return;
        }
        _rootEntry = rootEntry;
    }
    
    // check theme
    NSDictionary *themeDictionary = self.rootEntry[@"theme"];
    if ([themeDictionary isKindOfClass:[NSDictionary class]])
        _theme = [[XUITheme alloc] initWithDictionary:themeDictionary];
    
    // check items
    NSArray <NSDictionary *> *items = self.rootEntry[@"items"];
    if (!items)
        [self callbackWithErrorReason:XUIParserErrorMissingEntry(@"items")];
    if (![items isKindOfClass:[NSArray class]])
        [self callbackWithErrorReason:XUIParserErrorInvalidType(@"items", @"NSArray")];
    NSUInteger itemCount = items.count;
    if (itemCount <= 0)
        [self callbackWithErrorReason:XUIParserErrorEmptyWarning(@"items")];
    
    // generate cells
    NSMutableArray <XUIBaseCell *> *cells = [[NSMutableArray alloc] initWithCapacity:itemCount];
    for (NSUInteger itemIdx = 0; itemIdx < itemCount; itemIdx++) {
        NSDictionary *itemDictionary = items[itemIdx];
        NSString *cellName = itemDictionary[@"cell"];
        if (!cellName) {
            [self.logger logMessage:[NSString stringWithFormat:XUIParserErrorMissingEntry(@"items[%lu] -> cell"), itemIdx]];
            continue;
        }
        if (![cellName isKindOfClass:[NSString class]]) {
            [self.logger logMessage:[NSString stringWithFormat:XUIParserErrorInvalidType(@"items[%lu] -> cell", @"NSString"), itemIdx]];
            continue;
        }
        NSString *cellClassName = [NSString stringWithFormat:@"XUI%@Cell", cellName];
        Class cellClass = NSClassFromString(cellClassName);
        if (!cellClass || ![cellClass isSubclassOfClass:[XUIBaseCell class]]) {
            [self.logger logMessage:[NSString stringWithFormat:XUIParserErrorUnknownEnum(@"items[%lu] -> cell", cellClassName), itemIdx]];
            continue;
        }
        XUIBaseCell *cellInstance = nil;
        if ([[cellClass class] xibBasedLayout]) {
            cellInstance = [[[[cellClass class] cellNib] instantiateWithOwner:self options:nil] lastObject];
        } else {
            cellInstance = [[cellClass alloc] init];
        }
        NSError *checkError = nil;
        BOOL checkResult = [[cellInstance class] testEntry:itemDictionary withError:&checkError];
        if (!checkResult) {
            [self.logger logMessage:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"[%@]\nPath \"items[%lu]\", %@", nil, frameworkBundle, nil), checkError.domain, itemIdx, checkError.localizedDescription]];
            continue;
        }
        cellInstance.adapter = self.adapter;
        XUITheme *theme = nil;
        NSDictionary *itemTheme = itemDictionary[@"theme"];
        if ([itemTheme isKindOfClass:[NSDictionary class]]) {
            theme = [[XUITheme alloc] initWithDictionary:itemTheme];
        } else {
            theme = self.theme;
        }
        if (theme) {
            cellInstance.theme = theme;
        }
        NSArray <NSString *> *itemAllKeys = [itemDictionary allKeys];
        for (NSUInteger keyIdx = 0; keyIdx < itemAllKeys.count; ++keyIdx) {
            NSString *itemKey = itemAllKeys[keyIdx];
            id itemValue = itemDictionary[itemKey];
            [self testObject:itemValue forKey:itemKey forCellInstance:cellInstance atIndex:itemIdx]; // test property
        }
        [cellInstance configureCellWithEntry:itemDictionary];
        [cells addObject:cellInstance];
    }
    
    // generate group cells
    NSMutableArray <XUIGroupCell *> *groupCells = [[NSMutableArray alloc] init];
    for (XUIBaseCell *baseCell in cells) {
        if ([baseCell isKindOfClass:[XUIGroupCell class]])
        {
            XUIGroupCell *groupCell = (XUIGroupCell *) baseCell;
            [groupCells addObject:groupCell];
        }
    }
    XUIBaseCell *firstCell = cells.firstObject;
    if (![firstCell isKindOfClass:[XUIGroupCell class]]) {
        XUIGroupCell *groupCell1 = [[XUIGroupCell alloc] init];
        [groupCells insertObject:groupCell1 atIndex:0];
        [cells insertObject:groupCell1 atIndex:0];
    }
    NSUInteger groupCount = groupCells.count;
    NSMutableArray <NSMutableArray <XUIBaseCell *> *> *otherCells = [[NSMutableArray alloc] initWithCapacity:groupCount];
    for (NSUInteger groupIdx = 0; groupIdx < groupCount; ++groupIdx) {
        [otherCells addObject:[[NSMutableArray alloc] init]];
    }
    NSInteger otherCellIdx = -1;
    for (XUIBaseCell *otherCell in cells) {
        if ([otherCell isKindOfClass:[XUIGroupCell class]]) {
            otherCellIdx++;
        } else if (otherCellIdx >= 0 && otherCellIdx < groupCount) {
            [otherCells[otherCellIdx] addObject:otherCell];
        }
    }
    
    // finish parsing
    _sectionCells = groupCells;
    _otherCells = otherCells;
    if (_delegate && [_delegate respondsToSelector:@selector(cellFactoryDidFinishParsing:)]) {
        [_delegate cellFactoryDidFinishParsing:self];
    }
    
    assert(self.sectionCells.count == self.otherCells.count);
    self.parsed = YES;
}

- (void)callbackWithErrorReason:(NSString *)exceptionReason {
    NSBundle *frameworkBundle = FRAMEWORK_BUNDLE;
    NSAssert(frameworkBundle, @"Cannot find XUI Framework Bundle.");
    NSError *error = [NSError errorWithDomain:kXUICellFactoryErrorDomain code:400 userInfo:@{ NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTableInBundle(@"Failed to parse", nil, frameworkBundle, nil), NSLocalizedDescriptionKey: exceptionReason }];
    if (_delegate && [_delegate respondsToSelector:@selector(cellFactory:didFailWithError:)]) {
        [_delegate cellFactory:self didFailWithError:error];
    }
}

- (void)testObject:(id)itemValue forKey:(NSString *)itemKey forCellInstance:(XUIBaseCell *)cellInstance atIndex:(NSUInteger)itemIdx {
    if (!itemValue || !itemKey || !cellInstance) return;
    NSString *propertyName = [NSString stringWithFormat:@"xui_%@", itemKey];
    if (class_getProperty([cellInstance class], [propertyName UTF8String])) {

    } else {
        [self.logger logMessage:[NSString stringWithFormat:XUIParserErrorUndefinedKey(@"items[%lu] -> %@"), itemIdx, propertyName]];
    }
}

#pragma mark - Notifications

- (void)xuiValueChanged:(NSNotification *)aNotification {
    XUIBaseCell *cell = aNotification.object;
    if ([cell isKindOfClass:[XUIBaseCell class]]) {
        [self updateRelatedCellsForCell:cell];
    }
}

- (void)updateRelatedCellsForCell:(XUIBaseCell *)inCell {
    NSString *cellDefaults = inCell.xui_defaults;
    NSString *cellKey = inCell.xui_key;
    NSString *cellValue = inCell.xui_value;
    if (!cellValue) return;
    for (NSArray <XUIBaseCell *> *cellArray in self.otherCells) {
        [cellArray enumerateObjectsUsingBlock:^(XUIBaseCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
            if (cell != inCell &&
                cell.xui_defaults.length > 0 &&
                [cell.xui_defaults isEqualToString:cellDefaults] &&
                cell.xui_key.length > 0 &&
                [cell.xui_key isEqualToString:cellKey]
                ) {
                NSDictionary *testEntry = @{ @"value": cellValue };
                BOOL testResult = [[cell class] testEntry:testEntry withError:nil];
                if (testResult) {
                    cell.xui_value = cellValue;
                }
            }
        }];
    }
}

@end
