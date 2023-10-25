//
//  OWLMusicSingleVideoView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLMusicSingleVideoView.h"
#import "OWLMusicSingleVideoViewConfig.h"

@interface OWLMusicSingleVideoView ()

#pragma mark - Views
/// 封面
@property (nonatomic, strong) UIImageView *xyp_coverIV;
/// 蒙层
@property (nonatomic, strong) UIVisualEffectView *xyp_effectView;
/// 视频
@property (nonatomic, strong) UIView *xyp_preview;
/// 静音图标
@property (nonatomic, strong) UIImageView *xyp_muteIV;

#pragma mark - Data
/// 大小类型
@property (nonatomic, assign) XYLModuleSingleVideoSizeType xyp_sizeType;
/// 主播类型
@property (nonatomic, assign) XYLModuleSingleVideoAnchorType xyp_anchorType;
/// 配置
@property (nonatomic, strong) OWLMusicSingleVideoViewConfig *xyp_config;

@end

@implementation OWLMusicSingleVideoView

- (instancetype)initWithSizeType:(XYLModuleSingleVideoSizeType)sizeType anchorType:(XYLModuleSingleVideoAnchorType)anchorType {
    self = [super init];
    if (self) {
        self.xyp_sizeType = sizeType;
        self.xyp_anchorType = anchorType;
        [self xyf_setupConfig];
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupConfig {
    self.xyp_config = [[OWLMusicSingleVideoViewConfig alloc] initWithSizeType:self.xyp_sizeType anchorType:self.xyp_anchorType];
    self.frame = self.xyp_config.xyp_frame;
}

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
    } else {
        [self xyf_setupCover];
        
        [self addSubview:self.xyp_preview];
        [self.xyp_preview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self xyf_setupMuteIV];
    }
}

- (void)xyf_setupCover {
    if (!self.xyp_config.xyp_hasCover) { return; }
    
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
    if (!self.xyp_config.xyp_hasMuteIcon) { return; }
    
    [self addSubview:self.xyp_muteIV];
    [self.xyp_muteIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(16);
        make.top.equalTo(self).offset(40);
        make.trailing.equalTo(self).offset(-8);
    }];
}

#pragma mark - Setter
- (void)setXyp_isMuted:(BOOL)xyp_isMuted {
    _xyp_isMuted = xyp_isMuted;
    if (!self.xyp_config.xyp_hasMuteIcon) { return; }
    self.xyp_muteIV.hidden = !xyp_isMuted;
}

#pragma mark - Public
/// 获取视频幕布
- (UIView *)xyf_getPreview {
    return self.xyp_preview;
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

@end
