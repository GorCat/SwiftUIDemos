//// OWLBGMUserDetailBaseInfoView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 基础信息视图【昵称 + 性别 + 个签】
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserDetailBaseInfoView.h"
#import "OWLBGMUserAgeAndGenderView.h"

@interface OWLBGMUserDetailBaseInfoView()

/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// stackView
@property (nonatomic, strong) UIStackView *xyp_stackView;
/// 主播视图
@property (nonatomic, strong) UIImageView *xyp_anchorIV;
/// SVIP视图
@property (nonatomic, strong) UIImageView *xyp_svipIV;
/// 性别年龄
@property (nonatomic, strong) OWLBGMUserAgeAndGenderView *xyp_ageGenderView;
/// 个签
@property (nonatomic, strong) UILabel *xyp_moodLabel;

@end

@implementation OWLBGMUserDetailBaseInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_nicknameLabel];
    [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(12);
    }];
    
    [self addSubview:self.xyp_stackView];
    [self.xyp_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_nicknameLabel.mas_bottom);
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self);
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_ageGenderView];
    [self.xyp_ageGenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.xyp_ageGenderView.xyp_config.xyp_totalSize);
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_anchorIV];
    [self.xyp_anchorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45.6, 18));
    }];
    
    [self.xyp_stackView addArrangedSubview:self.xyp_svipIV];
    [self.xyp_svipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42.42, 18));
    }];
    
    [self addSubview:self.xyp_moodLabel];
    [self.xyp_moodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(58);
        make.trailing.equalTo(self).offset(-58);
        make.top.equalTo(self.xyp_stackView.mas_bottom).offset(12);
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicAccountDetailInfoModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_nicknameLabel.text = xyp_model.xyp_nickName;
    self.xyp_moodLabel.text = [XYCUtil xyf_moodTip:xyp_model.xyp_mood];
    [self.xyp_ageGenderView xyf_updateGender:xyp_model.xyp_gender age:xyp_model.xyp_age];
    self.xyp_anchorIV.hidden = !xyp_model.xyp_isAnchor || OWLJConvertToolShared.xyf_isGreen;
    self.xyp_svipIV.hidden = !xyp_model.xyp_isSvip;
}

#pragma mark - Getter
- (CGFloat)xyf_getHeight {
    return 112;
}

#pragma mark - Lazy
- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.font = kXYLGilroyBoldFont(18);
        _xyp_nicknameLabel.textColor = kXYLColorFromRGB(0x333333);
    }
    return _xyp_nicknameLabel;
}

- (UIStackView *)xyp_stackView {
    if (!_xyp_stackView) {
        _xyp_stackView = [[UIStackView alloc] init];
        _xyp_stackView.axis = UILayoutConstraintAxisHorizontal;
        _xyp_stackView.distribution = UIStackViewDistributionFillProportionally;
        _xyp_stackView.alignment = UIStackViewAlignmentCenter;
        _xyp_stackView.spacing = 6;
    }
    return _xyp_stackView;
}

- (OWLBGMUserAgeAndGenderView *)xyp_ageGenderView {
    if (!_xyp_ageGenderView) {
        _xyp_ageGenderView = [[OWLBGMUserAgeAndGenderView alloc] initWithType:OWLBGMUserAgeAndGenderViewSizeType_4018];
    }
    return _xyp_ageGenderView;
}

- (UIImageView *)xyp_anchorIV {
    if (!_xyp_anchorIV) {
        _xyp_anchorIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_anchorIV iconStr:@"xyr_barrige_host"];
    }
    return _xyp_anchorIV;
}

- (UIImageView *)xyp_svipIV {
    if (!_xyp_svipIV) {
        _xyp_svipIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_svipIV iconStr:@"xyr_barrige_svip"];
    }
    return _xyp_svipIV;
}

- (UILabel *)xyp_moodLabel {
    if (!_xyp_moodLabel) {
        _xyp_moodLabel = [[UILabel alloc] init];
        _xyp_moodLabel.textColor = kXYLColorFromRGB(0xB0B0B1);
        _xyp_moodLabel.numberOfLines = 2;
        _xyp_moodLabel.font = kXYLGilroyMediumFont(12);
        _xyp_moodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_moodLabel;
}

@end
