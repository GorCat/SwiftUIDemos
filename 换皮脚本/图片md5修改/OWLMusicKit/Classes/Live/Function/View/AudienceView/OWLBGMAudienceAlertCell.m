//// OWLBGMAudienceAlertCell.m
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间观众列表弹窗 - 观众cell
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import "OWLBGMAudienceAlertCell.h"
#import "OWLBGMUserAgeAndGenderView.h"

@interface OWLBGMAudienceAlertCell()

/// 容器
@property (nonatomic, strong) UIView *xyp_bgView;
/// 排名
@property (nonatomic, strong) UILabel *xyp_rankLabel;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 金币数
@property (nonatomic, strong) UILabel *xyp_coinsLabel;
/// vip
@property (nonatomic, strong) UIImageView *xyp_vipIV;
/// host
@property (nonatomic, strong) UIImageView *xyp_hostIV;
/// 点赞视图
@property (nonatomic, strong) UIView *xyp_likeView;
/// 点赞数
@property (nonatomic, strong) UILabel *xyp_likeNumLabel;
/// 性别
@property (nonatomic, strong) OWLBGMUserAgeAndGenderView *xyp_ageGenderView;

@end

@implementation OWLBGMAudienceAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(9);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_avatarIV];
    [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_bgView).offset(38);
        make.centerY.equalTo(self.xyp_bgView);
        make.height.width.mas_equalTo(38);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_rankLabel];
    [self.xyp_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_bgView);
        make.trailing.equalTo(self.xyp_avatarIV.mas_leading);
        make.centerY.equalTo(self.xyp_bgView);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_coinsLabel];
    [self.xyp_coinsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_bgView);
        make.trailing.equalTo(self.xyp_bgView).offset(-16.5);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_nicknameLabel];
    [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_avatarIV);
        make.height.mas_equalTo(20.5);
        make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(6);
        make.trailing.equalTo(self.xyp_coinsLabel.mas_leading).offset(-6);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_ageGenderView];
    [self.xyp_ageGenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.xyp_ageGenderView.xyp_config.xyp_totalSize);
        make.leading.equalTo(self.xyp_avatarIV.mas_trailing).offset(6);
        make.bottom.equalTo(self.xyp_avatarIV.mas_bottom).offset(-2);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_vipIV];
    [self.xyp_vipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_ageGenderView.mas_trailing).offset(4);
        make.centerY.equalTo(self.xyp_ageGenderView);
        make.size.mas_equalTo(CGSizeMake(29, 14));
    }];
    [self.xyp_bgView addSubview:self.xyp_hostIV];
    [self.xyp_hostIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_ageGenderView.mas_trailing).offset(4);
        make.centerY.equalTo(self.xyp_ageGenderView);
        make.size.mas_equalTo(CGSizeMake(35.5, 14));
    }];
    [self.xyp_bgView addSubview:self.xyp_likeView];
    [self.xyp_likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_ageGenderView);
        make.leading.equalTo(self.xyp_hostIV.mas_trailing).offset(4);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Setter
- (void)setXyp_model:(OWLMusicMemberModel *)xyp_model {
    _xyp_model = xyp_model;
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:xyp_model.xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nicknameLabel.text = xyp_model.xyp_nickName;
    if (xyp_model.xyp_roleType == XYLModuleMemberType_Anchor) {
        self.xyp_likeNumLabel.text = [NSString stringWithFormat:@"%ld",xyp_model.xyp_commentUp];
    }
    self.xyp_coinsLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_model.xyp_giftCost];
    [self.xyp_ageGenderView xyf_updateGender:xyp_model.xyp_gender age:xyp_model.xyp_age];
    
    /// 主播标签
    self.xyp_hostIV.hidden = xyp_model.xyp_roleType == XYLModuleMemberType_User || OWLJConvertToolShared.xyf_isGreen;
    self.xyp_likeView.hidden = xyp_model.xyp_roleType == XYLModuleMemberType_User;
    if (self.xyp_hostIV.isHidden) {
        [self.xyp_likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.xyp_ageGenderView);
            make.leading.equalTo(self.xyp_ageGenderView.mas_trailing).offset(4);
            make.height.mas_equalTo(14);
        }];
    } else {
        [self.xyp_likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.xyp_ageGenderView);
            make.leading.equalTo(self.xyp_hostIV.mas_trailing).offset(4);
            make.height.mas_equalTo(14);
        }];
    }
    
    /// vip标签
    if (xyp_model.xyp_roleType == XYLModuleMemberType_User) {
        NSString *iconStr = @"";
        CGSize size = CGSizeZero;
        if (xyp_model.xyp_isSVip) {
            [XYCUtil xyf_loadIconImage:self.xyp_vipIV iconStr:@"xyr_barrige_svip"];
            size = CGSizeMake(33, 14);
            self.xyp_vipIV.hidden = NO;
        } else if (xyp_model.xyp_isVip) {
            [XYCUtil xyf_loadIconImage:self.xyp_vipIV iconStr:@"xyr_barrige_vip"];
            size = CGSizeMake(29, 14);
            self.xyp_vipIV.hidden = NO;
        } else {
            self.xyp_vipIV.hidden = YES;
        }
        
        [self.xyp_vipIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    } else {
        self.xyp_vipIV.hidden = YES;
    }
}

- (void)setXyp_index:(NSInteger)xyp_index {
    _xyp_index = xyp_index;
    if (self.xyp_model.xyp_giftCost > 0) {
        self.xyp_rankLabel.text = [NSString stringWithFormat:@"%ld",(long)xyp_index];
        self.xyp_rankLabel.textColor = [self xyf_getRankColor:xyp_index];
    } else {
        self.xyp_rankLabel.text = @"-";
        self.xyp_rankLabel.textColor = kXYLColorFromRGB(0xB0B0B1);
    }
}

#pragma mark - 更新
- (UIColor *)xyf_getRankColor:(NSInteger)rank {
    switch (rank) {
        case 1:
            return kXYLColorFromRGB(0xFFA500);
        case 2:
            return kXYLColorFromRGB(0x95C5F2);
        case 3:
            return kXYLColorFromRGB(0x968554);
        default:
            return kXYLColorFromRGB(0xB0B0B1);
    }
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
    }
    return _xyp_bgView;
}

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
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.layer.cornerRadius = 19;
    }
    return _xyp_avatarIV;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.font = kXYLGilroyBoldFont(14);
        _xyp_nicknameLabel.textColor = kXYLColorFromRGB(0x0B0B0B);
        _xyp_nicknameLabel.textAlignment = NSTextAlignmentLeft;
        [_xyp_nicknameLabel xyf_atl];
    }
    return _xyp_nicknameLabel;
}

- (UILabel *)xyp_coinsLabel {
    if (!_xyp_coinsLabel) {
        _xyp_coinsLabel = [[UILabel alloc] init];
        _xyp_coinsLabel.font = kXYLGilroyBoldFont(12);
        _xyp_coinsLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_coinsLabel.textAlignment = NSTextAlignmentRight;
        [_xyp_coinsLabel xyf_atl];
    }
    return _xyp_coinsLabel;
}

- (UIImageView *)xyp_vipIV {
    if (!_xyp_vipIV) {
        _xyp_vipIV = [[UIImageView alloc] init];
    }
    return _xyp_vipIV;
}

- (UIImageView *)xyp_hostIV {
    if (!_xyp_hostIV) {
        _xyp_hostIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_hostIV iconStr:@"xyr_barrige_host"];
    }
    return _xyp_hostIV;
}

- (UIView *)xyp_likeView {
    if (!_xyp_likeView) {
        _xyp_likeView = [[UIView alloc] init];
        _xyp_likeView.backgroundColor = kXYLColorFromRGB(0xFC4D97);
        _xyp_likeView.layer.cornerRadius = 7;
        _xyp_likeView.clipsToBounds = YES;
        UIImageView *likeIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:likeIV iconStr:@"xyr_member_likes_icon"];
        [_xyp_likeView addSubview:likeIV];
        [likeIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_xyp_likeView).offset(3.5);
            make.centerY.equalTo(_xyp_likeView);
            make.width.height.mas_equalTo(10);
        }];
        
        [_xyp_likeView addSubview:self.xyp_likeNumLabel];
        [self.xyp_likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(likeIV.mas_trailing).offset(3.5);
            make.trailing.equalTo(_xyp_likeView).offset(-4);
            make.centerY.height.equalTo(_xyp_likeView);
        }];
    }
    return _xyp_likeView;
}

- (UILabel *)xyp_likeNumLabel {
    if (!_xyp_likeNumLabel) {
        _xyp_likeNumLabel = [[UILabel alloc] init];
        _xyp_likeNumLabel.textColor = UIColor.whiteColor;
        _xyp_likeNumLabel.font = kXYLGilroyBoldFont(11);
    }
    return _xyp_likeNumLabel;
}

- (OWLBGMUserAgeAndGenderView *)xyp_ageGenderView {
    if (!_xyp_ageGenderView) {
        _xyp_ageGenderView = [[OWLBGMUserAgeAndGenderView alloc] initWithType:OWLBGMUserAgeAndGenderViewSizeType_3414];
    }
    return _xyp_ageGenderView;
}

@end
