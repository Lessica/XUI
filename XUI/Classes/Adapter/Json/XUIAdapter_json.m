//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIAdapter_json.h"
#import "XUIBaseCell.h"

@implementation XUIAdapter_json

@synthesize rawEntry = _rawEntry;

- (BOOL)setupWithError:(NSError **)error {
    if (![super setupWithError:error]) {
        return NO;
    }
    NSData *jsonEntryData = [[NSData alloc] initWithContentsOfFile:self.path options:0 error:error];
    if (!jsonEntryData) {
        return NO;
    }
    id value = [NSJSONSerialization JSONObjectWithData:jsonEntryData options:0 error:error];
    if (![value isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if (value[@"items"])
    { // XUI Schema
        _rawEntry = value;
    }
    else
    { // Unknown Schema
        return NO;
    }
    return YES;
}

@end
