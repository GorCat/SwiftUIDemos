//
//  OWLMusicRandomTableTipView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLMusicRandomTableTipView.h"

@interface OWLMusicRandomTableTipView ()

/// 标题
@property (nonatomic, strong) UILabel *xyp_titleLabel;
/// 文案
@property (nonatomic, strong) UILabel *xyp_tipLabel;

@end

@implementation OWLMusicRandomTableTipView

- (void)dealloc {
    [self xyf_unobserveAllNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_observeNotification:xyl_live_clear_room_info];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.backgroundColor = kXYLColorFromRGBA(0x000000, 0.7);
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.xyp_titleLabel];
    [self.xyp_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.xyp_tipLabel];
    [self.xyp_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self.xyp_titleLabel.mas_bottom).offset(5);
    }];
}

#pragma mark - Public
- (void)xyf_updateResult:(NSString *)result {
    self.xyp_tipLabel.text = result;
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_live_clear_room_info]) {
        [self removeFromSuperview];
    }
}

#pragma mark - Lazy
- (UILabel *)xyp_titleLabel {
    if (!_xyp_titleLabel) {
        _xyp_titleLabel = [[UILabel alloc] init];
        _xyp_titleLabel.text = kXYLLocalString(@"The result is");
        _xyp_titleLabel.font = kXYLGilroyBoldFont(14);
        _xyp_titleLabel.textColor = UIColor.whiteColor;
    }
    return _xyp_titleLabel;
}

- (UILabel *)xyp_tipLabel {
    if (!_xyp_tipLabel) {
        _xyp_tipLabel = [[UILabel alloc] init];
        _xyp_tipLabel.numberOfLines = 2;
        _xyp_tipLabel.font = kXYLGilroyBoldFont(14);
        _xyp_tipLabel.textColor = kXYLColorFromRGB(0xF7FFBB);
        _xyp_tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _xyp_tipLabel;
}

@end
