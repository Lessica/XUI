//
//  XUIImageCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIImageCell.h"

@interface XUIImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation XUIImageCell

+ (BOOL)xibBasedLayout {
    return YES;
}

+ (BOOL)layoutNeedsTextLabel {
    return NO;
}

+ (BOOL)layoutNeedsImageView {
    return NO;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"path": [NSString class]
      };
}

+ (BOOL)testEntry:(NSDictionary *)cellEntry withError:(NSError **)error {
    BOOL superResult = [super testEntry:cellEntry withError:error];
    return superResult;
}

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setXui_path:(NSString *)xui_path {
    _xui_path = xui_path;
    NSString *imagePath = [self.adapter.bundle pathForResource:xui_path ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.cellImageView.image = image;
}

@end
