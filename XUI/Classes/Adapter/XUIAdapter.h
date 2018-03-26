//
//  XUIAdapter.h
//  XXTExplorer
//
//  Created by Zheng Wu on 29/09/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XUIBaseCell;

@protocol XUIAdapter <NSObject>

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSBundle *bundle;
@property (nonatomic, strong, readonly) NSString *stringsTable;


#pragma mark - Initializers
- (instancetype)initWithXUIPath:(NSString *)path;
- (instancetype)initWithXUIPath:(NSString *)path Bundle:(NSBundle *)bundle;


#pragma mark - Entry
- (NSDictionary *)rootEntryWithError:(NSError **)error;


#pragma mark - Defaults
- (void)saveDefaultsFromCell:(XUIBaseCell *)cell;
- (id)objectForKey:(NSString *)key Defaults:(NSString *)identifier;
- (void)setObject:(id)obj forKey:(NSString *)key Defaults:(NSString *)identifier;


#pragma mark - Localization
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

@end
