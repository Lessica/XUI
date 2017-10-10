//
//  XUITagCollectionView.h
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import <UIKit/UIKit.h>

@class XUITagCollectionView;

/**
 * Tags scroll direction
 */
typedef NS_ENUM(NSInteger, XUITagCollectionScrollDirection) {
    XUITagCollectionScrollDirectionVertical = 0, // Default
    XUITagCollectionScrollDirectionHorizontal = 1
};

/**
 * Tags alignment
 */
typedef NS_ENUM(NSInteger, XUITagCollectionAlignment) {
    XUITagCollectionAlignmentLeft = 0,             // Default
    XUITagCollectionAlignmentCenter,               // Center
    XUITagCollectionAlignmentRight,                // Right
    XUITagCollectionAlignmentFillByExpandingSpace, // Expand horizontal spacing and fill
    XUITagCollectionAlignmentFillByExpandingWidth  // Expand width and fill
};

/**
 * Tags delegate
 */
@protocol XUITagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(XUITagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (BOOL)tagCollectionView:(XUITagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(XUITagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(XUITagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end

/**
 * Tags dataSource
 */
@protocol XUITagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(XUITagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(XUITagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end

@interface XUITagCollectionView : UIView
@property (nonatomic, weak) id <XUITagCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id <XUITagCollectionViewDelegate> delegate;

// Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

// Tags scroll direction, default is vertical.
@property (nonatomic, assign) XUITagCollectionScrollDirection scrollDirection;

// Tags layout alignment, default is left.
@property (nonatomic, assign) XUITagCollectionAlignment alignment;

// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;

// Horizontal and vertical space between tags, default is 4.
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

// The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

// Manual content height
// Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
// Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

// Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/**
 * Reload all tag cells
 */
- (void)reload;

@end
