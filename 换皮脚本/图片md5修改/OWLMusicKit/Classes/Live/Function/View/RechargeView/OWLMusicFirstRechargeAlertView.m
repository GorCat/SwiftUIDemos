//
//  OWLMusicFirstRechargeAlertView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import "OWLMusicFirstRechargeAlertView.h"
#import "OWLMusicFirstRechargeDetailView.h"

@interface OWLMusicFirstRechargeAlertView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgIV;
/// 金币详情
@property (nonatomic, strong) OWLMusicFirstRechargeDetailView *xyp_coinView;
/// vip详情
@property (nonatomic, strong) OWLMusicFirstRechargeDetailView *xyp_vipView;
/// 按钮
@property (nonatomic, strong) UIButton *xyp_rechargeButton;

#pragma mark - Data
/// 充值模型
@property (nonatomic, strong) OWLMusicProductModel *xyp_productModel;

#pragma mark - Block
/// 弹窗消失的回调
@property (nonatomic, copy, nullable) XYLVoidBlock xyp_dismissBlock;

@end

@implementation OWLMusicFirstRechargeAlertView

+ (instancetype)xyf_showDiscountAlertView:(UIView *)targetView
                                  bgColor:(nullable UIColor *)bgColor
                             productModel:(OWLMusicProductModel *)productModel
                             dismissBlock:(XYLVoidBlock)dismissBlock {
    OWLMusicFirstRechargeAlertView *view = [[OWLMusicFirstRechargeAlertView alloc] initWithModel:productModel];
    if (bgColor) {
        view.backgroundColor = bgColor;
    }
    [view xyf_showInView:targetView];
    view.xyp_dismissBlock = dismissBlock;
    return view;
}

- (instancetype)initWithModel:(OWLMusicProductModel *)model {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        self.xyp_productModel = model;
        [self xyf_setupView];
        [self xyf_setupNotification];
        [self xyf_setupTap];
    }
    return self;
}

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgIV];
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(460);
        make.width.mas_equalTo(331);
        make.center.equalTo(self);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_coinView];
    [self.xyp_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_bgIV).offset(29);
        make.height.mas_equalTo(106);
        make.width.mas_equalTo(130);
        make.bottom.equalTo(self.xyp_bgIV).offset(-110);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_vipView];
    [self.xyp_vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.xyp_bgIV).offset(-29);
        make.height.mas_equalTo(106);
        make.width.mas_equalTo(130);
        make.bottom.equalTo(self.xyp_bgIV).offset(-110);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_rechargeButton];
    [self.xyp_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_bgIV).offset(30);
        make.trailing.equalTo(self.xyp_bgIV).offset(-30);
        make.height.mas_equalTo(53);
        make.bottom.equalTo(self.xyp_bgIV).offset(-39);
    }];
    
    NSString *priceStr = [NSString stringWithFormat:@"$ %@",[NSString xyf_decimalString:self.xyp_productModel.dsb_priceUSD maxFloat:2]];
    [self.xyp_rechargeButton setTitle:priceStr forState:UIControlStateNormal];
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_module_recharge_success];
}

- (void)xyf_setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_clickViewAction)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_clickBGViewAction)];
    [self.xyp_bgIV addGestureRecognizer:tap1];
}

#pragma mark - 动画
- (void)xyf_showInView:(UIView *)view {
    [view addSubview:self];
    self.xyp_bgIV.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_bgIV.transform = CGAffineTransformIdentity;
    }];
}

- (void)xyf_dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_bgIV.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.xyp_bgIV.alpha = 0;
    } completion:^(BOOL finished) {
        !self.xyp_dismissBlock?:self.xyp_dismissBlock();
        self.xyp_bgIV.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)xyf_rechargeButtonAction {
    OWLMusicPayModel *configModel = OWLJConvertToolShared.xyf_getPayConfigModel;
    OWLMusicPayOtherInfoModel *otherModel = [[OWLMusicPayOtherInfoModel alloc] init];
    otherModel.xyp_payType = XYLOutDataSourcePayType_PGCoins;
    [OWLBGMModuleManagerShared.delegate xyf_outsideModulePay:self.xyp_productModel configModel:configModel otherInfo:otherModel completion:^(BOOL success) {
        
    }];
}

- (void)xyf_clickViewAction {
    [self xyf_dismiss];
}

- (void)xyf_clickBGViewAction {
    
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_recharge_success]) {
        [self xyf_dismiss];
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bgIV iconStr:@"xyr_discount_bg_image"];
        _xyp_bgIV.userInteractionEnabled = YES;
    }
    return _xyp_bgIV;
}

- (OWLMusicFirstRechargeDetailView *)xyp_coinView {
    if (!_xyp_coinView) {
        _xyp_coinView = [[OWLMusicFirstRechargeDetailView alloc] initWithType:OWLMusicFirstRechargeDetailType_Coin productModel:self.xyp_productModel];
    }
    return _xyp_coinView;
}

- (OWLMusicFirstRechargeDetailView *)xyp_vipView {
    if (!_xyp_vipView) {
        _xyp_vipView = [[OWLMusicFirstRechargeDetailView alloc] initWithType:OWLMusicFirstRechargeDetailType_Vip productModel:self.xyp_productModel];
    }
    return _xyp_vipView;
}

- (UIButton *)xyp_rechargeButton {
    if (!_xyp_rechargeButton) {
        _xyp_rechargeButton = [[UIButton alloc] init];
        [_xyp_rechargeButton setBackgroundImage:[XYCUtil xyf_getIconWithName:@"xyr_discount_recharge_image"] forState:UIControlStateNormal];
        [_xyp_rechargeButton addTarget:self action:@selector(xyf_rechargeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _xyp_rechargeButton.titleLabel.font = kXYLGilroyBoldFont(16);
        [_xyp_rechargeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _xyp_rechargeButton;
}

@end
