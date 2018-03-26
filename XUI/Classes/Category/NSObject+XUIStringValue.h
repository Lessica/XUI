//
//  NSObject+XUIStringValue.h
//  XXTExplorer
//
//  Created by Zheng on 01/08/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XUIStringValue)

+ (NSArray <Class> *)xui_baseTypes;
- (NSString *)xui_stringValue;

@end
