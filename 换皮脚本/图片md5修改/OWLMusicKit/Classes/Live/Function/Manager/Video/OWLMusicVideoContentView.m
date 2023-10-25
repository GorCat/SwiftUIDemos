//
//  OWLMusicVideoContentView.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/30.
//

#import "OWLMusicVideoContentView.h"
#import "OWLMusicSingleVideoView.h"

@interface OWLMusicVideoContentView ()

#pragma mark - Views
/// PK背景
@property (nonatomic, strong) UIImageView *xyp_pkBGView;
/// 全屏视图
@property (nonatomic, strong) OWLMusicSingleVideoView *xyp_fullView;
/// pk己方视图
@property (nonatomic, strong) OWLMusicSingleVideoView *xyp_pkMineView;
/// pk对方视图
@property (nonatomic, strong) OWLMusicSingleVideoView *xyp_pkOtherView;
/// 自己主播离开文案
@property (nonatomic, strong) UILabel *xyp_mineLeaveTip;

#pragma mark - BOOL
/// 是否是小窗
@property (nonatomic, assign) BOOL xyp_isSmall;

@end

@implementation OWLMusicVideoContentView

- (instancetype)initWithIsSmall:(BOOL)isSmall {
    self = [super init];
    if (self) {
        self.xyp_isSmall = isSmall;
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    if (!self.xyp_isSmall) {
        [self addSubview:self.xyp_pkBGView];
        [self.xyp_pkBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    [self addSubview:self.xyp_pkMineView];
    [self addSubview:self.xyp_pkOtherView];
    if (!self.xyp_isSmall) {
        [self addSubview:self.xyp_fullView];
        [self.xyp_fullView addSubview:self.xyp_mineLeaveTip];
        [self.xyp_mineLeaveTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(kXYLWidthScale(65));
            make.trailing.equalTo(self).offset(-kXYLWidthScale(65));
            make.centerY.equalTo(self).offset(-kXYLHeightScale(30)-kXYLIPhoneBottomHeight);
        }];
    }
}

#pragma mark - Getter
//- (UIView *)xyf_getPreview:(BOOL)isMine {
//    if (self.xyp_isSmall) {
//
//    } else {
//
//    }
//}

- (OWLMusicSingleVideoView *)xyf_getSingleVideoView:(BOOL)isMine
                                            isPKState:(BOOL)isPKState {
    if (self.xyp_isSmall) {
        return [self xyf_getSingleViewInSmallState:isMine];
    } else {
        return [self xyf_getSingleViewInFullState:isMine isPKState:isPKState];
    }
}

/// 小窗状态下获取视图
- (OWLMusicSingleVideoView *)xyf_getSingleViewInSmallState:(BOOL)isMine {
    return isMine ? self.xyp_pkMineView : self.xyp_pkOtherView;
}

/// 全屏状态下获取视图
- (OWLMusicSingleVideoView *)xyf_getSingleViewInFullState:(BOOL)isMine isPKState:(BOOL)isPKState {
    if (isMine) {
        return isPKState ? self.xyp_pkMineView : self.xyp_fullView;
    } else {
        return self.xyp_pkOtherView;
    }
}

#pragma mark - Lazy
- (UIImageView *)xyp_pkBGView {
    if (!_xyp_pkBGView) {
        _xyp_pkBGView = [[UIImageView alloc] init];
        _xyp_pkBGView.hidden = YES;
        _xyp_pkBGView.image = [XYCUtil xyf_getPngIconWithName:@"xyr_pk_bg_image"];
    }
    return _xyp_pkBGView;
}

- (OWLMusicSingleVideoView *)xyp_fullView {
    if (!_xyp_fullView) {
        _xyp_fullView = [[OWLMusicSingleVideoView alloc] initWithSizeType:XYLModuleSingleVideoSizeType_FullSingle anchorType:XYLModuleSingleVideoAnchorType_Mine];
    }
    return _xyp_fullView;
}

- (OWLMusicSingleVideoView *)xyp_pkMineView {
    if (!_xyp_pkMineView) {
        XYLModuleSingleVideoSizeType size = self.xyp_isSmall ? XYLModuleSingleVideoSizeType_FloatState : XYLModuleSingleVideoSizeType_FullPK;
        _xyp_pkMineView = [[OWLMusicSingleVideoView alloc] initWithSizeType:size anchorType:XYLModuleSingleVideoAnchorType_Mine];
    }
    return _xyp_pkMineView;
}

- (OWLMusicSingleVideoView *)xyp_pkOtherView {
    if (!_xyp_pkOtherView) {
        XYLModuleSingleVideoSizeType size = self.xyp_isSmall ? XYLModuleSingleVideoSizeType_FloatState : XYLModuleSingleVideoSizeType_FullPK;
        _xyp_pkOtherView = [[OWLMusicSingleVideoView alloc] initWithSizeType:size anchorType:XYLModuleSingleVideoAnchorType_Other];
    }
    return _xyp_pkOtherView;
}

- (UILabel *)xyp_mineLeaveTip {
    if (!_xyp_mineLeaveTip) {
        _xyp_mineLeaveTip = [[UILabel alloc] init];
        _xyp_mineLeaveTip.font = kXYLGilroyBoldFont(16);
        _xyp_mineLeaveTip.textColor = UIColor.whiteColor;
        _xyp_mineLeaveTip.textAlignment = NSTextAlignmentCenter;
        _xyp_mineLeaveTip.numberOfLines = 0;
    }
    return _xyp_mineLeaveTip;
}

@end
