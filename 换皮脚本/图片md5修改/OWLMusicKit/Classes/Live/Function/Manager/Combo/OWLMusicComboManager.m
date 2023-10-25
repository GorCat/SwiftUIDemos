//
//  OWLMusicComboManager.m
//  Pods
//
//  Created by 许琰 on 2023/4/20.
//

#import "OWLMusicComboManager.h"

NSInteger xyp_directionVector = -1;

CGFloat xyp_defaultImageWidth = 40;

@interface OWLMusicComboManager () {
    BOOL xyp_isAnimating;
    CGSize xyp_imageSize;
    BOOL xyp_currentIsSelf;
    UIImage *xyp_giftImage;
}

@property (nonatomic, retain) UIDynamicAnimator *xyp_animator;

@property (nonatomic, retain) UIGravityBehavior *xyp_gravityBehavior;

@property (nonatomic, retain) UICollisionBehavior *xyp_collisionBehavior;

@property (nonatomic, retain) UIDynamicItemBehavior *xyp_dynamicBehavior;

@property (nonatomic, retain) UIPushBehavior *xyp_pushBehavior;

@property (nonatomic, assign) NSInteger xyp_comboCount;

@property (nonatomic, retain) NSTimer *xyp_endTimer;

@property (nonatomic, retain) NSTimer *xyp_Timer;

@property (nonatomic, retain) UIView *xyp_containerView;

@property (nonatomic, retain) NSMutableArray<UIImageView *> *xyp_imageArray;

@end

@implementation OWLMusicComboManager

+ (instancetype)shared {
    static OWLMusicComboManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        xyp_giftImage = [XYCUtil xyf_getIconWithName:@"xyr_icon_combo_default_image"];
        xyp_imageSize = CGSizeMake(40.0, 40.0);
        self.xyp_imageArray = [NSMutableArray array];
        self.xyp_comboCount = 1;
        self.xyp_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.xyp_containerView];
        [self.xyp_animator addBehavior:self.xyp_gravityBehavior];
        [self.xyp_animator addBehavior:self.xyp_collisionBehavior];
        [self.xyp_animator addBehavior:self.xyp_dynamicBehavior];
        [self.xyp_animator addBehavior:self.xyp_pushBehavior];
    }
    return self;
}

#pragma mark - public
- (void)xyf_startAnimationWithImage:(nullable UIImage *)xyp_image size:(CGSize)xyp_size container:(UIView *)xyp_container count:(NSInteger)xyp_count senderIsSelf:(BOOL)xyp_isSelf {
    
    if (xyp_count < 5) {
        return;
    }
    
    BOOL xyp_shouldBegin = xyp_isSelf || (!xyp_isSelf && !xyp_isAnimating) || (!xyp_isSelf && xyp_isAnimating && xyp_count > self.xyp_comboCount && !xyp_currentIsSelf);
    if (!xyp_shouldBegin) {
        return;
    }
    
    [xyp_container addSubview:self.xyp_containerView];
    self.xyp_containerView.frame = xyp_container.bounds;
    if (xyp_image) {
        xyp_giftImage = xyp_image;
    }else {
        xyp_giftImage = [XYCUtil xyf_getIconWithName:@"xyr_icon_combo_default_image"];
    }
    if (xyp_size.height > 0 && xyp_size.width > 0) {
        xyp_imageSize = xyp_size;
    }
    
    self.xyp_comboCount = xyp_count;
    xyp_isAnimating = YES;
    xyp_currentIsSelf = xyp_isSelf;
    
    [self xyf_animate];
    
    self.xyp_endTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self xyf_stopAnimation:NO];
    }];
}

- (void)xyf_stopAnimation:(BOOL)xyp_immediately {
    xyp_isAnimating = NO;
    if (xyp_immediately) {
        [self xyf_stopAnimation];
    } else {
        kXYLWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf xyf_stopAnimation];
        });
    }
}

- (void)xyf_stopAnimation {
    if (!xyp_isAnimating) {
        for (UIImageView *xyp_imageView in self.xyp_imageArray) {
            [self.xyp_gravityBehavior removeItem:xyp_imageView];
            [self.xyp_collisionBehavior removeItem:xyp_imageView];
            [self.xyp_dynamicBehavior removeItem:xyp_imageView];
            [xyp_imageView removeFromSuperview];
        }
        [self.xyp_imageArray removeAllObjects];
    }
}

#pragma mark - private
- (void)xyf_animate {
    if (xyp_isAnimating == NO) {
        return;
    }
    self.xyp_Timer = nil;
    CGFloat xyp_distance = MAX(0.035, 0.7/self.xyp_comboCount);
    NSLog(@"--------%@",@(xyp_distance));
    self.xyp_Timer = [NSTimer scheduledTimerWithTimeInterval:xyp_distance repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self xyf_createAGiftAnimation];
        [self xyf_animate];
    }];
    [NSRunLoop.mainRunLoop addTimer:self.xyp_Timer forMode:NSRunLoopCommonModes];
}

- (void)xyf_createAGiftAnimation {
    static NSInteger c = 0;
    NSLog(@"++++++++%@",@(++c));
    NSMutableArray *xyp_temArray = [NSMutableArray array];
    for (UIImageView *xyp_imageView in self.xyp_imageArray) {
        if (!CGRectContainsPoint(self.xyp_containerView.bounds, xyp_imageView.center)) {
            [self.xyp_gravityBehavior removeItem:xyp_imageView];
            [self.xyp_collisionBehavior removeItem:xyp_imageView];
            [self.xyp_dynamicBehavior removeItem:xyp_imageView];
            [xyp_imageView removeFromSuperview];
            [xyp_temArray addObject:xyp_imageView];
        }
    }
    [self.xyp_imageArray removeObjectsInArray:xyp_temArray];
    xyp_temArray = nil;
    
    NSInteger xyp_dx = arc4random() % 5 - 2;
    CGFloat xyp_totalWidth = self.xyp_containerView.frame.size.width;
    CGFloat xyp_imageWidth = xyp_imageSize.width;
    
    UIImageView *xyp_giftView = [[UIImageView alloc] initWithFrame:CGRectMake(xyp_totalWidth / 2.0 + xyp_dx * xyp_imageWidth - xyp_imageWidth / 2.0, self.xyp_containerView.frame.size.height, xyp_imageSize.width, xyp_imageSize.height)];
    xyp_giftView.image = xyp_giftImage;
    xyp_giftView.contentMode = UIViewContentModeScaleAspectFit;
    [self.xyp_containerView addSubview:xyp_giftView];
    [self.xyp_imageArray addObject:xyp_giftView];
    
    CGFloat xyp_angle = ((arc4random() % 41) * xyp_directionVector + 270) / 180.0 * M_PI;
    self.xyp_pushBehavior.active = YES;
    self.xyp_pushBehavior.angle = xyp_angle;
    xyp_directionVector *= -1;
    
    CGFloat xyp_ratio = xyp_imageWidth / xyp_defaultImageWidth;
    CGFloat xyp_mag = MIN(1.5, 1.0 + self.xyp_comboCount / 3.0 * 0.0185);
    self.xyp_pushBehavior.magnitude = xyp_mag * xyp_ratio;
    self.xyp_gravityBehavior.magnitude = 0.7 * xyp_ratio;
    
    [self.xyp_pushBehavior removeItem:self.xyp_pushBehavior.items.firstObject];
    [self.xyp_pushBehavior addItem:xyp_giftView];
    [self.xyp_gravityBehavior addItem:xyp_giftView];
    [self.xyp_collisionBehavior addItem:xyp_giftView];
    [self.xyp_dynamicBehavior addItem:xyp_giftView];
}

#pragma mark - Setter
- (void)setXyp_endTimer:(NSTimer *)xyp_endTimer {
    if (_xyp_endTimer.isValid) {
        [_xyp_endTimer invalidate];
        _xyp_endTimer = nil;
    }
    _xyp_endTimer = xyp_endTimer;
}

- (void)setXyp_Timer:(NSTimer *)xyp_Timer {
    if (_xyp_Timer.isValid) {
        [_xyp_Timer invalidate];
        _xyp_Timer = nil;
    }
    _xyp_Timer = xyp_Timer;
}

#pragma mark - Getter
- (UIView *)xyp_containerView {
    if(!_xyp_containerView){
        _xyp_containerView = [[UIView alloc] init];
        _xyp_containerView.userInteractionEnabled = NO;
    }
    return  _xyp_containerView;
}

- (UIPushBehavior *)xyp_pushBehavior {
    if(!_xyp_pushBehavior) {
        _xyp_pushBehavior = [[UIPushBehavior alloc] initWithItems:@[] mode:UIPushBehaviorModeInstantaneous];
    }
    return _xyp_pushBehavior;
}

- (UIGravityBehavior *)xyp_gravityBehavior {
    if(!_xyp_gravityBehavior) {
        _xyp_gravityBehavior = [[UIGravityBehavior alloc] init];
        _xyp_gravityBehavior.gravityDirection = CGVectorMake(0.0, 3.0);
        _xyp_gravityBehavior.magnitude = 0.7;
    }
    return _xyp_gravityBehavior;
}

- (UICollisionBehavior *)xyp_collisionBehavior {
    if(!_xyp_collisionBehavior) {
        _xyp_collisionBehavior = [[UICollisionBehavior alloc] init];
        _xyp_collisionBehavior.collisionMode = UICollisionBehaviorModeItems;
    }
    return _xyp_collisionBehavior;
}

- (UIDynamicItemBehavior *)xyp_dynamicBehavior {
    if (!_xyp_dynamicBehavior) {
        _xyp_dynamicBehavior = [[UIDynamicItemBehavior alloc] init];
        _xyp_dynamicBehavior.elasticity = 0.75;
        _xyp_dynamicBehavior.friction = 0.1;
        _xyp_dynamicBehavior.resistance = 0.0;
    }
    return _xyp_dynamicBehavior;
}

@end
