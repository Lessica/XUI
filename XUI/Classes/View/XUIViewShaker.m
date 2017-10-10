//
//  XUIViewShaker.m
//  XXTExplorer
//
//  Created by Zheng on 02/07/2017.
//  Copyright © 2017 Zheng. All rights reserved.
//

#import "XUIViewShaker.h"

static NSTimeInterval const kXUIViewShakerDefaultDuration = 0.5;
static NSString * const kXUIViewShakerAnimationKey = @"kXUIViewShakerAnimationKey";

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
// CAAnimationDelegate is not available before iOS 10 SDK
@interface XUIViewShaker ()
#else
@interface XUIViewShaker () <CAAnimationDelegate>
#endif

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, assign) NSUInteger completedAnimations;
@property (nonatomic, copy) void (^completionBlock)(void);

@end

@implementation XUIViewShaker

- (instancetype)initWithView:(UIView *)view {
    return [self initWithViewsArray:@[view]];
}


- (instancetype)initWithViewsArray:(NSArray *)viewsArray {
    self = [super init];
    if (self) {
        self.views = viewsArray;
    }
    return self;
}


#pragma mark - Public methods

- (void)shake {
    [self shakeWithDuration:kXUIViewShakerDefaultDuration completion:nil];
}


- (void)shakeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    self.completionBlock = completion;
    if (@available(iOS 10.0, *)) {
        UINotificationFeedbackGenerator *feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
        [feedbackGenerator notificationOccurred:UINotificationFeedbackTypeError];
    }
    for (UIView * view in self.views) {
        [self addShakeAnimationForView:view withDuration:duration];
    }
}


#pragma mark - Shake Animation

- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    
    animation.delegate = self;
    animation.duration = duration;
    animation.values = @[@(currentTx),
                         @(currentTx + 10),
                         @(currentTx - 8),
                         @(currentTx + 8),
                         @(currentTx - 5),
                         @(currentTx + 5),
                         @(currentTx)];
    animation.keyTimes = @[@(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:kXUIViewShakerAnimationKey];
}


#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    self.completedAnimations += 1;
    if (self.completedAnimations >= self.views.count) {
        self.completedAnimations = 0;
        if (self.completionBlock) {
            self.completionBlock();
        }
    }
}

@end
