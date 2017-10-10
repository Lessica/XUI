//
//  XUITagCollectionView.m
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import "XUITagCollectionView.h"

@interface XUITagCollectionView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL needsLayoutTagViews;
@end

@implementation XUITagCollectionView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    if (_scrollView) {
        return;
    }
    
    _horizontalSpacing = 4;
    _verticalSpacing = 4;
    _contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    
    _containerView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.userInteractionEnabled = YES;
    [_scrollView addSubview:_containerView];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(onTapGesture:)];
    [_containerView addGestureRecognizer:tapGesture];
    
    [self setNeedsLayoutTagViews];
}

#pragma mark - Public methods

- (void)reload {
    if (![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    // Remove all tag views
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Update tag view frame
    [self setNeedsLayoutTagViews];
    [self layoutTagViews];
    
    // Add tag view
    for (NSUInteger i = 0; i < [_dataSource numberOfTagsInTagCollectionView:self]; i++) {
        [_containerView addSubview:[_dataSource tagCollectionView:self tagViewForIndex:i]];
    }
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Gesture

- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (![self.dataSource respondsToSelector:@selector(numberOfTagsInTagCollectionView:)] ||
        ![self.dataSource respondsToSelector:@selector(tagCollectionView:tagViewForIndex:)] ||
        ![self.delegate respondsToSelector:@selector(tagCollectionView:didSelectTag:atIndex:)]) {
        return;
    }
    
    CGPoint tapPoint = [tapGesture locationInView:_containerView];
    
    for (NSUInteger i = 0; i < [self.dataSource numberOfTagsInTagCollectionView:self]; i++) {
        UIView *tagView = [self.dataSource tagCollectionView:self tagViewForIndex:i];
        if (CGRectContainsPoint(tagView.frame, tapPoint)) {
            if ([self.delegate respondsToSelector:@selector(tagCollectionView:shouldSelectTag:atIndex:)]) {
                if ([self.delegate tagCollectionView:self shouldSelectTag:tagView atIndex:i]) {
                    [self.delegate tagCollectionView:self didSelectTag:tagView atIndex:i];
                }
            } else {
                [self.delegate tagCollectionView:self didSelectTag:tagView atIndex:i];
            }
        }
    }
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        _scrollView.frame = self.bounds;
        [self setNeedsLayoutTagViews];
        [self layoutTagViews];
        _containerView.frame = (CGRect){CGPointZero, _scrollView.contentSize};
        [self invalidateIntrinsicContentSize];
    }
    [self layoutTagViews];
}

- (CGSize)intrinsicContentSize {
    return _scrollView.contentSize;
}

#pragma mark - Layout

- (void)layoutTagViews {
    if (!_needsLayoutTagViews || ![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    if (_scrollDirection == XUITagCollectionScrollDirectionVertical) {
        [self layoutTagViewsForVerticalDirection];
    } else {
        [self layoutTagViewsForHorizontalDirection];
    }
    
    _needsLayoutTagViews = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)layoutTagViewsForVerticalDirection {
    NSUInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    NSUInteger currentLineTagsCount = 0;
    CGFloat totalWidth = (_manualCalculateHeight && _preferredMaxLayoutWidth > 0) ? _preferredMaxLayoutWidth : CGRectGetWidth(self.bounds);
    CGFloat maxLineWidth = totalWidth - _contentInset.left - _contentInset.right;
    CGFloat currentLineX = 0;
    CGFloat currentLineMaxHeight = 0;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    
    // Get each line max height ,width and tag count
    for (NSUInteger i = 0; i < count; i++) {
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:i];

        if (currentLineX + tagSize.width > maxLineWidth) {
            // New Line
            [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
            [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
            [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
            currentLineTagsCount = 0;
            currentLineMaxHeight = 0;
            currentLineX = 0;
        }
        
        
        // Line number limit
        if (_numberOfLines != 0) {
            UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
            tagView.hidden = eachLineWidthNumbers.count >= _numberOfLines;
        }
        
        currentLineX += tagSize.width + _horizontalSpacing;
        currentLineTagsCount += 1;
        currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
    [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
    [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
    
    // Line limit
    if (_numberOfLines != 0) {
        eachLineWidthNumbers = [[eachLineWidthNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineWidthNumbers.count, _numberOfLines))] mutableCopy];
        eachLineMaxHeightNumbers = [[eachLineMaxHeightNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineMaxHeightNumbers.count, _numberOfLines))] mutableCopy];
        eachLineTagCountNumbers = [[eachLineTagCountNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineTagCountNumbers.count, _numberOfLines))] mutableCopy];
    }
    
    // Prepare
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:eachLineTagCountNumbers.count
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutTagViewsForHorizontalDirection {
    CGFloat totalWidthInOneLine = 0;
    NSInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;
    _numberOfLines = MIN(count, _numberOfLines);
    
    // Set frame size and get totalWidthInOneLine
    for (NSInteger i = 0; i < count; i++) {
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:i];
        totalWidthInOneLine += tagSize.width + _horizontalSpacing;
    }
    
    // Calculate estimate each line width
    CGFloat averageWidthEachLine = totalWidthInOneLine / (CGFloat)_numberOfLines + 1;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    CGFloat currentLineMaxHeight = 0;
    CGFloat maxLineWidth = 0;
    CGFloat currentLineX = 0;
    NSUInteger currentLineTagsCount = 0;
    NSUInteger tagIndex = 0;
    
    // Get each line max height, tags count and true width
    for (NSUInteger currentLine = 0; currentLine < _numberOfLines; currentLine++) {
        while ((currentLineX < averageWidthEachLine || currentLine == _numberOfLines - 1) && tagIndex < count) {
            CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:tagIndex];
            currentLineX += tagSize.width + _horizontalSpacing;
            currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
            currentLineTagsCount += 1;
            tagIndex += 1;
        }
        
        maxLineWidth = MAX(currentLineX - _horizontalSpacing, maxLineWidth);
        [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
        [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
        [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
        currentLineX = 0;
        currentLineMaxHeight = 0;
        currentLineTagsCount = 0;
    }
    
    // Update max width
    maxLineWidth = MAX(CGRectGetWidth(self.frame), maxLineWidth);
    
    // Set each tag frame
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:_numberOfLines
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutEachLineTagsWithMaxLineWidth:(CGFloat)maxLineWidth
                             numberOfLines:(NSUInteger)numberOfLines
                          eachLineTagCount:(NSArray <NSNumber *> *)eachLineTagCount
                             eachLineWidth:(NSArray <NSNumber *> *)eachLineWidth
                         eachLineMaxHeight:(NSArray <NSNumber *> *)eachLineMaxHeight {
 
    CGFloat currentYBase = _contentInset.top;
    NSUInteger currentTagIndexBase = 0;
    NSUInteger tagIndex = 0;
    
    for (NSUInteger currentLine = 0; currentLine < numberOfLines; currentLine++) {
        CGFloat currentLineMaxHeight = eachLineMaxHeight[currentLine].floatValue;
        CGFloat currentLineWidth = eachLineWidth[currentLine].floatValue;
        CGFloat currentLineTagsCount = eachLineTagCount[currentLine].unsignedIntegerValue;
        
        // Alignment x offset
        CGFloat currentLineXOffset = 0;
        CGFloat currentLineAdditionWidth = 0;
        CGFloat currentLineX = 0;
        CGFloat acturalHorizontalSpacing = _horizontalSpacing;
        
        switch (_alignment) {
            case XUITagCollectionAlignmentLeft:
                currentLineXOffset = _contentInset.left;
                break;
            case XUITagCollectionAlignmentCenter:
                currentLineXOffset = (maxLineWidth - currentLineWidth) / 2 + _contentInset.left;
                break;
            case XUITagCollectionAlignmentRight:
                currentLineXOffset = maxLineWidth - currentLineWidth + _contentInset.left;
                break;
            case XUITagCollectionAlignmentFillByExpandingSpace:
                currentLineXOffset = _contentInset.left;
                acturalHorizontalSpacing = _horizontalSpacing +
                (maxLineWidth - currentLineWidth) / (CGFloat)(currentLineTagsCount - 1);
                currentLineWidth = maxLineWidth;
                break;
            case XUITagCollectionAlignmentFillByExpandingWidth:
                currentLineXOffset = _contentInset.left;
                currentLineAdditionWidth = (maxLineWidth - currentLineWidth) / (CGFloat)currentLineTagsCount;
                currentLineWidth = maxLineWidth;
                break;
        }
        
        // Current line
        for (tagIndex = currentTagIndexBase; tagIndex < currentTagIndexBase + currentLineTagsCount; tagIndex++) {
            UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:tagIndex];
            CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:tagIndex];
            
            CGPoint origin;
            origin.x = currentLineXOffset + currentLineX;
            origin.y = currentYBase + (currentLineMaxHeight - tagSize.height) / 2;
            
            tagSize.width += currentLineAdditionWidth;
            if (_scrollDirection == XUITagCollectionScrollDirectionVertical && tagSize.width > maxLineWidth) {
                tagSize.width = maxLineWidth;
            }
            
            tagView.hidden = NO;
            tagView.frame = (CGRect){origin, tagSize};
            
            currentLineX += tagSize.width + acturalHorizontalSpacing;
        }
        
        // Next line
        currentYBase += currentLineMaxHeight + _verticalSpacing;
        currentTagIndexBase += currentLineTagsCount;
    }
    
    // Content size
    maxLineWidth += _contentInset.right + _contentInset.left;
    CGSize contentSize = CGSizeMake(maxLineWidth, currentYBase - _verticalSpacing + _contentInset.bottom);
    if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
        _scrollView.contentSize = contentSize;
        _containerView.frame = (CGRect){CGPointZero, contentSize};
        
        if ([self.delegate respondsToSelector:@selector(tagCollectionView:updateContentSize:)]) {
            [self.delegate tagCollectionView:self updateContentSize:contentSize];
        }
    }
}

- (void)setNeedsLayoutTagViews {
    _needsLayoutTagViews = YES;
}

#pragma mark - Check delegate and dataSource

- (BOOL)isDelegateAndDataSourceValid {
    BOOL isValid = _delegate != nil && _dataSource != nil;
    isValid = isValid && [_delegate respondsToSelector:@selector(tagCollectionView:sizeForTagAtIndex:)];
    isValid = isValid && [_dataSource respondsToSelector:@selector(tagCollectionView:tagViewForIndex:)];
    isValid = isValid && [_dataSource respondsToSelector:@selector(numberOfTagsInTagCollectionView:)];
    return isValid;
}

#pragma mark - Setter Getter

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)setScrollDirection:(XUITagCollectionScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self setNeedsLayoutTagViews];
}

- (void)setAlignment:(XUITagCollectionAlignment)alignment {
    _alignment = alignment;
    [self setNeedsLayoutTagViews];
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self setNeedsLayoutTagViews];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayoutTagViews];
}

- (CGSize)contentSize {
    [self layoutTagViews];
    return _scrollView.contentSize;
}

- (void)setManualCalculateHeight:(BOOL)manualCalculateHeight {
    _manualCalculateHeight = manualCalculateHeight;
    [self setNeedsLayoutTagViews];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self setNeedsLayoutTagViews];
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (BOOL)showsHorizontalScrollIndicator {
    return _scrollView.showsHorizontalScrollIndicator;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (BOOL)showsVerticalScrollIndicator {
    return _scrollView.showsVerticalScrollIndicator;
}

@end
