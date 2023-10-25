//
//  OWLBGMStreamSettingsInfoView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/30.
//

#import "OWLBGMStreamSettingsInfoView.h"

@interface OWLBGMStreamSettingsInfoView ()

/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 描述
@property (nonatomic, strong) UILabel *xyp_desLabel;
/// 切换按钮
@property (nonatomic, strong) UISwitch *xyp_switch;
/// 类型
@property (nonatomic, assign) OWLMusciStreamSettingType xyp_type;

@end

@implementation OWLBGMStreamSettingsInfoView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithType:(OWLMusciStreamSettingType)type {
    self = [super init];
    if (self) {
        self.xyp_type = type;
        [self xyf_setupData];
        [self xyf_setupView];
        [self xyf_setupNotification];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupData {
    switch (self.xyp_type) {
        case OWLMusciStreamSettingType_InApp:
            self.xyp_titleLabel.text = kXYLLocalString(@"In-App floating window");
            self.xyp_desLabel.text = kXYLLocalString(@"Once disabled, clicking 'x' will directly exit the Live room. However, the floating window will remain active when navigating other pages.");
            [self.xyp_switch setOn:OWLMusicInsideManagerShared.xyp_isOpenWindowInApp];
            break;
        case OWLMusciStreamSettingType_OutApp:
            self.xyp_titleLabel.text = kXYLLocalString(@"Outside-App floating window");
            self.xyp_desLabel.text = kXYLLocalString(@"Once disabled, the stream will not be played in floating window over other apps.");
            [self.xyp_switch setOn:OWLMusicInsideManagerShared.xyp_isOpenWindowOutApp];
            break;
    }
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(16);
    }];
    
    [self addSubview:self.xyp_desLabel];
    [self.xyp_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_titleLabel);
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(4);
        make.trailing.equalTo(self).offset(-93);
    }];
    
    [self addSubview:self.xyp_switch];
    [self.xyp_switch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-16);
        make.top.equalTo(self).offset(13);
    }];
}

- (void)xyf_setupNotification {
    [self xyf_observeNotification:xyl_module_update_window_inapp_isOpen];
    [self xyf_observeNotification:xyl_module_update_window_outapp_isOpen];
}

#pragma mark - Action
- (void)xyf_switchChangeAction:(UISwitch *)sender {
    switch (self.xyp_type) {
        case OWLMusciStreamSettingType_InApp:
            [OWLJConvertToolShared xyf_changeInAppWindowState:[sender isOn] isSDKChange:YES];
            break;
        case OWLMusciStreamSettingType_OutApp:
            [OWLJConvertToolShared xyf_changeOutAppWindowState:[sender isOn] isSDKChange:YES];
            break;
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_module_update_window_inapp_isOpen]) {
        [self xyf_changeSwitchStateByNotification];
    } else if ([notification.name isEqualToString:xyl_module_update_window_outapp_isOpen]) {
        [self xyf_changeSwitchStateByNotification];
    }
}

- (void)xyf_changeSwitchStateByNotification {
    switch (self.xyp_type) {
        case OWLMusciStreamSettingType_InApp:
            [self.xyp_switch setOn:OWLMusicInsideManagerShared.xyp_isOpenWindowInApp];
            break;
        case OWLMusciStreamSettingType_OutApp:
            [self.xyp_switch setOn:OWLMusicInsideManagerShared.xyp_isOpenWindowOutApp];
            break;
    }
}

#pragma mark - Lazy
- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.font = kXYLGilroyBoldFont(14);
        _xyp_titleLabel.textColor = UIColor.whiteColor;
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_desLabel {
    if (!_xyp_desLabel) {
        _xyp_desLabel = [[UILabel alloc] init];
        _xyp_desLabel.font = kXYLGilroyMediumFont(11);
        _xyp_desLabel.textColor = kXYLColorFromRGB(0x545456);
        _xyp_desLabel.numberOfLines = 0;
    }
    return _xyp_desLabel;
}

- (UISwitch *)xyp_switch {
    if(!_xyp_switch) {
        _xyp_switch = [UISwitch new];
        _xyp_switch.onTintColor = kXYLColorFromRGB(0xE94179);
        _xyp_switch.layer.cornerRadius = _xyp_switch.bounds.size.height / 2.0;
        _xyp_switch.layer.masksToBounds = YES;
        _xyp_switch.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [_xyp_switch addTarget:self action:@selector(xyf_switchChangeAction:)forControlEvents:UIControlEventValueChanged];
    }
    return _xyp_switch;
}

@end
