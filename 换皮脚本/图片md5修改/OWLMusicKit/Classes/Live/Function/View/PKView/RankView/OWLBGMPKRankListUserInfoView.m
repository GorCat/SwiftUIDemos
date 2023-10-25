//
//  OWLBGMPKRankListUserInfoView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK - 排行榜弹窗 - 用户信息视图
 * @创建时间：2023.2.15
 * @创建人：许琰
 */

#import "OWLBGMPKRankListUserInfoView.h"

@interface OWLBGMPKRankListUserInfoView ()

#pragma mark - Views
/// 排行
@property (nonatomic, strong) UILabel *xyp_rankLabel;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 空文案
@property (nonatomic, strong) UILabel *xyp_emptyLabel;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 身份
@property (nonatomic, strong) UIImageView *xyp_svvImg;
/// 金币数量
@property (nonatomic, strong) UILabel *xyp_coinLabel;

#pragma mark - BOOL
/// 是否是第一个
@property (nonatomic, assign) BOOL xyp_isTopOne;

@end

@implementation OWLBGMPKRankListUserInfoView

- (instancetype)initWithIsTopOne:(BOOL)isTopOne {
    self = [super init];
    if (self) {
        self.xyp_isTopOne = isTopOne;
        [self xyf_setupView];
        [self xyf_setupTap];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_rankLabel];
    [self addSubview:self.xyp_avatarIV];
    [self addSubview:self.xyp_coinLabel];
    [self addSubview:self.xyp_emptyLabel];
    [self addSubview:self.xyp_nicknameLabel];
    [self addSubview:self.xyp_svvImg];
    
    [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(38);
        make.leading.equalTo(self).offset(37);
    }];
    
    [self.xyp_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self.xyp_avatarIV.mas_leading);
        make.centerY.equalTo(self);
    }];
    
    [self.xyp_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-16.5);
        make.centerY.equalTo(self);
    }];
    
    [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(6);
        make.centerY.equalTo(self);
        make.trailing.lessThanOrEqualTo(self.xyp_coinLabel.mas_leading).offset(-5);
    }];
    
    [self.xyp_svvImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.xyp_nicknameLabel.mas_trailing).offset(5);
        make.size.mas_equalTo(CGSizeMake(33, 14));
    }];
    
    [self.xyp_emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(6);
        make.centerY.equalTo(self);
    }];
    
    self.xyp_rankLabel.textColor = self.xyp_isTopOne ? UIColor.whiteColor : kXYLColorFromRGB(0xB0B0B1);
    self.xyp_nicknameLabel.textColor = self.xyp_isTopOne ? UIColor.whiteColor : kXYLColorFromRGB(0x0B0B0B);
    self.xyp_coinLabel.textColor = self.xyp_isTopOne ? UIColor.whiteColor : kXYLColorFromRGB(0x080808);
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_viewAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicPKTopUserModel *)xyp_model {
    _xyp_model = xyp_model;
    self.xyp_svvImg.hidden = YES;
    if (_xyp_model == nil && self.xyp_isTopOne) {
        self.xyp_emptyLabel.hidden = NO;
        self.xyp_avatarIV.image = OWLJConvertToolShared.xyf_userPlaceHolder;
        self.xyp_coinLabel.text = kXYLLocalString(@"0");
        return;
    }
    self.xyp_nicknameLabel.text = xyp_model.dsb_nickname;
    if (xyp_model.dsb_isSVipUser || xyp_model.dsb_isVipUser) {
        self.xyp_svvImg.hidden = NO;
        NSString * iconStr = @"xyr_barrige_vip";
        CGSize size = CGSizeMake(29, 14);
        if (xyp_model.dsb_isSVipUser) {
            iconStr = @"xyr_barrige_svip";
            size = CGSizeMake(33, 14);
        }
        [XYCUtil xyf_loadIconImage:self.xyp_svvImg iconStr:iconStr];
        [self.xyp_svvImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }
    
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:xyp_model.dsb_userAvatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_coinLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_model.dsb_userGoals];
}

- (void)setXyp_rank:(NSInteger)xyp_rank {
    _xyp_rank = xyp_rank;
    self.xyp_rankLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_rank];
}

#pragma mark - Actions
- (void)xyf_viewAction {
    if (self.xyp_model == nil) { return; }
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_pkRankListUserInfoClickAction:)]) {
        [self.delegate xyf_pkRankListUserInfoClickAction:self.xyp_model];
    }
}

#pragma mark - Lazy
- (UILabel *)xyp_rankLabel {
    if (!_xyp_rankLabel) {
        _xyp_rankLabel = [[UILabel alloc] init];
        _xyp_rankLabel.font = kXYLGilroyBoldFont(14);
        _xyp_rankLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_rankLabel;
}

- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.layer.cornerRadius = 19;
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_avatarIV;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.font = kXYLGilroyBoldFont(14);
        [_xyp_nicknameLabel xyf_atl];
    }
    return _xyp_nicknameLabel;
}

- (UIImageView *)xyp_svvImg {
    if (!_xyp_svvImg) {
        _xyp_svvImg = [[UIImageView alloc] init];
    }
    return _xyp_svvImg;
}

- (UILabel *)xyp_coinLabel {
    if (!_xyp_coinLabel) {
        _xyp_coinLabel = [[UILabel alloc] init];
        _xyp_coinLabel.font = kXYLGilroyBoldFont(12);
        _xyp_coinLabel.textAlignment = NSTextAlignmentRight;
        [_xyp_coinLabel xyf_atl];
    }
    return _xyp_coinLabel;
}

- (UILabel *)xyp_emptyLabel {
    if (!_xyp_emptyLabel) {
        _xyp_emptyLabel = [[UILabel alloc] init];
        _xyp_emptyLabel.font = kXYLGilroyBoldFont(14);
        _xyp_emptyLabel.textColor = UIColor.whiteColor;
        _xyp_emptyLabel.text = kXYLLocalString(@"Waiting for you");
        _xyp_emptyLabel.hidden = YES;
    }
    return _xyp_emptyLabel;
}

@end
