//
//  XUICellFactory.h
//  XXTExplorer
//
//  Created by Zheng on 17/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XUIAdapter.h"

@class XUIBaseCell, XUIGroupCell, XUILogger, XUITheme;

@class XUICellFactory;

@protocol XUICellFactoryDelegate <NSObject>

- (void)cellFactory:(XUICellFactory *)parser didFailWithError:(NSError *)error;
- (void)cellFactoryDidFinishParsing:(XUICellFactory *)parser;

@end

@interface XUICellFactory : NSObject

@property (nonatomic, strong, readonly) XUILogger *logger;
@property (nonatomic, strong, readonly) id <XUIAdapter> adapter;

@property (nonatomic, weak) id <XUICellFactoryDelegate> delegate;
@property (nonatomic, strong, readonly) NSDictionary <NSString *, id> *rootEntry;
@property (nonatomic, strong, readonly) NSArray <XUIGroupCell *> *sectionCells;
@property (nonatomic, strong, readonly) NSArray <NSArray <XUIBaseCell *> *> *otherCells;

@property (nonatomic, strong, readonly) XUITheme *theme;

- (instancetype)initWithAdapter:(id <XUIAdapter>)adapter Error:(NSError **)error;
- (void)parse; // this method should run in main thread
- (void)updateRelatedCellsForCell:(XUIBaseCell *)inCell;

@end
