//
//  XUIStrings.m
//  XUI
//
//  Created by Zheng Wu on 2018/3/23.
//

#import "XUIStrings.h"

@implementation XUIStrings

+ (NSString *)localizedStringForString:(NSString *)string {
    if (!string) return nil;
    NSString *languageIdentifier = [[NSLocale preferredLanguages] firstObject];
    if ([languageIdentifier rangeOfString:@"-"].location != NSNotFound) {
        languageIdentifier = [[languageIdentifier componentsSeparatedByString:@"-"] firstObject];
    }
    NSString *localizedString = [self languageMappings][languageIdentifier][string];
    if (localizedString) return localizedString;
    return string;
}

+ (NSDictionary *)languageMappings {
    static NSDictionary *languageMappings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *mappings = [[NSMutableDictionary alloc] init];
        mappings[@"zh"] = [self zhHansMapping];
        languageMappings = [mappings copy];
    });
    return languageMappings;
}

+ (NSDictionary *)zhHansMapping {
    return
    @{
      @"%@\n%@: %@": @"%@\n%@: %@",
      @"%lu Item": @"%lu 项",
      @"%lu Items": @"%lu 项",
      @"%lu Selected": @"%lu 已选择",
      @"[%@]\nPath \"%@\" (treated as \"NSArray\") is empty.": @"[%@]\n路径 \"%@\" (作为 \"NSArray\") 为空.",
      @"[%@]\nPath \"%@\" is missing.": @"[%@]\n路径 \"%@\" 缺失.",
      @"[%@]\nPath \"%@\" should be \"%@\".": @"[%@]\n路径 \"%@\" 应该为 \"%@\".",
      @"[%@]\nPath \"items[%lu]\", %@": @"[%@]\n路径 \"items[%lu]\", %@",
      @"[%@]\nThe key of path \"%@\" is undefined.": @"[%@]\n路径的键 \"%@\" 未定义.",
      @"[%@]\nThe selector \"%@\" is unknown.": @"[%@]\n选择器 \"%@\" 是无效的.",
      @"[%@]\nThe value of path \"%@\" (\"%@\") is invalid.": @"[%@]\n路径的值 \"%@\" (\"%@\") 无效.",
      @"Add Item": @"添加项目",
      @"Add Item...": @"添加项目...",
      @"Cannot find suitable adapter for \"%@\".": @"找不到合适的 Adapter 处理 \"%@\"",
      @"Cannot initialize \"%@\".\nCheck schema file to ensure it is in valid format.": @"无法初始化 \"%@\".\n请检查数据文件并确保其格式有效.",
      @"Close": @"关闭",
      @"Delete": @"删除",
      @"Delete selected %lu item": @"删除选中的 %lu 项",
      @"Delete selected %lu items": @"删除选中的 %lu 项",
      @"Delete selected item(s)": @"删除选中项目",
      @"Edit Item": @"修改项目",
      @"Failed to parse": @"解析失败",
      @"Item List": @"项目列表",
      @"Item List (%lu Item)": @"项目列表 (%lu 项)",
      @"Item List (%lu Items)": @"项目列表 (%lu 项)",
      @"Item List (No Item)": @"项目列表 (无项目)",
      @"key \"%@\" (\"%@\") is invalid.": @"键 \"%@\" 的值 (\"%@\") 是无效的.",
      @"key \"%@\", should be \"%@\".": @"键 \"%@\", 应该为 \"%@\".",
      @"Manage Items": @"编辑项目",
      @"No Item": @"无项目",
      @"OK": @"好",
      @"Others": @"其它",
      @"Selected": @"已选择",
      @"the value \"%@\" of key \"%@\" is invalid.": @"值 \"%@\" 键 \"%@\" 是无效的.",
      @"XUI Error": @"XUI 错误",
      @"The number of item exceeded the \"maxCount\" limit (%lu).": @"项目数量超出 \"maxCount\" 限制数量 (%lu).",
      @"Value": @"值",
      };
}

@end
