//
//  OWLBGMPKTopThreeSeatView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 前三名座位
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKTopThreeSeatView.h"
#import "OWLBGMPKTopThreeSeatAvatarView.h"

@interface OWLBGMPKTopThreeSeatView ()

#pragma mark - Views
/// stackview
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 第一个
@property (nonatomic, strong) OWLBGMPKTopThreeSeatAvatarView *xyp_firstView;
/// 第二个
@property (nonatomic, strong) OWLBGMPKTopThreeSeatAvatarView *xyp_secondView;
/// 第三个
@property (nonatomic, strong) OWLBGMPKTopThreeSeatAvatarView *xyp_thirdView;

#pragma mark - BOOL
/// 是否是对面主播
@property (nonatomic, assign) BOOL xyp_isOtherAnchor;

#pragma mark - Data
/// 视图数组
@property (nonatomic, strong) NSArray *xyp_viewList;

@end

@implementation OWLBGMPKTopThreeSeatView

- (instancetype)initWithframe:(CGRect)frame isOtherAnchor:(BOOL)isOtherAnchor {
    self = [super initWithFrame:frame];
    if (self) {
        self.xyp_isOtherAnchor = isOtherAnchor;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_stackView];
    
    if (OWLJConvertToolShared.xyf_isRTL) {
        [self xyf_firstViewIsFirstAdd:!self.xyp_isOtherAnchor];
    } else {
        [self xyf_firstViewIsFirstAdd:self.xyp_isOtherAnchor];
    }
}

/// 第一名座位是否是第一个被加入到stackview中
- (void)xyf_firstViewIsFirstAdd:(BOOL)isFirstAdd {
    if (isFirstAdd) {
        [self.xyp_stackView addArrangedSubview:self.xyp_firstView];
        [self.xyp_stackView addArrangedSubview:self.xyp_secondView];
        [self.xyp_stackView addArrangedSubview:self.xyp_thirdView];
    } else {
        [self.xyp_stackView addArrangedSubview:self.xyp_thirdView];
        [self.xyp_stackView addArrangedSubview:self.xyp_secondView];
        [self.xyp_stackView addArrangedSubview:self.xyp_firstView];
    }
}

#pragma mark - Setter
- (void)setXyp_avatarList:(NSArray *)xyp_avatarList {
    _xyp_avatarList = xyp_avatarList;
    NSMutableArray *list = [NSMutableArray arrayWithArray:xyp_avatarList];
    for (int i = 0; i < 3; i++) {
        NSString *avatarStr = (NSString *)[list xyf_objectAtIndexSafe:i];
        OWLBGMPKTopThreeSeatAvatarView *view = (OWLBGMPKTopThreeSeatAvatarView *)[self.xyp_viewList xyf_objectAtIndexSafe:i];
        view.xyp_avatar = avatarStr;
    }
}

#pragma mark - Lazy
- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] initWithFrame:self.bounds];
        _xyp_stackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_stackView.alignment = UIStackViewAlignmentFill;
        _xyp_stackView.distribution = UIStackViewDistributionFillEqually;
        _xyp_stackView.spacing = 6;
    }
    return _xyp_stackView;
}

- (OWLBGMPKTopThreeSeatAvatarView *)xyp_firstView {
    if (!_xyp_firstView) {
        _xyp_firstView = [[OWLBGMPKTopThreeSeatAvatarView alloc] init];
        _xyp_firstView.xyp_size = CGSizeMake(27, 27);
        [_xyp_firstView xyf_updateSeatNum:1 isOther:self.xyp_isOtherAnchor];
    }
    return _xyp_firstView;
}

- (OWLBGMPKTopThreeSeatAvatarView *)xyp_secondView {
    if (!_xyp_secondView) {
        _xyp_secondView = [[OWLBGMPKTopThreeSeatAvatarView alloc] init];
        [_xyp_secondView xyf_updateSeatNum:2 isOther:self.xyp_isOtherAnchor];
    }
    return _xyp_secondView;
}

- (OWLBGMPKTopThreeSeatAvatarView *)xyp_thirdView {
    if (!_xyp_thirdView) {
        _xyp_thirdView = [[OWLBGMPKTopThreeSeatAvatarView alloc] init];
        [_xyp_thirdView xyf_updateSeatNum:3 isOther:self.xyp_isOtherAnchor];
    }
    return _xyp_thirdView;
}

- (NSArray *)xyp_viewList {
    if (!_xyp_viewList) {
        _xyp_viewList = @[self.xyp_firstView, self.xyp_secondView, self.xyp_thirdView];
    }
    return _xyp_viewList;
}

@end
