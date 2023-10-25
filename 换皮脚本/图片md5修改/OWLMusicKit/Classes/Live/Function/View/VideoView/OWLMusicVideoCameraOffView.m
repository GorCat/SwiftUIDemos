//
//  OWLMusicVideoCameraOffView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/28.
//

#import "OWLMusicVideoCameraOffView.h"

@interface OWLMusicVideoCameraOffView ()

/// 悬浮窗头像
@property (nonatomic, strong) UIImageView *xyp_floatAvatarIV;
/// 悬浮窗提示
@property (nonatomic, strong) UILabel *xyp_floatTipLabel;
/// 页面禁摄像头图片
@property (nonatomic, strong) UIImageView *xyp_pageMuteIV;
/// 页面提示
@property (nonatomic, strong) UILabel *xyp_pageTipLabel;
/// 是否是自己主播
@property (nonatomic, assign) BOOL xyp_isMineAnchor;
/// 页面提示centerY间距
@property (nonatomic, assign) CGFloat xyp_pageTipCenterYMargin;

@end

@implementation OWLMusicVideoCameraOffView

- (instancetype)initWithIsMine:(BOOL)isMine {
    self = [super init];
    if (self) {
        self.xyp_isMineAnchor = isMine;
        [self xyf_setupLayout];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupLayout {
    self.xyp_pageTipCenterYMargin = [self xyf_getTipCenterYMarginWhenFullScreen];
}

- (void)xyf_setupView {
    [self addSubview:self.xyp_floatAvatarIV];
    [self.xyp_floatAvatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(54);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-10);
    }];
    
    [self addSubview:self.xyp_floatTipLabel];
    [self.xyp_floatTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyp_floatAvatarIV.mas_bottom).offset(7);
        make.centerX.equalTo(self);
    }];
    
    CGFloat leftRightMargin = [self xyf_getPageTipLabelLeftRightMargin:NO];
    CGFloat centerYMargin = [self xyf_getPageTipCenterYMargin:NO];
    [self xyf_updatePageTipLabel:NO];
    [self addSubview:self.xyp_pageTipLabel];
    [self.xyp_pageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(leftRightMargin);
        make.trailing.equalTo(self).offset(-leftRightMargin);
        make.centerY.equalTo(self).offset(centerYMargin);
    }];

    CGFloat pageMuteWH = [self xyf_getCameraOffIVWH:NO];
    [self addSubview:self.xyp_pageMuteIV];
    [self.xyp_pageMuteIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.xyp_pageTipLabel.mas_top).offset(-2);
        make.height.width.mas_equalTo(pageMuteWH);
    }];
}

#pragma mark - Public
- (void)xyf_cleanView {
    self.xyp_avatar = @"";
    self.xyp_muteVideo = NO;
    self.xyp_isPKState = NO;
    self.xyp_floatState = NO;
    self.xyp_isShowOfflineTip = NO;
    [self xyf_changeFloatViewHiddenState:YES];
    [self xyf_changePageViewHiddenState:YES];
}

#pragma mark - Private
/// 改变UI
- (void)xyf_updateUIWithUpdateFrame:(void (^)(void))updateFrame {
    /// 如果显示了离线文案 或者 主播开启摄像头
    if (self.xyp_isShowOfflineTip || !self.xyp_muteVideo) {
        [self xyf_changeFloatViewHiddenState:YES];
        [self xyf_changePageViewHiddenState:YES];
        return;
    }
    
    /// ==== 不显示离线文案 && 主播禁用摄像头 ====
    if (self.xyp_floatState) {
        [self xyf_changeFloatViewHiddenState:NO];
        [self xyf_changePageViewHiddenState:YES];
    } else {
        if (updateFrame) {
            updateFrame();
        }
        /// 隐藏悬浮窗下的状态
        [self xyf_changeFloatViewHiddenState:YES];
        /// 如果是自己主播的画面，就直接显示
        if (self.xyp_isMineAnchor) {
            [self xyf_changePageViewHiddenState:NO];
        } else { /// 如果是对方主播的画面，是pk状态才显示
            BOOL isShow = self.xyp_isPKState;
            [self xyf_changePageViewHiddenState:!isShow];
        }
    }
}

/// 改变悬浮窗空态视图的隐藏状态
- (void)xyf_changeFloatViewHiddenState:(BOOL)hidden {
    self.xyp_floatAvatarIV.hidden = hidden;
    self.xyp_floatTipLabel.hidden = hidden;
}

/// 改变vc空态视图的隐藏状态
- (void)xyf_changePageViewHiddenState:(BOOL)hidden {
    self.xyp_pageMuteIV.hidden = hidden;
    self.xyp_pageTipLabel.hidden = hidden;
}

/// 改变vc提示
- (void)xyf_updatePageUI {
    /// 对方主播不用改ui 本来就这么大
    if (!self.xyp_isMineAnchor) { return; }
    /// 改中间提示
    [self xyf_updatePageTipLabel:self.xyp_isPKState];
    CGFloat leftRightMargin = [self xyf_getPageTipLabelLeftRightMargin:self.xyp_isPKState];
    CGFloat centerYMargin = [self xyf_getPageTipCenterYMargin:self.xyp_isPKState];
    [self.xyp_pageTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(leftRightMargin);
        make.trailing.equalTo(self).offset(-leftRightMargin);
        make.centerY.equalTo(self).offset(centerYMargin);
    }];
    
    /// 改禁视频按钮
    CGFloat pageMuteWH = [self xyf_getCameraOffIVWH:self.xyp_isPKState];
    [self.xyp_pageMuteIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(pageMuteWH);
    }];
}

/// 改变提示
- (void)xyf_updatePageTipLabel:(BOOL)isPKState {
    if (self.xyp_isMineAnchor && !isPKState) {
        self.xyp_pageTipLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.6);
        self.xyp_pageTipLabel.font = kXYLGilroyBoldFont(16);
    } else {
        self.xyp_pageTipLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.52);
        self.xyp_pageTipLabel.font = kXYLGilroyBoldFont(10);
    }
}

#pragma mark - Setter
- (void)setXyp_muteVideo:(BOOL)xyp_muteVideo {
    _xyp_muteVideo = xyp_muteVideo;
    [self xyf_updateUIWithUpdateFrame:^{
        [self xyf_updatePageUI];
    }];
}

- (void)setXyp_isPKState:(BOOL)xyp_isPKState {
    /// 如果PK状态改变 就要改空态UI
    BOOL isNeedUpdatePageView = xyp_isPKState != _xyp_isPKState;
    
    _xyp_isPKState = xyp_isPKState;
    [self xyf_updateUIWithUpdateFrame:^{
        [self xyf_updatePageUI];
    }];
}

- (void)setXyp_floatState:(BOOL)xyp_floatState {
    _xyp_floatState = xyp_floatState;
    [self xyf_updateUIWithUpdateFrame:^{
        
    }];
}

- (void)setXyp_isShowOfflineTip:(BOOL)xyp_isShowOfflineTip {
    _xyp_isShowOfflineTip = xyp_isShowOfflineTip;
    [self xyf_updateUIWithUpdateFrame:^{
        
    }];
}

- (void)setXyp_avatar:(NSString *)xyp_avatar {
    _xyp_avatar = xyp_avatar;
    [XYCUtil xyf_loadSmallImage:self.xyp_floatAvatarIV url:xyp_avatar placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
}

#pragma mark - Getter
- (CGFloat)xyf_getCameraOffIVWH:(BOOL)isPKState {
    if (self.xyp_isMineAnchor) {
        return isPKState ? 46 : 57;
    } else {
        return 46;
    }
}

- (CGFloat)xyf_getPageTipLabelLeftRightMargin:(BOOL)isPKState {
    if (self.xyp_isMineAnchor) {
        return isPKState ? 15 : 62;
    } else {
        return 15;
    }
}

- (CGFloat)xyf_getPageTipCenterYMargin:(BOOL)isPKState {
    if (self.xyp_isMineAnchor && !isPKState) {
        return self.xyp_pageTipCenterYMargin;
    } else {
        return 0;
    }
}

/// 获取只有自己主播的提示中心高度
- (CGFloat)xyf_getTipCenterYMarginWhenFullScreen {
    /// 头部距离
    CGFloat topHeight = kXYLRoomInfoHeaderViewTopMargin + kXYLRoomInfoHeaderViewHeight;
    /// 中间区域高度 = 弹幕顶部距离 - 头部距离
    CGFloat centerHeight = kXYLMessageBGViewTopMargin - topHeight;
    /// 提示的centerY距屏幕顶部距离
    CGFloat pageTipCenterY = centerHeight / 2.0 + topHeight + 5;
    /// 提示的centerY和self的centerY的距离
    CGFloat pageTipCenterYMargin = floor(pageTipCenterY - kXYLScreenHeight / 2.0);
    
    return pageTipCenterYMargin;
}

#pragma mark - Lazy
- (UIImageView *)xyp_floatAvatarIV {
    if (!_xyp_floatAvatarIV) {
        _xyp_floatAvatarIV = [[UIImageView alloc] init];
        _xyp_floatAvatarIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_floatAvatarIV.layer.cornerRadius = 27;
        _xyp_floatAvatarIV.clipsToBounds = YES;
        _xyp_floatAvatarIV.hidden = YES;
    }
    return _xyp_floatAvatarIV;
}

- (UILabel *)xyp_floatTipLabel {
    if (!_xyp_floatTipLabel) {
        _xyp_floatTipLabel = [[UILabel alloc] init];
        _xyp_floatTipLabel.font = kXYLGilroyBoldFont(10);
        _xyp_floatTipLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.52);
        _xyp_floatTipLabel.text = kXYLLocalString(@"Camera off");
        _xyp_floatTipLabel.hidden = YES;
    }
    return _xyp_floatTipLabel;
}

- (UILabel *)xyp_pageTipLabel {
    if (!_xyp_pageTipLabel) {
        _xyp_pageTipLabel = [[UILabel alloc] init];
        _xyp_pageTipLabel.font = kXYLGilroyBoldFont(10);
        _xyp_pageTipLabel.textColor = kXYLColorFromRGBA(0xffffff, 0.52);
        _xyp_pageTipLabel.text = kXYLLocalString(@"The host has temporarily turned off the camera.");
        _xyp_pageTipLabel.hidden = YES;
        _xyp_pageTipLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_pageTipLabel.numberOfLines = 0;
    }
    return _xyp_pageTipLabel;
}

- (UIImageView *)xyp_pageMuteIV {
    if (!_xyp_pageMuteIV) {
        _xyp_pageMuteIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_pageMuteIV iconStr:@"xyr_page_mute_video_icon"];
    }
    return _xyp_pageMuteIV;
}

@end
