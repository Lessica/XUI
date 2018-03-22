//
//  XUITableViewProxy.m
//  TableViewExtendDemo
//
//  Created by Zheng Wu on 2018/3/22.
//  Copyright © 2018年 DarwinDev. All rights reserved.
//

#import "XUITableViewProxy.h"

@implementation XUITableViewProxy

- (instancetype)initWithObject:(id)object keyName:(NSString *)tableViewName {
    if (self = [super init]) {
        _origDelegate = object;
        _origDataSource = object;
        _displayName = @"Tweak Settings";
        
        UITableView *tableView = [object valueForKey:tableViewName];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@Cell", NSStringFromClass([self class])]];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    id target = [super forwardingTargetForSelector:aSelector];
    if (target) {
        return target;
    } else if ([_origDelegate respondsToSelector:aSelector]) {
        return _origDelegate;
    } else if ([_origDataSource respondsToSelector:aSelector]) {
        return _origDataSource;
    }
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL supports = [super respondsToSelector:aSelector];
    if (supports) {
        return YES;
    } else if ([_origDelegate respondsToSelector:aSelector]) {
        return YES;
    } else if ([_origDataSource respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        return [_origDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@Cell", NSStringFromClass([self class])] forIndexPath:indexPath];
    cell.textLabel.text = self.displayName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        return [_origDataSource tableView:tableView numberOfRowsInSection:section];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 1;
    return [_origDataSource numberOfSectionsInTableView:tableView] + numberOfSections;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        if ([_origDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
            return [_origDataSource tableView:tableView canEditRowAtIndexPath:indexPath];
        }
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        if ([_origDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
            return [_origDataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        if ([_origDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [_origDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
            return;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Modified: %ld, %ld", (long)indexPath.section, (long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < [_origDataSource numberOfSectionsInTableView:tableView]) {
        if ([_origDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return [_origDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        return UITableViewAutomaticDimension;
    }
    return 44.0;
}

@end
