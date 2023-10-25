//
//  OWLMusicRiskyRoomView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/4.
//

#import "OWLMusicRiskyRoomView.h"

@interface OWLMusicRiskyRoomView ()

/// 背景
@property (nonatomic, strong) UIView *xyp_bgView;
/// 图片
@property (nonatomic, strong) UIImageView *xyp_alertIV;
/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 提示
@property (nonatomic, strong) UILabel *xyp_tipLabel;
/// 按钮
@property (nonatomic, strong) UIButton *xyp_okButton;

@end

@implementation OWLMusicRiskyRoomView

+ (instancetype)xyf_showRiskyRoomView {
    OWLMusicRiskyRoomView *view = [[OWLMusicRiskyRoomView alloc] initWithFrame:CGRectZero];
    [view xyf_showInView];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    
    [self addSubview:self.xyp_bgView];
    [self.xyp_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(246);
        make.width.mas_equalTo(311);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_alertIV];
    [self.xyp_alertIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgView);
        make.height.mas_equalTo(79.5);
        make.width.mas_equalTo(152);
        make.top.equalTo(self.xyp_bgView).offset(22);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgView);
        make.top.equalTo(self.xyp_alertIV.mas_bottom).offset(17.5);
        make.height.mas_equalTo(22);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_tipLabel];
    [self.xyp_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.xyp_bgView);
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(17);
    }];
    
    [self.xyp_bgView addSubview:self.xyp_okButton];
    [self.xyp_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.xyp_bgView);
        make.height.mas_equalTo(52);
    }];
    
}

#pragma mark - Public
- (void)xyf_showInView {
    [[OWLJConvertToolShared xyf_keyWindow] addSubview:self];
    self.xyp_bgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_bgView.transform = CGAffineTransformIdentity;
    }];
}

- (void)xyf_dismiss {
    [UIView animateWithDuration:0.15 animations:^{
        self.xyp_bgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.xyp_bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.xyp_bgView.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)xyf_okButtonAction {
    [self xyf_dismiss];
}

#pragma mark - Lazy
- (UIView *)xyp_bgView {
    if (!_xyp_bgView) {
        _xyp_bgView = [[UIView alloc] init];
        _xyp_bgView.backgroundColor = UIColor.whiteColor;
        _xyp_bgView.layer.cornerRadius = 40;
        _xyp_bgView.clipsToBounds = YES;
    }
    return _xyp_bgView;
}

- (UIImageView *)xyp_alertIV {
    if (!_xyp_alertIV) {
        _xyp_alertIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_alertIV iconStr:@"xyr_alert_yellow_image"];
    }
    return _xyp_alertIV;
}

- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.text = kXYLLocalString(@"Official detection");
        _xyp_titleLabel.font = kXYLGilroyBoldFont(18);
        _xyp_titleLabel.textColor = kXYLColorFromRGB(0xF13E3F);
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_tipLabel {
    if (!_xyp_tipLabel) {
        _xyp_tipLabel = [[UILabel alloc] init];
        _xyp_tipLabel.text = kXYLLocalString(@"Risky content in this room");
        _xyp_tipLabel.font = kXYLGilroyBoldFont(14);
        _xyp_tipLabel.textColor = kXYLColorFromRGB(0x333333);
    }
    return _xyp_tipLabel;
}

- (UIButton *)xyp_okButton {
    if (!_xyp_okButton) {
        _xyp_okButton = [[UIButton alloc] init];
        [_xyp_okButton setTitle:kXYLLocalString(@"OK") forState:UIControlStateNormal];
        _xyp_okButton.backgroundColor = kXYLColorFromRGB(0xEA417F);
        _xyp_okButton.titleLabel.font = kXYLGilroyBoldFont(16);
        [_xyp_okButton addTarget:self action:@selector(xyf_okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_okButton;
}

@end
