//
//  OWLMusicTakeHerAlert.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/6.
//

#import "OWLMusicTakeHerAlert.h"

@interface OWLMusicTakeHerAlert()

@property (nonatomic, strong) UIView * xyp_popView;

@property (nonatomic, strong) OWLMusicGiftInfoModel * xyp_giftModel;

@property (nonatomic, strong) UIImageView * xyp_gIcon;

@property (nonatomic, strong) UILabel * xyp_gCoinLab;

@property (nonatomic, assign) NSInteger xyp_chatCoin;

@property (nonatomic, copy) NSString * xyp_userAvatar;

@property (nonatomic, copy) NSString * xyp_anchorAvatar;
 
@end

@implementation OWLMusicTakeHerAlert

+ (instancetype)xyf_showTakeHerAlertViewWithGift:(OWLMusicGiftInfoModel *)xyp_gModel
                                      targetView:(UIView *)xyp_showView
                                     andChatCoin:(NSInteger)xyp_coin
                                 andAnchorAvatar:(NSString *)xyp_aAvatar
                                   andUserAvatar:(NSString *)xyp_uAvatar
                                     andSureTake:(void(^)(void))xyp_takeHer
                                 andDismissBlock:(void(^)(void))xyp_dismissBlock {
    OWLMusicTakeHerAlert * xyp_alertView = [[OWLMusicTakeHerAlert alloc] initWithFrame:xyp_showView.bounds andPrivateGift:xyp_gModel andChatCoin:xyp_coin andAnchorAvatar:xyp_aAvatar andUserAvatar:xyp_uAvatar];
    xyp_alertView.xyp_sureTakeHer = ^{
        if (xyp_takeHer) {
            xyp_takeHer();
        }
    };
    xyp_alertView.xyp_dismissBlock = ^{
        if (xyp_dismissBlock) {
            xyp_dismissBlock();
        }
    };
    [xyp_showView addSubview:xyp_alertView];
    [xyp_alertView xyf_alertPrivateChat];
    
    return xyp_alertView;
}

- (instancetype)initWithFrame:(CGRect)frame andPrivateGift:(OWLMusicGiftInfoModel *) xyp_gModel andChatCoin:(NSInteger) xyp_coin andAnchorAvatar:(NSString *) xyp_aAvatar andUserAvatar:(NSString *) xyp_uAvatar {
    if (self = [super initWithFrame:frame]) {
        self.xyp_giftModel = xyp_gModel;
        self.xyp_chatCoin = xyp_coin;
        self.xyp_userAvatar = xyp_uAvatar;
        self.xyp_anchorAvatar = xyp_aAvatar;
        [self xyf_setupUI];
    }
    return self;
}

- (UIView *)xyp_popView {
    if (!_xyp_popView) {
        _xyp_popView = [[UIView alloc] initWithFrame:CGRectMake(0, self.xyp_h, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_popView.backgroundColor = UIColor.whiteColor;
        _xyp_popView.layer.cornerRadius = 20;
        _xyp_popView.layer.masksToBounds = YES;
    }
    return _xyp_popView;
}

#pragma mark - UI
- (void)xyf_setupUI {
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = UIColor.clearColor;
    [closeBtn addTarget:self action:@selector(xyf_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self addSubview:self.xyp_popView];
    UIImageView * xyp_avatarBg = [[UIImageView alloc] init];
    [XYCUtil xyf_loadIconImage:xyp_avatarBg iconStr:@"xyr_takeher_avatar_bgimg"];
    [self.xyp_popView addSubview:xyp_avatarBg];
    [xyp_avatarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_popView);
        make.top.equalTo(self.xyp_popView).offset(1);
        make.size.mas_equalTo(CGSizeMake(276, 179));
    }];
    UIImageView * xyp_leftAvatar = [[UIImageView alloc] init];
    xyp_leftAvatar.layer.cornerRadius = 26;
    xyp_leftAvatar.layer.borderColor = kXYLColorFromRGBA(0xFFFFFF, 0.74).CGColor;
    xyp_leftAvatar.layer.borderWidth = 2;
    xyp_leftAvatar.clipsToBounds = YES;
    xyp_leftAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [xyp_avatarBg addSubview:xyp_leftAvatar];
    [xyp_leftAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(xyp_avatarBg).offset(63.5);
        make.top.equalTo(xyp_avatarBg).offset(86);
        make.width.height.mas_equalTo(52);
    }];
    UIImageView * xyp_rightAvatar = [[UIImageView alloc] init];
    xyp_rightAvatar.layer.cornerRadius = 26;
    xyp_rightAvatar.layer.borderColor = kXYLColorFromRGBA(0xFFFFFF, 0.74).CGColor;
    xyp_rightAvatar.layer.borderWidth = 2;
    xyp_rightAvatar.clipsToBounds = YES;
    xyp_rightAvatar.contentMode = UIViewContentModeScaleAspectFill;
    [xyp_avatarBg addSubview:xyp_rightAvatar];
    [xyp_rightAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(xyp_avatarBg).offset(-68.5);
        make.centerY.width.height.equalTo(xyp_leftAvatar);
    }];
    UILabel * xyp_labOne = [[UILabel alloc] init];
    xyp_labOne.text = kXYLLocalString(@"Private video chat");
    xyp_labOne.font = kXYLGilroyBoldFont(16);
    xyp_labOne.textColor = kXYLColorFromRGB(0x080808);
    [self.xyp_popView addSubview:xyp_labOne];
    [xyp_labOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_popView);
        make.top.equalTo(xyp_avatarBg.mas_bottom).offset(5);
    }];
    
    UILabel * xyp_labTwo = [[UILabel alloc] init];
    xyp_labTwo.font = kXYLGilroyBoldFont(12);
    xyp_labTwo.textColor = kXYLColorFromRGB(0xA09E9E);
    [self.xyp_popView addSubview:xyp_labTwo];
    [xyp_labTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_popView);
        make.top.equalTo(xyp_labOne.mas_bottom).offset(4);
    }];
    
    UIImageView * xyp_giftBg = [[UIImageView alloc] init];
    [XYCUtil xyf_loadMainLanguageImage:xyp_giftBg iconStr:@"xyr_takeher_gift_bgimg"];
    
    [self.xyp_popView addSubview:xyp_giftBg];
    [xyp_giftBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_popView);
        make.top.equalTo(xyp_labTwo.mas_bottom).offset(14);
        make.size.mas_equalTo(CGSizeMake(326, 68));
    }];
    self.xyp_gIcon = [[UIImageView alloc] init];
    self.xyp_gIcon.contentMode = UIViewContentModeScaleAspectFill;
    [xyp_giftBg addSubview:self.xyp_gIcon];
    [self.xyp_gIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(xyp_giftBg);
        make.leading.equalTo(xyp_giftBg).offset(14);
        make.width.height.mas_equalTo(52);
    }];
    
    UILabel * xyp_numLab = [[UILabel alloc] init];
    xyp_numLab.text = @"X1";
    xyp_numLab.textColor = kXYLColorFromRGB(0x080808);
    xyp_numLab.font = kXYLGilroyBoldFont(24);
    [xyp_giftBg addSubview:xyp_numLab];
    [xyp_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_gIcon.mas_trailing).offset(1.5);
        make.top.equalTo(self.xyp_gIcon).offset(3.5);
    }];
    
    UIImageView * xyp_coinIcon = [[UIImageView alloc] init];
    [XYCUtil xyf_loadIconImage:xyp_coinIcon iconStr:@"xyr_top_info_coin_icon"];
    [xyp_giftBg addSubview:xyp_coinIcon];
    [xyp_coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_gIcon).offset(-5.5);
        make.leading.equalTo(xyp_numLab);
        make.width.height.mas_equalTo(12);
    }];
    
    self.xyp_gCoinLab = [[UILabel alloc] init];
    self.xyp_gCoinLab.textColor = kXYLColorFromRGB(0x080808);
    self.xyp_gCoinLab.font = kXYLGilroyBoldFont(12);
    [xyp_giftBg addSubview:self.xyp_gCoinLab];
    [self.xyp_gCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(xyp_coinIcon.mas_trailing).offset(3);
        make.centerY.equalTo(xyp_coinIcon);
    }];
    
    xyp_giftBg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_clickStartPrivate)];
    [xyp_giftBg addGestureRecognizer:tap];
    
    [self.xyp_gIcon sd_setImageWithURL:[NSURL URLWithString:self.xyp_giftModel.dsb_iconImageUrl]];
    self.xyp_gCoinLab.text = [NSString stringWithFormat:@"%ld",self.xyp_giftModel.dsb_giftCoin];
    xyp_labTwo.text = [NSString stringWithFormat:kXYLLocalString(@"First 5 mins for free, then %ld coins/min"),self.xyp_chatCoin];
    [xyp_leftAvatar sd_setImageWithURL:[NSURL URLWithString:self.xyp_userAvatar] placeholderImage:OWLJConvertToolShared.xyf_userPlaceHolder];
    [xyp_rightAvatar sd_setImageWithURL:[NSURL URLWithString:self.xyp_anchorAvatar] placeholderImage:OWLJConvertToolShared.xyf_userPlaceHolder];
}

#pragma mark - 更新带走礼物数据
- (void)xyf_updateTakeGiftData:(OWLMusicGiftInfoModel *)xyp_gModel {
    self.xyp_giftModel = xyp_gModel;
    [self.xyp_gIcon sd_setImageWithURL:[NSURL URLWithString:self.xyp_giftModel.dsb_iconImageUrl]];
    self.xyp_gCoinLab.text = [NSString stringWithFormat:@"%ld",self.xyp_giftModel.dsb_giftCoin];
}

- (void)xyf_clickStartPrivate {
    if (self.xyp_sureTakeHer) {
        self.xyp_sureTakeHer();
    }
    [self xyf_dismissView];
}

#pragma mark - 弹出带走弹窗
- (void)xyf_alertPrivateChat {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_popView.xyp_y = self.xyp_h - 320 - kXYLIPhoneBottomHeight;
    }];
}

#pragma mark - 关闭弹窗
- (void)xyf_dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.xyp_popView.xyp_y = kXYLScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.xyp_dismissBlock) {
            self.xyp_dismissBlock();
        }
    }];
}

- (void)xyf_dismissView {
    [self xyf_dismiss];
}

@end
