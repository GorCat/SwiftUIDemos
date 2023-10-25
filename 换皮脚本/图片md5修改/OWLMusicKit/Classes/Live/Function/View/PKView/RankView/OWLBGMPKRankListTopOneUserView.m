//
//  OWLBGMPKRankListTopOneUserView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 排行榜弹窗 - 第一名
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMPKRankListTopOneUserView.h"


@interface OWLBGMPKRankListTopOneUserView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgIV;
/// icon
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 标题
@property (nonatomic, strong) UIImageView *xyp_titleIV;
/// 用户信息
@property (nonatomic, strong) OWLBGMPKRankListUserInfoView *xyp_userView;

#pragma mark - BOOL
/// 是否是对方主播
@property (nonatomic, assign) BOOL xyp_isOtherAnchor;

@end

@implementation OWLBGMPKRankListTopOneUserView

- (instancetype)initWithIsOtherAnchor:(BOOL)isOtherAnchor {
    self = [super init];
    if (self) {
        self.xyp_isOtherAnchor = isOtherAnchor;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgIV];
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGFloat bottomMargin = self.xyp_isOtherAnchor ? 9.5 : 3.5;
    [self addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(117.5);
        make.bottom.equalTo(self).offset(bottomMargin);
        make.trailing.equalTo(self).offset(-11);
    }];
    
    [self addSubview:self.xyp_userView];
    [self.xyp_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_equalTo(56);
    }];
    
    CGFloat width = self.xyp_isOtherAnchor ? 176 : 168;
    if ([OWLJConvertToolShared.xyf_currentLanguage isEqualToString:@"ar"]) {
        width = self.xyp_isOtherAnchor ? 135 : 133.5;
    }
    [self addSubview:self.xyp_titleIV];
    [self.xyp_titleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self).offset(16);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(width);
    }];
    
    if (self.xyp_isOtherAnchor) {
        self.xyp_bgIV.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0x67BDFF), kXYLColorFromRGB(0x5DB8FF)] size:CGSizeMake(kXYLScreenWidth, 84) direction:UIImageGradientDirectionHorizontal];
        [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_pk_rank_list_blue_image"];
        [XYCUtil xyf_loadMainLanguageImage:self.xyp_titleIV iconStr:@"xyr_pk_rank_list_blue_title_image"];
    } else {
        self.xyp_bgIV.image = [UIImage imageWithGradient:@[kXYLColorFromRGB(0xFF5DAD), kXYLColorFromRGB(0xFB8EA4)] size:CGSizeMake(kXYLScreenWidth, 84) direction:UIImageGradientDirectionHorizontal];
        [XYCUtil xyf_loadIconImage:self.xyp_iconIV iconStr:@"xyr_pk_rank_list_red_image"];
        [XYCUtil xyf_loadMainLanguageImage:self.xyp_titleIV iconStr:@"xyr_pk_rank_list_red_title_image"];
    }
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicPKTopUserModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_userView.xyp_model = _xyp_model;
    self.xyp_userView.xyp_rank = 1;
}

- (void)setDelegate:(id<OWLBGMPKRankListUserInfoViewDelegate>)delegate {
    self.xyp_userView.delegate = delegate;
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
    }
    return _xyp_bgIV;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        _xyp_iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_iconIV.clipsToBounds = YES;
    }
    return _xyp_iconIV;
}

- (UIImageView *)xyp_titleIV {
    if (!_xyp_titleIV) {
        _xyp_titleIV = [[UIImageView alloc] init];
        _xyp_titleIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_titleIV.clipsToBounds = YES;
    }
    return _xyp_titleIV;
}

- (OWLBGMPKRankListUserInfoView *)xyp_userView {
    if (!_xyp_userView) {
        _xyp_userView = [[OWLBGMPKRankListUserInfoView alloc] initWithIsTopOne:YES];
    }
    return _xyp_userView;
}

@end
