//
//  OWLPPReceiveGiftCell.m
//  qianDuoDuo
//
//  Created by wdys on 2023/2/28.
//

#import "OWLPPReceiveGiftCell.h"
#import "OWLPPAddAlertTool.h"
#import "OWLPPReceiveGiftModel.h"

@interface OWLPPReceiveGiftCell()

@property (nonatomic, strong) UIView * xyp_colorView;

@property (nonatomic, strong) UIImageView * xyp_avatarImg;

@property (nonatomic, strong) UILabel * xyp_nameLab;

@property (nonatomic, strong) UILabel * xyp_msgLab;

@property (nonatomic, strong) UIImageView * xyp_giftImg;

@property (nonatomic, strong) UILabel * xyp_numberLab;

@property (nonatomic, strong) UIView * xyp_normalBgView;

@property (nonatomic, strong) UIView * xyp_svvBgView;

@end

@implementation OWLPPReceiveGiftCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
    }
    return self;
}

- (UIView *)xyp_colorView {
    if (!_xyp_colorView) {
        _xyp_colorView = [[UIView alloc] init];
        _xyp_colorView.backgroundColor = UIColor.clearColor;
    }
    return _xyp_colorView;
}

- (UIImageView *)xyp_avatarImg {
    if (!_xyp_avatarImg) {
        _xyp_avatarImg = [[UIImageView alloc] init];
        _xyp_avatarImg.layer.cornerRadius = 15;
        _xyp_avatarImg.layer.masksToBounds = YES;
        _xyp_avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_avatarImg;
}

- (UILabel *)xyp_nameLab {
    if (!_xyp_nameLab) {
        _xyp_nameLab = [[UILabel alloc] init];
        _xyp_nameLab.textColor = UIColor.whiteColor;
        _xyp_nameLab.font = kXYLGilroyBoldFont(14);
        _xyp_nameLab.textAlignment = NSTextAlignmentLeft;
        [_xyp_nameLab xyf_atl];
    }
    return _xyp_nameLab;
}

- (UILabel *)xyp_msgLab {
    if (!_xyp_msgLab) {
        _xyp_msgLab = [[UILabel alloc] init];
        _xyp_msgLab.textColor = UIColor.whiteColor;
        _xyp_msgLab.font = kXYLGilroyMediumFont(10);
        _xyp_msgLab.text = kXYLLocalString(@"Send gift");
        _xyp_msgLab.textAlignment = NSTextAlignmentLeft;
        [_xyp_msgLab xyf_atl];
    }
    return _xyp_msgLab;
}

- (UIImageView *)xyp_giftImg {
    if (!_xyp_giftImg) {
        _xyp_giftImg = [[UIImageView alloc] init];
        _xyp_giftImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _xyp_giftImg;
}

- (UILabel *)xyp_numberLab {
    if (!_xyp_numberLab) {
        _xyp_numberLab = [[UILabel alloc] init];
        _xyp_numberLab.textColor = UIColor.whiteColor;
        _xyp_numberLab.font = kXYLGilroyExtraBoldItalicFont(25);
        _xyp_numberLab.textAlignment = NSTextAlignmentLeft;
        [_xyp_numberLab xyf_atl];
    }
    return _xyp_numberLab;
}

- (UIView *)xyp_normalBgView {
    if (!_xyp_normalBgView) {
        _xyp_normalBgView = [[UIView alloc] init];
        [_xyp_normalBgView xyf_addThreeGradientColor:@[kXYLColorFromRGBA(0x000000, 0.7), kXYLColorFromRGBA(0x000000, 0.5), kXYLColorFromRGBA(0x000000, 0.2)] andColorFrame:CGRectMake(0, 0, 150, 38) andCorner:19];
    }
    return _xyp_normalBgView;
}

- (UIView *)xyp_svvBgView {
    if (!_xyp_svvBgView) {
        _xyp_svvBgView = [[UIView alloc] init];
        [_xyp_svvBgView xyf_addThreeGradientColor:@[kXYLColorFromRGBA(0x5241E9, 0.95), kXYLColorFromRGBA(0x5241E9, 0.85), kXYLColorFromRGBA(0x5241E9, 0.5)] andColorFrame:CGRectMake(0, 0, 150, 38) andCorner:19];
    }
    return _xyp_svvBgView;
}

#pragma mark - UI
- (void) xyf_setupUI {
    [self addSubview:self.xyp_colorView];
    [self.xyp_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(150, 38));
    }];
    [self.xyp_colorView addSubview:self.xyp_normalBgView];
    [self.xyp_normalBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_colorView);
    }];
    [self.xyp_colorView addSubview:self.xyp_svvBgView];
    [self.xyp_svvBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_colorView);
    }];
    [self.xyp_colorView addSubview:self.xyp_avatarImg];
    [self.xyp_avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.xyp_colorView);
        make.leading.equalTo(self.xyp_colorView).offset(4);
        make.width.height.mas_equalTo(30);
    }];
    [self.xyp_colorView addSubview:self.xyp_nameLab];
    [self.xyp_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_avatarImg.mas_trailing).offset(5);
        make.top.equalTo(self.xyp_colorView).offset(5);
        make.trailing.equalTo(self.xyp_colorView).offset(-38);
    }];
    [self.xyp_colorView addSubview:self.xyp_msgLab];
    [self.xyp_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.xyp_nameLab);
        make.bottom.equalTo(self.xyp_colorView).offset(-5);
    }];
    [self.xyp_colorView addSubview:self.xyp_giftImg];
    [self.xyp_giftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self.xyp_colorView);
        make.width.mas_equalTo(38);
    }];
    [self addSubview:self.xyp_numberLab];
    [self.xyp_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_colorView.mas_trailing);
        make.bottom.equalTo(self.xyp_colorView);
    }];
    [self.xyp_normalBgView setHidden:YES];
}

#pragma mark - 填充礼物数据
- (void)xyf_configGiftData:(OWLPPReceiveGiftModel *)msgModel {
    OWLMusicMessageModel * xyp_mModel = msgModel.xyp_giftModel;
    [self.xyp_normalBgView setHidden:YES];
    [self.xyp_svvBgView setHidden:YES];
    if (xyp_mModel.dsb_isSVipUser) {
        [self.xyp_svvBgView setHidden:NO];
    } else {
        [self.xyp_normalBgView setHidden:NO];
    }
    [self.xyp_avatarImg sd_setImageWithURL:[NSURL URLWithString:xyp_mModel.dsb_avatar] placeholderImage:OWLJConvertToolShared.xyf_userPlaceHolder];
    self.xyp_nameLab.text = xyp_mModel.dsb_nickname;
    OWLMusicGiftInfoModel * xyp_giftModel = [[OWLPPAddAlertTool shareInstance] xyf_inquireGiftModelWith:xyp_mModel.dsb_giftID];
    if (xyp_giftModel) {
        [XYCUtil xyf_loadOriginImage:self.xyp_giftImg url:xyp_giftModel.dsb_iconImageUrl placeholder:[XYCUtil xyf_getIconWithName:@"xyr_gift_default_danmu_image"]];
        [self.xyp_giftImg sd_setImageWithURL:[NSURL URLWithString:xyp_giftModel.dsb_iconImageUrl]];
        NSString *text = [NSString stringWithFormat:@"%@ %@", kXYLLocalString(@"Sent"),[self xyf_getAtrChar]];
        NSString *msg = [NSString stringWithFormat:@"%@%@",text,xyp_giftModel.dsb_giftName];
        self.xyp_msgLab.text = msg;
    }
    [self xyf_setupGiftNumberLab:msgModel.xyp_comboNumber];
    [self xyf_showComboEffect];
}

#pragma mark - 设置礼物数量
- (void) xyf_setupGiftNumberLab:(NSInteger) xyp_number {
    NSString *numStr = [NSString stringWithFormat:@"%ld",xyp_number];
    NSString *totalStr = OWLJConvertToolShared.xyf_isRTL ? [NSString stringWithFormat:@"%@ X",numStr] : [NSString stringWithFormat:@"X %@",numStr];
    NSMutableAttributedString * xyp_ast = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange range = [totalStr rangeOfString:@"X"];
    [xyp_ast addAttribute:NSFontAttributeName value:kXYLGilroyExtraBoldItalicFont(10) range:range];
    self.xyp_numberLab.attributedText = xyp_ast;
}

#pragma mark - 移动显示礼物
- (void) xyf_moveToDisplayGift {
    kXYLWeakSelf;
    CGRect xyp_rect = self.frame;
    xyp_rect.origin.x = 0;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.frame = xyp_rect;
    } completion:nil];
}

#pragma mark - 移出当前显示礼物
- (void) xyf_moveToHideGift {
    CGRect rect = self.frame;
    rect.origin.x = [self xyf_getInitX];
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = rect;
    }];
}

#pragma mark - 显示连击特效
- (void) xyf_showComboEffect {
    self.xyp_numberLab.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:12 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (OWLJConvertToolShared.xyf_isRTL) {
            self.xyp_numberLab.transform = CGAffineTransformMake(1.5, 0, 0, 1.5, -100/4, 0);
        } else {
            self.xyp_numberLab.transform = CGAffineTransformMake(1.5, 0, 0, 1.5, 100/4, 0);
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Getter
/// 获取初始值X
- (CGFloat) xyf_getInitX {
    return OWLJConvertToolShared.xyf_isRTL ? self.xyp_w : -self.xyp_w;
}

- (NSString *)xyf_getAtrChar {
    return OWLJConvertToolShared.xyf_isRTL ? @"\u202B" : @"\u202A";
}

@end
