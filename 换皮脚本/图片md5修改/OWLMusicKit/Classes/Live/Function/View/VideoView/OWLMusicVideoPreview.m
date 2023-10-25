//
//  OWLMusicVideoPreview.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

/**
 * @功能描述：直播间 - 显示视频视图
 * @创建时间：2023.2.20
 * @创建人：许琰
 */

#import "OWLMusicVideoPreview.h"
#import "OWLMusicVideoCameraOffView.h"

@interface OWLMusicVideoPreview ()

/// 封面
@property (nonatomic, strong) UIImageView *xyp_coverIV;
/// 蒙层
@property (nonatomic, strong) UIVisualEffectView *xyp_effectView;
/// 视频
@property (nonatomic, strong) UIView *xyp_preview;
/// 静音图标
@property (nonatomic, strong) UIImageView *xyp_muteIV;
/// 是否是小窗状态
@property (nonatomic, assign) BOOL xyp_isFloatState;
/// 关闭摄像头视图
@property (nonatomic, strong) OWLMusicVideoCameraOffView *xyp_cameraOffView;
/// 是否是自己观看的主播
@property (nonatomic, assign) BOOL xyp_isMineAnchor;

@end

@implementation OWLMusicVideoPreview

- (instancetype)initWithFrame:(CGRect)frame isMineAnchor:(BOOL)xyp_isMineAnchor {
    self = [super initWithFrame:frame];
    if (self) {
        self.xyp_isMineAnchor = xyp_isMineAnchor;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.clipsToBounds = YES;
    CGFloat version = [[UIDevice currentDevice] systemVersion].floatValue;
    if (version >= 13.2) {
        [self xyf_setupCover];
        UITextField *textField = [[UITextField alloc] init];
        textField.secureTextEntry = YES;
        textField.enabled = NO;
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        if (textField.subviews.firstObject != nil) {
            [textField.subviews.firstObject addSubview:self.xyp_preview];
            self.xyp_preview = textField.subviews.firstObject;
            self.userInteractionEnabled = YES;
        }
        [self xyf_setupMuteIV];
        [self xyf_setupCameraOffView];
    } else {
        [self xyf_setupCover];
        
        [self addSubview:self.xyp_preview];
        [self.xyp_preview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self xyf_setupMuteIV];
        [self xyf_setupCameraOffView];
    }
}

- (void)xyf_setupCover {
    [self addSubview:self.xyp_coverIV];
    [self.xyp_coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.xyp_effectView];
    [self.xyp_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)xyf_setupMuteIV {
    [self addSubview:self.xyp_muteIV];
    [self.xyp_muteIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(16);
        make.top.equalTo(self).offset(40);
        make.trailing.equalTo(self).offset(-8);
    }];
}

- (void)xyf_setupCameraOffView {
    [self addSubview:self.xyp_cameraOffView];
    [self.xyp_cameraOffView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setXyp_isMuted:(BOOL)xyp_isMuted {
    _xyp_isMuted = xyp_isMuted;
    [self xyf_changeMuteIVState];
}

- (void)setXyp_isPKState:(BOOL)xyp_isPKState {
    _xyp_isPKState = xyp_isPKState;
    [self xyf_changeCoverHiddenState];
    [self xyf_changeMuteIVState];
    self.xyp_cameraOffView.xyp_isPKState = xyp_isPKState;
}

- (void)setXyp_isCameraOff:(BOOL)xyp_isCameraOff {
    _xyp_isCameraOff = xyp_isCameraOff;
    self.xyp_cameraOffView.xyp_muteVideo = xyp_isCameraOff;
}

- (void)setXyp_avatar:(NSString *)xyp_avatar {
    _xyp_avatar = xyp_avatar;
    self.xyp_cameraOffView.xyp_avatar = xyp_avatar;
}

- (void)setXyp_isShowOfflineTip:(BOOL)xyp_isShowOfflineTip {
    _xyp_isShowOfflineTip = xyp_isShowOfflineTip;
    self.xyp_cameraOffView.xyp_isShowOfflineTip = xyp_isShowOfflineTip;
}

#pragma mark - Public
/// 设置封面
- (void)xyf_setCover:(NSString *)cover isClean:(BOOL)isClean {
    /// 更新视图
    if (isClean) {
        self.xyp_coverIV.image = nil;
    } else {
        if (cover.length == 0) {
            self.xyp_coverIV.image = OWLJConvertToolShared.xyf_userPlaceHolder;
        } else {
            [XYCUtil xyf_loadSmallImage:self.xyp_coverIV url:cover placeholder:OWLJConvertToolShared.xyf_userPlaceHolder];
        }
    }
    
    /// 更新显示隐藏
    [self xyf_changeFloatState:self.xyp_isFloatState];
}

/// 获取视频幕布
- (UIView *)xyf_getVideoPreview {
    return self.xyp_preview;
}

/// 清空视图
- (void)xyf_resetView {
    self.xyp_accountID = 0;
    /// 如果是自己主播 并且在悬浮窗状态下。不清空封面。
    if (!(self.xyp_isMineAnchor && self.xyp_isFloatState)) {
        [self xyf_setCover:@"" isClean:YES];
    }
    [self.xyp_preview xyf_removeAllSubviews];
    self.xyp_preview.hidden = NO;
    self.xyp_isMuted = NO;
    [self.xyp_cameraOffView xyf_cleanView];
}

/// 改变浮窗状态
- (void)xyf_changeFloatState:(BOOL)isFloat {
    self.xyp_isFloatState = isFloat;
    [self xyf_changeCoverHiddenState];
    self.xyp_cameraOffView.xyp_floatState = isFloat;
}

#pragma mark - Private
/// 改变封面的显示隐藏状态
- (void)xyf_changeCoverHiddenState {
    /// 如果是悬浮窗状态 或者 PK状态下 封面是要显示的。
    if (self.xyp_isFloatState || self.xyp_isPKState) {
        self.xyp_coverIV.hidden = NO;
        self.xyp_effectView.hidden = NO;
    } else { /// 如果是在直播间页面的单人直播 不需要显示封面。cell上有封面。（fix bug 上下滑动 页面闪动问题）
        self.xyp_coverIV.hidden = YES;
        self.xyp_effectView.hidden = YES;
    }
}

/// 更改音频按钮状态
- (void)xyf_changeMuteIVState {
    if (self.xyp_isPKState) {
        self.xyp_muteIV.hidden = !self.xyp_isMuted;
    } else {
        self.xyp_muteIV.hidden = YES;
    }
}

#pragma mark - Lazy
- (UIView *)xyp_preview {
    if (!_xyp_preview) {
        _xyp_preview = [[UIView alloc] init];
    }
    return _xyp_preview;
}

- (UIImageView *)xyp_coverIV {
    if (!_xyp_coverIV) {
        _xyp_coverIV = [[UIImageView alloc] init];
        _xyp_coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_coverIV.clipsToBounds = YES;
        _xyp_coverIV.hidden = YES;
    }
    return _xyp_coverIV;
}

- (UIVisualEffectView *)xyp_effectView {
    if (!_xyp_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _xyp_effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _xyp_effectView.frame = self.bounds;
        _xyp_effectView.alpha = 0.97;
        _xyp_effectView.hidden = YES;
    }
    return _xyp_effectView;
}

- (UIImageView *)xyp_muteIV {
    if (!_xyp_muteIV) {
        _xyp_muteIV = [[UIImageView alloc] init];
        _xyp_muteIV.hidden = YES;
        [XYCUtil xyf_loadIconImage:self.xyp_muteIV iconStr:@"xyr_pk_other_mute_audio_icon"];
    }
    return _xyp_muteIV;
}

- (OWLMusicVideoCameraOffView *)xyp_cameraOffView {
    if (!_xyp_cameraOffView) {
        _xyp_cameraOffView = [[OWLMusicVideoCameraOffView alloc] initWithIsMine:self.xyp_isMineAnchor];
    }
    return _xyp_cameraOffView;
}

@end
