//
//  XUIImageCell.m
//  XXTExplorer
//
//  Created by Zheng on 30/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIImageCell.h"

@interface XUIImageCell ()

@property (strong, nonatomic) UIImageView *cellImageView;

@end

@implementation XUIImageCell

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

#pragma mark - Setup

- (void)setupCell {
    [super setupCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.cellImageView];
    {
        NSArray <NSLayoutConstraint *> *constraints =
        @[
          [NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:16.0],
          [NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-16.0],
          [NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:4.0],
          [NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-4.0],
          ];
        [self.contentView addConstraints:constraints];
    }
}

#pragma mark - UIView Getters

- (UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        _cellImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cellImageView;
}

#pragma mark - Setters

- (void)setXui_path:(NSString *)xui_path {
    _xui_path = xui_path;
    NSString *imagePath = [self.adapter.bundle pathForResource:xui_path ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.cellImageView.image = image;
}

@end
