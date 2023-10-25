//
//  OWLMusicJoinFanAlertView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/9.
//

#import "OWLMusicJoinFanAlertView.h"

@interface OWLMusicJoinFanAlertView ()

#pragma mark - Views
/// 遮罩
@property (nonatomic, strong) UIControl *xyp_overyView;
/// 背景
@property (nonatomic, strong) UIView *xyp_contentView;
/// 背景视图
@property (nonatomic, strong) UIImageView *xyp_bgIV;
/// icon
@property (nonatomic, strong) UIImageView *xyp_iconIV;
/// 金币按钮
@property (nonatomic, strong) UIButton *xyp_coinButton;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 副标题
@property (nonatomic, strong) UILabel *xyp_subtitleLabel;
/// 子容器
@property (nonatomic, strong) UIView *xyp_subView;
/// 图标
@property (nonatomic, strong) UIImageView *xyp_medalIV;
/// 图标描述
@property (nonatomic, strong) UILabel *xyp_medalDesLabel;
/// 消息
@property (nonatomic, strong) UIImageView *xyp_msgIV;
/// 永久
@property (nonatomic, strong) UIImageView *xyp_foreverIV;
/// 消息描述
@property (nonatomic, strong) UILabel *xyp_msgDesLabel;
/// 按钮
@property (nonatomic, strong) UIButton *xyp_buyButton;

#pragma mark - Layout
/// 总高度
@property (nonatomic, assign) CGFloat xyp_totalHeight;

#pragma mark - Model
/// 铁粉模型
@property (nonatomic, strong) OWLMusicFanInfoModel *xyp_fanModel;
/// 主播ID
@property (nonatomic, assign) NSInteger xyp_anchorID;
/// 铁粉内购模型
@property (nonatomic, strong) OWLMusicProductModel *xyp_productModel;
/// 苹果内购模型
@property (nonatomic, strong) OWLMusicPayModel *xyp_configModel;

@end

@implementation OWLMusicJoinFanAlertView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

+ (instancetype)xyf_showJoinFanAlertView:(UIView *)targetView
                                fanModel:(OWLMusicFanInfoModel *)fanModel
                                anchorID:(NSInteger)anchorID {
    OWLMusicJoinFanAlertView *view = [[OWLMusicJoinFanAlertView alloc] initWithModel:fanModel anchorID:anchorID];
    [view xyf_showInView:targetView];
    
    return view;
}

- (instancetype)initWithModel:(OWLMusicFanInfoModel *)model
                     anchorID:(NSInteger)anchorID {
    self = [super init];
    if (self) {
        self.xyp_fanModel = model;
        self.xyp_anchorID = anchorID;
        self.xyp_productModel = OWLJConvertToolShared.xyf_getFanProductModel;
        self.xyp_configModel = OWLJConvertToolShared.xyf_getPayConfigModel;
        [self xyf_observeNotification:xyl_module_buy_fan_success];
        [self xyf_observeNotification:xyl_module_buy_svip_success];
        [self xyf_setupLayout];
        [self xyf_setupView];
        [self xyf_updateInfo:model];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_totalHeight = 351;
    self.frame = CGRectMake(0, kXYLScreenHeight, kXYLScreenWidth, self.xyp_totalHeight);
    [XYCUtil xyf_clickRadius:6 alertView:self];
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_bgIV];
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_iconIV];
    [self.xyp_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(105);
        make.centerX.equalTo(self.xyp_bgIV);
        make.top.equalTo(self.xyp_bgIV).offset(6);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_coinButton];
    [self.xyp_coinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(76);
        make.top.equalTo(self.xyp_bgIV).offset(10);
        make.trailing.equalTo(self.xyp_bgIV).offset(-10);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgIV);
        make.top.equalTo(self.xyp_iconIV.mas_bottom).offset(3);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_subtitleLabel];
    [self.xyp_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.xyp_bgIV);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_subView];
    [self.xyp_subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_subtitleLabel.mas_bottom).offset(11);
        make.leading.equalTo(self.xyp_bgIV).offset(20);
        make.trailing.equalTo(self.xyp_bgIV).offset(-20);
        make.height.mas_equalTo(84);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_buyButton];
    [self.xyp_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.leading.equalTo(self.xyp_bgIV).offset(58);
        make.trailing.equalTo(self.xyp_bgIV).offset(-58);
        make.top.equalTo(self.xyp_subView.mas_bottom).offset(20);
    }];
}

#pragma mark - 更新
/// 更新信息
- (void)xyf_updateInfo:(OWLMusicFanInfoModel *)fanModel {
    if (fanModel.dsb_isGainedFan) {
        self.xyp_medalDesLabel.text = kXYLLocalString(@"The medal already exists");
        self.xyp_medalDesLabel.textColor = kXYLColorFromRGBA(0x080808, 0.3);
    } else {
        self.xyp_medalDesLabel.text = kXYLLocalString(@"Special medal");
        self.xyp_medalDesLabel.textColor = kXYLColorFromRGBA(0x080808, 1);
    }
    [self.xyp_medalIV sd_setImageWithURL:[NSURL URLWithString:fanModel.dsb_fanIconUrl]];
}

#pragma mark - 动画
/// 展示
- (void)xyf_showInView:(UIView *)superView {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight - self.xyp_totalHeight;
    [superView addSubview:self.xyp_overyView];
    [superView addSubview:self];
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    }];
}

/// 消失
- (void)xyf_dismiss {
    CGRect rect = self.frame;
    rect.origin.y = kXYLScreenHeight;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.xyp_overyView removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)xyf_overyViewAction {
    [self xyf_dismiss];
}

- (void)xyf_clickCoinAction {
    OWLMusicRoomTotalModel *currentModel = OWLMusicInsideManagerShared.xyp_currentModel;
    [OWLJConvertToolShared xyf_enterSingleChatVCWithAccountID:currentModel.xyf_getOwnerID nickname:currentModel.xyp_tempModel.xyp_nickname avatar:@"" displayID:currentModel.xyp_detailModel.dsb_ownerDisplayAccountID isAnchor:YES];
}

- (void)xyf_clickBuyAction {
    [OWLMusicTongJiTool xyf_thinkingFromWithName:XYLThinkingEventClickBuyFreeMsg];
    OWLMusicPayOtherInfoModel *otherModel = [[OWLMusicPayOtherInfoModel alloc] init];
    otherModel.xyp_payType = XYLOutDataSourcePayType_PGFan;
    otherModel.xyp_hostID = self.xyp_anchorID;
    [OWLBGMModuleManagerShared.delegate xyf_outsideModulePay: self.xyp_productModel configModel:self.xyp_configModel otherInfo:otherModel completion:^(BOOL success) {
        
    }];
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_buy_fan_success]) {
        NSDictionary *dic = notification.object;
        NSInteger accountId = [[dic objectForKey:kXYLNotificationAccountIDKey] integerValue];
        NSDictionary *fanDic = [dic objectForKey:kXYLNotificationFanInfoKey];
        if (accountId == [OWLMusicInsideManagerShared.xyp_currentModel xyf_getOwnerID]) {
            OWLMusicEventLabelModel *model = [[OWLMusicEventLabelModel alloc] initWithDictionary:fanDic];
            OWLMusicFanInfoModel *fanModel = [[OWLMusicFanInfoModel alloc] init];
            fanModel.dsb_isFan = YES;
            fanModel.dsb_isGainedFan = YES;
            fanModel.dsb_fanIconUrl = model.dsb_labelUrl;
            OWLMusicInsideManagerShared.xyp_currentModel.xyp_detailModel.dsb_fanInfo = fanModel;
            [self xyf_dismiss];
        }
    } else if ([notification.name isEqualToString:xyl_module_buy_svip_success]) {
        [self xyf_dismiss];
    }
}

#pragma mark - Lazy
- (UIControl *)xyp_overyView {
    if (!_xyp_overyView) {
        _xyp_overyView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
        _xyp_overyView.backgroundColor = UIColor.clearColor;
        [_xyp_overyView addTarget:self action:@selector(xyf_overyViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_overyView;
}

- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bgIV iconStr:@"xyr_fan_alert_bg_image"];
        _xyp_bgIV.userInteractionEnabled = YES;
    }
    return _xyp_bgIV;
}

- (UIImageView *)xyp_iconIV {
    if (!_xyp_iconIV) {
        _xyp_iconIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_iconIV iconStr:@"xyr_fan_alert_icon"];
    }
    return _xyp_iconIV;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.font = kXYLGilroyBoldFont(16);
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_titleLabel.text = kXYLLocalString(@"Get closer to her");
        _xyp_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_subtitleLabel {
    if (!_xyp_subtitleLabel) {
        _xyp_subtitleLabel = [[UILabel alloc] init];
        _xyp_subtitleLabel.font = kXYLGilroyBoldFont(12);
        _xyp_subtitleLabel.textColor = kXYLColorFromRGB(0xE86F88);
        _xyp_subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_subtitleLabel.text = kXYLLocalString(@"After buying,  you will get permanent benefits below:");
    }
    return _xyp_subtitleLabel;
}

- (UIView *)xyp_subView {
    if (!_xyp_subView) {
        _xyp_subView = [[UIView alloc] init];
        _xyp_subView.backgroundColor = kXYLColorFromRGB(0xFFFBF5);
        _xyp_subView.layer.cornerRadius = 6;
        _xyp_subView.clipsToBounds = YES;
        
        CGFloat margin = (kXYLScreenWidth - 40) / 4.0;
        [_xyp_subView addSubview:self.xyp_medalIV];
        [self.xyp_medalIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_xyp_subView).offset(-margin);
            make.top.equalTo(_xyp_subView).offset(16);
            make.size.mas_equalTo(CGSizeMake(76, 28));
        }];
        
        [_xyp_subView addSubview:self.xyp_medalDesLabel];
        [self.xyp_medalDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_xyp_subView).offset(-16);
            make.centerX.equalTo(_xyp_subView).offset(-margin);
        }];
        
        [_xyp_subView addSubview:self.xyp_msgIV];
        [self.xyp_msgIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(22.5);
            make.width.mas_equalTo(30);
            make.top.equalTo(_xyp_subView).offset(19);
            make.centerX.mas_equalTo(_xyp_subView).offset(margin);
        }];
        
        [_xyp_subView addSubview:self.xyp_foreverIV];
        [self.xyp_foreverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(34);
            make.leading.equalTo(self.xyp_msgIV).offset(18);
            make.bottom.equalTo(self.xyp_msgIV).offset(-19);
        }];
        
        [_xyp_subView addSubview:self.xyp_msgDesLabel];
        [self.xyp_msgDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_xyp_subView).offset(-16);
            make.centerX.equalTo(_xyp_subView).offset(margin);
        }];
    }
    return _xyp_subView;
}

- (UIImageView *)xyp_medalIV {
    if (!_xyp_medalIV) {
        _xyp_medalIV = [[UIImageView alloc] init];
        _xyp_medalIV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _xyp_medalIV;
}

- (UILabel *)xyp_medalDesLabel {
    if (!_xyp_medalDesLabel) {
        _xyp_medalDesLabel = [[UILabel alloc] init];
        _xyp_medalDesLabel.font = kXYLGilroyBoldFont(11);
        _xyp_medalDesLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_medalDesLabel.text = kXYLLocalString(@"Special medal");
    }
    return _xyp_medalDesLabel;
}

- (UIImageView *)xyp_msgIV {
    if (!_xyp_msgIV) {
        _xyp_msgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_msgIV iconStr:@"xyr_fan_alert_msg_icon"];
    }
    return _xyp_msgIV;
}

- (UILabel *)xyp_msgDesLabel {
    if (!_xyp_msgDesLabel) {
        _xyp_msgDesLabel = [[UILabel alloc] init];
        _xyp_msgDesLabel.font = kXYLGilroyBoldFont(11);
        _xyp_msgDesLabel.textColor = kXYLColorFromRGB(0x080808);
        _xyp_msgDesLabel.text = kXYLLocalString(@"Free messages");
    }
    return _xyp_msgDesLabel;
}

- (UIButton *)xyp_buyButton {
    if (!_xyp_buyButton) {
        _xyp_buyButton = [[UIButton alloc] init];
        [_xyp_buyButton addTarget:self action:@selector(xyf_clickBuyAction) forControlEvents:UIControlEventTouchUpInside];
        [_xyp_buyButton setBackgroundImage:[UIImage imageWithGradient:@[kXYLColorFromRGB(0xFB5F7C), kXYLColorFromRGB(0xFF32A1)] size:CGSizeMake(kXYLScreenWidth - 58 * 2, 55) direction:UIImageGradientDirectionVertical] forState:UIControlStateNormal];
        _xyp_buyButton.titleLabel.font = kXYLGilroyBoldFont(16);
        [_xyp_buyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        NSString *priceStr = [NSString stringWithFormat:@"%@",[NSString xyf_decimalString:self.xyp_productModel.dsb_priceUSD maxFloat:2]];
        if(OWLJConvertToolShared.xyf_isRTL){
            NSString * str = @"دولار";
            NSString * str1 = @"إشتري/";
            [_xyp_buyButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",str1,priceStr,str] forState:UIControlStateNormal];
        }else{
            [_xyp_buyButton setTitle:[NSString stringWithFormat:@"Buy/$%@",priceStr] forState:UIControlStateNormal];
        }
        _xyp_buyButton.layer.cornerRadius = 55 / 2.0;
        _xyp_buyButton.clipsToBounds = YES;
    }
    return _xyp_buyButton;
}

- (UIImageView *)xyp_foreverIV {
    if (!_xyp_foreverIV) {
        _xyp_foreverIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadMainLanguageImage:_xyp_foreverIV iconStr:@"xyr_fan_alert_forever_icon"];
    }
    return _xyp_foreverIV;
}

- (UIButton *)xyp_coinButton {
    if (!_xyp_coinButton) {
        _xyp_coinButton = [[UIButton alloc] init];
        [_xyp_coinButton setImage:[XYCUtil xyf_getIconWithNameInMainLanguage:@"xyr_fan_alert_usercoins_icon"] forState:UIControlStateNormal];
        [_xyp_coinButton addTarget:self action:@selector(xyf_clickCoinAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_coinButton;
}

@end
