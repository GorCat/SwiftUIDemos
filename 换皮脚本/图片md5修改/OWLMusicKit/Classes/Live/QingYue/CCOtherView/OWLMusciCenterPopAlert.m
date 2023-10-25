//
//  OWLMusciCenterPopAlert.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/8.
//

#import "OWLMusciCenterPopAlert.h"

@interface OWLMusciCenterPopAlert()

@property (nonatomic, strong) UIView * xyp_popView;

@property (nonatomic, strong) UILabel * xyp_msgLab;

@property (nonatomic, strong) UIButton * xyp_canelBtn;

@property (nonatomic, strong) UIButton * xyp_sureBtn;

@property (nonatomic, assign) NSInteger xyp_anchorID;

@property (nonatomic, assign) NSInteger xyp_type;

@end

@implementation OWLMusciCenterPopAlert

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

/// 初始化
/// @param type 类型
/// @param anchorID 主播ID
/// @param targetView 父视图
/// @param moreAction 点击更多回调
+ (instancetype)xyf_showCenterPopAlert:(NSInteger)type
                              anchorID:(NSInteger)anchorID
                            targetView:(UIView *)targetView
                            moreAction:(void(^)(void))moreAction {
    OWLMusciCenterPopAlert * xyp_alert = [[OWLMusciCenterPopAlert alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    xyp_alert.xyp_anchorID = anchorID;
    xyp_alert.xyp_clickedSureBtn = ^{
        if (moreAction) {
            moreAction();
        }
    };
    [targetView addSubview:xyp_alert];
    [xyp_alert xyf_showAlertWithType:type];
    xyp_alert.xyp_anchorID = anchorID;
    return xyp_alert;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self xyf_setupUI];
        [self xyf_observeNotification:xyl_live_room_resume];
    }
    return self;
}

- (UIView *)xyp_popView {
    if (!_xyp_popView) {
        _xyp_popView = [[UIView alloc] initWithFrame:CGRectMake((kXYLScreenWidth - 287) / 2, -253, 287, 253)];
        _xyp_popView.backgroundColor = UIColor.clearColor;
    }
    return _xyp_popView;
}

- (UILabel *)xyp_msgLab {
    if (!_xyp_msgLab) {
        _xyp_msgLab = [[UILabel alloc] init];
        _xyp_msgLab.textColor = kXYLColorFromRGB(0x080808);
        _xyp_msgLab.font = kXYLGilroyBoldFont(16);
        _xyp_msgLab.numberOfLines = 0;
        _xyp_msgLab.lineBreakMode = NSLineBreakByWordWrapping;
        _xyp_msgLab.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_msgLab;
}

- (UIButton *)xyp_canelBtn {
    if (!_xyp_canelBtn) {
        _xyp_canelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_canelBtn setTitle:kXYLLocalString(@"Wait") forState:UIControlStateNormal];
        [_xyp_canelBtn setTitleColor:kXYLColorFromRGB(0x9B999A) forState:UIControlStateNormal];
        _xyp_canelBtn.titleLabel.font = kXYLGilroyBoldFont(16);
        _xyp_canelBtn.backgroundColor = kXYLColorFromRGB(0xF7F5F6);
        _xyp_canelBtn.layer.cornerRadius = 22;
        _xyp_canelBtn.layer.masksToBounds = YES;
        [_xyp_canelBtn addTarget:self action:@selector(xyf_waitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_canelBtn;
}

- (UIButton *)xyp_sureBtn {
    if (!_xyp_sureBtn) {
        _xyp_sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xyp_sureBtn setTitle:kXYLLocalString(@"More hosts") forState:UIControlStateNormal];
        [_xyp_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _xyp_sureBtn.titleLabel.font = kXYLGilroyBoldFont(16);
        _xyp_sureBtn.backgroundColor = kXYLColorFromRGB(0xEA417F);
        _xyp_sureBtn.layer.cornerRadius = 22;
        _xyp_sureBtn.layer.masksToBounds = YES;
        [_xyp_sureBtn addTarget:self action:@selector(xyf_sureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_sureBtn;
}

#pragma mark - UI

- (void)xyf_setupUI {
    [self addSubview:self.xyp_popView];
    UIView * xyp_view = [[UIView alloc] initWithFrame:CGRectMake(44, -205, kXYLScreenWidth - 88, 205)];
    xyp_view.layer.cornerRadius = 20;
    xyp_view.layer.masksToBounds = YES;
    xyp_view.backgroundColor = UIColor.whiteColor;
    [self.xyp_popView addSubview:xyp_view];
    [xyp_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.width.equalTo(self.xyp_popView);
        make.top.equalTo(self.xyp_popView).offset(48);
    }];
    UIImageView * xyp_iconImg = [[UIImageView alloc] init];
    [XYCUtil xyf_loadIconImage:xyp_iconImg iconStr:@"xyr_other_engaged_alert_icon"];
    [self.xyp_popView addSubview:xyp_iconImg];
    [xyp_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self.xyp_popView);
        make.width.height.mas_equalTo(125);
    }];
    [xyp_view addSubview:self.xyp_msgLab];
    [self.xyp_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(xyp_view).offset(16);
        make.trailing.equalTo(xyp_view).offset(-16);
        make.top.equalTo(xyp_view).offset(85);
    }];
    
    [self.xyp_popView addSubview:self.xyp_canelBtn];
    [self.xyp_canelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_popView).offset(-15);
        make.leading.equalTo(self.xyp_popView).offset(18.5);
        make.size.mas_equalTo(CGSizeMake(91, 44));
    }];
    
    [self.xyp_popView addSubview:self.xyp_sureBtn];
    [self.xyp_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.xyp_canelBtn);
        make.trailing.equalTo(self.xyp_popView).offset(-18.5);
        make.leading.equalTo(self.xyp_canelBtn.mas_trailing).offset(18);
    }];
}

- (void)xyf_sureButtonClicked {
    if (self.xyp_clickedSureBtn) {
        self.xyp_clickedSureBtn();
    }
}

#pragma mark - 关闭弹窗
- (void)xyf_dismiss {
    kXYLWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xyp_popView.xyp_y = -253;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)xyf_waitAction {
    [self xyf_dismiss];
    /// 点击wait也需要刷新首页
    if (self.xyp_type == 1) {
        OWLMusicInsideManagerShared.xyp_isNeedRefreshHomeList = YES;
    }
}

#pragma mark - 显示弹窗
- (void)xyf_showAlertWithType:(NSInteger) xyp_type {
    self.xyp_type = xyp_type;
    switch (xyp_type) {
        case 1:
        {
            self.xyp_msgLab.text = kXYLLocalString(@"This host is in a private call. Please come back later.");
        }
            break;
        case 2:
        {
            self.xyp_msgLab.text = kXYLLocalString(@"This host is offline. Chat with other online hosts.");
            self.xyp_canelBtn.hidden = YES;
            [self.xyp_sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.xyp_popView).offset(-15);
                make.centerX.equalTo(self.xyp_popView);
                make.size.mas_equalTo(CGSizeMake(187, 44));
            }];
        }
            break;
            
        default:
            break;
    }
    kXYLWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.xyp_popView.xyp_y = (kXYLScreenHeight - 253) / 2 - (kXYLScreenHeight / 10);
    }];
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_live_room_resume]) {
        NSNumber *num = notification.object;
        NSInteger accountId = num.integerValue;
        if (accountId == self.xyp_anchorID && (self.xyp_type == 1 || self.xyp_type == 2)) {
            [self xyf_dismiss];
        }
    }
}

@end
