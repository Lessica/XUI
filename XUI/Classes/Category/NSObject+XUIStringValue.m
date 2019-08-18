//
//  NSObject+XUIStringValue.m
//  XXTExplorer
//
//  Created by Zheng on 01/08/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "NSObject+XUIStringValue.h"

@implementation NSObject (XUIStringValue)

+ (NSArray <Class> *)xui_baseTypes {
    return @[ [NSString class], [NSURL class], [NSNumber class], [NSData class], [NSDate class], [NSNull class] ];
}

- (NSString *)xui_stringValue {
    if ([self isKindOfClass:[NSString class]]) {
        return ((NSString *)self);
    }
    else if ([self isKindOfClass:[NSURL class]]) {
        return [((NSURL *)self) absoluteString];
    }
    else if ([self isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)self) stringValue];
    }
    else if ([self isKindOfClass:[NSDate class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        return [formatter stringFromDate:(NSDate *)self];
    }
    else if ([self isKindOfClass:[NSNull class]]) {
        return @"(null)";
    }
    else if ([self isKindOfClass:[NSData class]]) {
        return [NSString stringWithFormat:@"<%lu Bytes>", (unsigned long)((NSData *)self).length];
    }
    else if ([self isKindOfClass:[NSArray class]]) {
        NSUInteger count = [(NSArray *)self count];
        if (count == 0) {
            return @"<No Item>";
        } else if (count == 1) {
            return [NSString stringWithFormat:@"<%lu Item>", (unsigned long)count];
        } else {
            return [NSString stringWithFormat:@"<%lu Items>", (unsigned long)count];
        }
    }
    else if ([self isKindOfClass:[NSDictionary class]]) {
        NSUInteger count = [(NSDictionary *)self count];
        if (count == 0) {
            return @"<No Item>";
        } else if (count == 1) {
            return [NSString stringWithFormat:@"<%lu Item>", (unsigned long)count];
        } else {
            return [NSString stringWithFormat:@"<%lu Items>", (unsigned long)count];
        }
    }
    return [self description];
}

@end
