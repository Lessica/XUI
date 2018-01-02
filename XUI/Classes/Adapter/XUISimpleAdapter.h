//
// Created by Zheng Wu on 09/10/2017.
// Copyright (c) 2017 Zheng. All rights reserved.
//

#import "XUIAdapter.h"


@interface XUISimpleAdapter : NSObject <XUIAdapter>

@property (nonatomic, copy, readonly) NSDictionary *rawEntry;
- (BOOL)setupWithError:(NSError **)error NS_REQUIRES_SUPER;

@end
