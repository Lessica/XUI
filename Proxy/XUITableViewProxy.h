//
//  XUITableViewProxy.h
//  TableViewExtendDemo
//
//  Created by Zheng Wu on 2018/3/22.
//  Copyright © 2018年 DarwinDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUITableViewProxy : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<UITableViewDelegate> origDelegate;
@property (nonatomic, weak) id<UITableViewDataSource> origDataSource;

@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *entryPath;
@property (nonatomic, strong) NSString *bundlePath;

@property (nonatomic, copy) NSString *displayName;

- (instancetype)initWithObject:(id)object keyName:(NSString *)tableViewName;

@end
