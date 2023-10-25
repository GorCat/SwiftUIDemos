//
//  OWLMusicPKVSUserView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/15.
//

#import "OWLMusicPKVSUserView.h"

@interface OWLMusicPKVSUserView ()

/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgView;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarIV;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 是否是对方主播
@property (nonatomic, assign) BOOL xyp_isOtherAnchor;

@end

@implementation OWLMusicPKVSUserView

- (instancetype)initWithIsOtherAnchor:(BOOL)isOtherAnchor  {
    self = [super init];
    if (self) {
        self.xyp_isOtherAnchor = isOtherAnchor;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self addSubview:self.xyp_avatarIV];
    [self addSubview:self.xyp_nicknameLabel];
    
    if (self.xyp_isOtherAnchor) {
        [XYCUtil xyf_loadIconImage:self.xyp_bgView iconStr:@"xyr_pk_blue_vs_animate_bg"];
        [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(155.5);
            make.trailing.equalTo(self).offset(2);
        }];
        
        [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(33);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-6);
        }];
        
        [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.xyp_avatarIV.mas_left).offset(-5);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(26.5);
        }];
        self.xyp_nicknameLabel.textAlignment = NSTextAlignmentRight;
        
    } else {
        [XYCUtil xyf_loadIconImage:self.xyp_bgView iconStr:@"xyr_pk_red_vs_animate_bg"];
        [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.trailing.equalTo(self);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(155.5);
            make.leading.equalTo(self).offset(-2);
        }];
        
        [self.xyp_avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(33);
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(6);
        }];
        
        [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.xyp_avatarIV.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-26.5);
        }];
        self.xyp_nicknameLabel.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - 更新
- (void)setXyp_playerModel:(OWLMusicRoomPKPlayerModel *)xyp_playerModel {
    _xyp_playerModel = xyp_playerModel;
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarIV url:xyp_playerModel.dsb_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nicknameLabel.text = xyp_playerModel.dsb_nickname;
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIImageView alloc] init];
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_avatarIV {
    if (!_xyp_avatarIV) {
        _xyp_avatarIV = [[UIImageView alloc] init];
        _xyp_avatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarIV.clipsToBounds = YES;
        _xyp_avatarIV.layer.cornerRadius = 16.5;
    }
    return _xyp_avatarIV;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.font = [UIFont fontWithName:@"PingFang-SC-Semibold" size:12];
        _xyp_nicknameLabel.textColor = UIColor.whiteColor;
    }
    return _xyp_nicknameLabel;
}

@end
