//// OWLBGMUserDetailDataInfoView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 数据信息视图【关注 + 粉丝 + 消费/奖章】
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailDataInfoView.h"
#import "OWLBGMUserDetailDataInfoSubView.h"

@interface OWLBGMUserDetailDataInfoView()

/// stackView
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 关注视图
@property (nonatomic, strong) OWLBGMUserDetailDataInfoSubView *xyp_followingView;
/// 粉丝视图
@property (nonatomic, strong) OWLBGMUserDetailDataInfoSubView *xyp_followersView;
/// 消费/奖章
@property (nonatomic, strong) OWLBGMUserDetailDataInfoSubView *xyp_functionView;

@end

@implementation OWLBGMUserDetailDataInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_followingView];
    [self.xyp_stackView addArrangedSubview:self.xyp_followersView];
    [self.xyp_stackView addArrangedSubview:self.xyp_functionView];
}

#pragma mark - Setter
- (void)setXyp_isAnchor:(BOOL)xyp_isAnchor {
    _xyp_isAnchor = xyp_isAnchor;
    self.xyp_functionView.xyp_title = xyp_isAnchor ? kXYLLocalString(@"Medals") : kXYLLocalString(@"Send coins");
}

- (void)setXyp_model:(OWLMusicAccountDetailInfoModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_followingView.xyp_num = xyp_model.xyp_followings;
    self.xyp_followersView.xyp_num = xyp_model.xyp_followers;
    self.xyp_functionView.xyp_num = self.xyp_isAnchor ? xyp_model.xyp_lables.count : xyp_model.xyp_giftCost;
}

#pragma mark - Getter
- (CGFloat)xyf_getHeight {
    return 49;
}

#pragma mark - Lazy
- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] init];
        _xyp_stackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_stackView.alignment = UIStackViewAlignmentFill;
        _xyp_stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _xyp_stackView;
}

- (OWLBGMUserDetailDataInfoSubView *)xyp_followingView {
    if (!_xyp_followingView) {
        _xyp_followingView = [[OWLBGMUserDetailDataInfoSubView alloc] init];
        _xyp_followingView.xyp_title = kXYLLocalString(@"Following");
    }
    return _xyp_followingView;
}

- (OWLBGMUserDetailDataInfoSubView *)xyp_followersView {
    if (!_xyp_followersView) {
        _xyp_followersView = [[OWLBGMUserDetailDataInfoSubView alloc] init];
        _xyp_followersView.xyp_title = kXYLLocalString(@"Followers");
    }
    return _xyp_followersView;
}

- (OWLBGMUserDetailDataInfoSubView *)xyp_functionView {
    if (!_xyp_functionView) {
        _xyp_functionView = [[OWLBGMUserDetailDataInfoSubView alloc] init];
        
    }
    return _xyp_functionView;
}

@end
