//
//  OWLBGMPKOtherAnchorInfoView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 用户pk信息视图 - 对面主播信息
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKOtherAnchorInfoView.h"

@interface OWLBGMPKOtherAnchorInfoView ()

/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 头像
@property (nonatomic, strong) UIImageView *xyp_avatarView;
/// 昵称
@property (nonatomic, strong) UILabel *xyp_nicknameLabel;
/// 按钮
@property (nonatomic, strong) UIButton *xyp_userButton;

@end

@implementation OWLBGMPKOtherAnchorInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }
    
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    for (UIView *view in self.subviews) {
        CGPoint tempPoint = [view convertPoint:point fromView:self];
        CGRect bounds = view.bounds;
        if (CGRectContainsPoint(bounds, tempPoint)) {
            if ([view isKindOfClass:[UIButton class]]) {
                return view;
            }
        }
    }
    return nil;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_avatarView];
    [self.xyp_avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.xyp_bgView);
        make.leading.equalTo(self.xyp_bgView).offset(2);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_nicknameLabel];
    [self.xyp_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_avatarView.mas_trailing).offset(2);
        make.width.mas_equalTo(51);
        make.centerY.equalTo(self.xyp_bgView);
    }];
    
    [self addSubview:self.xyp_userButton];
    [self.xyp_userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setXyp_otherPlayerModel:(OWLMusicRoomPKPlayerModel *)xyp_otherPlayerModel {
    _xyp_otherPlayerModel = xyp_otherPlayerModel;
    [XYCUtil xyf_loadSmallImage:self.xyp_avatarView url:xyp_otherPlayerModel.dsb_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nicknameLabel.text = xyp_otherPlayerModel.dsb_nickname;
}

#pragma mark - Actions
- (void)xyf_userButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewClickInfoEvent:accountID:avatar:nickname:displayAccountID:isAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewClickInfoEvent:XYLModuleBaseViewInfoClickType_ShowUserDetailView accountID:self.xyp_otherPlayerModel.dsb_accountID avatar:@"" nickname:@"" displayAccountID:@"" isAnchor:YES];
    }
}

#pragma mark - Getter
- (CGRect)xyf_anchorViewFrame {
    CGFloat width = 87;
    CGFloat x = kXYLScreenWidth - width - 6;
    return CGRectMake(x, 10, width, 24);
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.backgroundColor = kXYLColorFromRGBA(0x000000, 0.3);
        _xyp_bgView.layer.cornerRadius = 12;
        _xyp_bgView.clipsToBounds = YES;
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_avatarView {
    if (!_xyp_avatarView) {
        _xyp_avatarView = [[UIImageView alloc] init];
        _xyp_avatarView.clipsToBounds = YES;
        _xyp_avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_avatarView.layer.cornerRadius = 10;
    }
    return _xyp_avatarView;
}

- (UILabel *)xyp_nicknameLabel {
    if (!_xyp_nicknameLabel) {
        _xyp_nicknameLabel = [[UILabel alloc] init];
        _xyp_nicknameLabel.textColor = UIColor.whiteColor;
        _xyp_nicknameLabel.font = kXYLGilroyMediumFont(12);
    }
    return _xyp_nicknameLabel;
}

- (UIButton *)xyp_userButton {
    if (!_xyp_userButton) {
        _xyp_userButton = [[UIButton alloc] init];
        [_xyp_userButton addTarget:self action:@selector(xyf_userButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_userButton;
}

@end
