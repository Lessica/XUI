//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIAdapter_plist.h"
#import "XUIBaseCell.h"

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
    _rawEntry = value;
    return YES;
}

@end
