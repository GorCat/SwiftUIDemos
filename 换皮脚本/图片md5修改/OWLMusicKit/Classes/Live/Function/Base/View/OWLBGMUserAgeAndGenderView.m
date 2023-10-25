//// OWLBGMUserAgeAndGenderView.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户性别年龄视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import "OWLBGMUserAgeAndGenderView.h"

@interface OWLBGMUserAgeAndGenderView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 性别图标
@property (nonatomic, strong) UIImageView *xyp_genderIV;
/// 年龄
@property (nonatomic, strong) UILabel *xyp_ageLabel;

#pragma mark - Data
/// 配置
@property (nonatomic, strong) OWLBGMUserAgeAndGenderConfig *xyp_config;

@end

@implementation OWLBGMUserAgeAndGenderView

- (instancetype)initWithType:(OWLJUserAgeAndGenderViewSizeType)type {
    self = [super init];
    if (self) {
        self.xyp_config = [OWLBGMUserAgeAndGenderConfig xyf_configWithType:type];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_genderIV];
    [self.xyp_genderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.xyp_config.xyp_genderSize);
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(self.xyp_config.xyp_genderLeftMargin);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_ageLabel];
    [self.xyp_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_genderIV.mas_trailing).offset(3.5);
        make.centerY.equalTo(self.xyp_bgView);
    }];
}

#pragma mark - Public
/// 更新信息
- (void)xyf_updateGender:(NSString *)gender age:(NSInteger)age {
    self.xyp_ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    XYLOutDataSourceGenderType genderType = [OWLJConvertToolShared xyf_getGenderType:gender];
    switch (genderType) {
        case XYLOutDataSourceGenderType_Female:
            [XYCUtil xyf_loadIconImage:self.xyp_genderIV iconStr:@"xyr_user_detail_gender_female_icon"];
            self.xyp_bgView.backgroundColor = kXYLColorFromRGB(0xFC4D97);
            break;
        case XYLOutDataSourceGenderType_Male:
            [XYCUtil xyf_loadIconImage:self.xyp_genderIV iconStr:@"xyr_user_detail_gender_male_icon"];
            self.xyp_bgView.backgroundColor = kXYLColorFromRGB(0x4D9AFC);
            break;
    }
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.layer.cornerRadius = self.xyp_config.xyp_totalSize.height / 2.0;
        _xyp_bgView.clipsToBounds = YES;
        _xyp_bgView.backgroundColor = kXYLColorFromRGB(0x4D9AFC);
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_genderIV {
    if (!_xyp_genderIV) {
        _xyp_genderIV = [[UIImageView alloc] init];
        _xyp_genderIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_genderIV.clipsToBounds = YES;
    }
    return _xyp_genderIV;
}

- (UILabel *)xyp_ageLabel {
    if (!_xyp_ageLabel) {
        _xyp_ageLabel = [[UILabel alloc] init];
        _xyp_ageLabel.textColor = kXYLColorFromRGB(0xffffff);
        _xyp_ageLabel.font = self.xyp_config.xyp_font;
    }
    return _xyp_ageLabel;
}

@end

@implementation OWLBGMUserAgeAndGenderConfig

+ (OWLBGMUserAgeAndGenderConfig *)xyf_configWithType:(OWLJUserAgeAndGenderViewSizeType)type {
    OWLBGMUserAgeAndGenderConfig *config = [[OWLBGMUserAgeAndGenderConfig alloc] init];
    config.xyp_sizeType = type;
    switch (type) {
        case OWLBGMUserAgeAndGenderViewSizeType_4018:
            config.xyp_font = kXYLGilroyBoldFont(12);
            config.xyp_totalSize = CGSizeMake(40, 18);
            config.xyp_genderSize = CGSizeMake(13, 13);
            config.xyp_genderLeftMargin = 4;
            break;
        case OWLBGMUserAgeAndGenderViewSizeType_3414:
            config.xyp_font = kXYLGilroyBoldFont(11);
            config.xyp_totalSize = CGSizeMake(34, 14);
            config.xyp_genderSize = CGSizeMake(10, 10);
            config.xyp_genderLeftMargin = 3.5;
            break;
    }
    
    return config;
}

@end
