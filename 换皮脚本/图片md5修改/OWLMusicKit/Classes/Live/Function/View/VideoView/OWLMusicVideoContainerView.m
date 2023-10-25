//
//  OWLMusicVideoContainerView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

/**
 * @功能描述：直播间 - 视频容器视图
 * @创建时间：2023.2.20
 * @创建人：许琰
 */

#import "OWLMusicVideoContainerView.h"
#import "OWLMusicFloatWindow.h"
#import "OWLBGMModuleVC.h"

@interface OWLMusicVideoContainerView ()

/// PK背景
@property (nonatomic, strong) UIImageView *xyp_pkBGView;
/// 自己主播的视频视图
@property (nonatomic, strong) OWLMusicVideoPreview *xyp_mineAnchorView;
/// 对方主播的视频视图
@property (nonatomic, strong) OWLMusicVideoPreview *xyp_otherAnchorView;
/// 自己主播离开文案
@property (nonatomic, strong) UILabel *xyp_mineLeaveTip;

@end

@implementation OWLMusicVideoContainerView

- (void)dealloc {
    NSLog(@"xytest 视频层dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_pkBGView];
    [self.xyp_pkBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.xyp_otherAnchorView];
    [self addSubview:self.xyp_mineAnchorView];
    
    [self.xyp_mineAnchorView addSubview:self.xyp_mineLeaveTip];
    [self.xyp_mineLeaveTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(kXYLWidthScale(65));
        make.trailing.equalTo(self).offset(-kXYLWidthScale(65));
        make.centerY.equalTo(self).offset(-kXYLHeightScale(30)-kXYLIPhoneBottomHeight);
    }];
}

#pragma mark - Public
/// 更新大小
- (void)xyf_changeVideoSize:(BOOL)isPKState {
    self.frame = [self xyf_getViewFrame:self.xyp_isFloatState];
    
    // xytodo 注释代码(已还原)
    self.xyp_mineAnchorView.frame = [self xyf_getMineFrame:isPKState isFloat:self.xyp_isFloatState];
    self.xyp_otherAnchorView.frame = [self xyf_getOtherFrame:self.xyp_isFloatState];
    self.xyp_mineAnchorView.xyp_isPKState = isPKState;
    self.xyp_otherAnchorView.xyp_isPKState = isPKState;
    
    self.xyp_pkBGView.hidden = self.xyp_isFloatState ? YES : !isPKState;
    
    if (self.xyp_isFloatState) {
        [self xyf_postNotification:xyl_live_float_window_change_size];
    }
}

/// 自动更新视频大小（在内部判断是两个人还是一个人）
- (void)xyf_audoChangeVideoSize {
    [self xyf_changeVideoSize:self.xyf_isPkState];
}

/// 改变状态
- (void)xyf_changeFloatState:(BOOL)isFloatState {
    self.xyp_isFloatState = isFloatState;
    self.frame = [self xyf_getViewFrame:isFloatState];
//    if (isFloatState) {
//        [self xyf_audoChangeVideoSize];
//    } else {
//        BOOL isPKState = self.xyf_isPkState;
//        [self xyf_setupRemoteView:self.xyp_mineAnchorView.xyp_accountID isStart:NO view:self.xyp_mineAnchorView.xyf_getVideoPreview];
//        [self xyf_setupRemoteView:self.xyp_otherAnchorView.xyp_accountID isStart:NO view:self.xyp_mineAnchorView.xyf_getVideoPreview];
//
//        self.xyp_mineAnchorView.frame = [self xyf_getMineFrame:isPKState isFloat:self.xyp_isFloatState];
//        self.xyp_otherAnchorView.frame = [self xyf_getOtherFrame:self.xyp_isFloatState];
//        self.xyp_mineAnchorView.xyp_isPKState = isPKState;
//        self.xyp_otherAnchorView.xyp_isPKState = isPKState;
//
//        self.xyp_pkBGView.hidden = self.xyp_isFloatState ? YES : !isPKState;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self xyf_setupRemoteView:self.xyp_mineAnchorView.xyp_accountID isStart:YES view:self.xyp_mineAnchorView.xyf_getVideoPreview];
//            [self xyf_setupRemoteView:self.xyp_otherAnchorView.xyp_accountID isStart:YES view:self.xyp_mineAnchorView.xyf_getVideoPreview];
//        });
//    }
    [self xyf_audoChangeVideoSize];
    [self.xyp_mineAnchorView xyf_changeFloatState:isFloatState];
    [self.xyp_otherAnchorView xyf_changeFloatState:isFloatState];
    [self xyf_changeLeaveTipIsShow];
}

- (void)xyf_setupRemoteView:(NSInteger)userID isStart:(BOOL)isStart view:(UIView *)view {
    AgoraRtcVideoCanvas *canvas = [AgoraRtcVideoCanvas new];
    canvas.view = isStart ? view : nil;
    canvas.uid = userID;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    [OWLJConvertToolShared.xyf_rtcKit setupRemoteVideo:canvas];
}

#pragma mark - Setter
- (void)setXyp_roomStatus:(XYLModuleRoomStateType)xyp_roomStatus {
    _xyp_roomStatus = xyp_roomStatus;
    [self xyf_changeLeaveTipIsShow];
}

#pragma mark - 更新
/// 更新文案显示隐藏
- (void)xyf_changeLeaveTipIsShow {
    BOOL isShowOfflineTip = NO;
    if (self.xyp_isFloatState) {
        self.xyp_mineLeaveTip.hidden = YES;
    } else {
        self.xyp_mineLeaveTip.hidden = YES;
        switch (self.xyp_roomStatus) {
            case XYLModuleRoomStateType_NoStart:
            case XYLModuleRoomStateType_Finish:
            case XYLModuleRoomStateType_Waiting:
                self.xyp_mineLeaveTip.hidden = NO;
                isShowOfflineTip = YES;
                if (OWLJConvertToolShared.xyf_isGreen || OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC) {
                    self.xyp_mineLeaveTip.text = kXYLLocalString(@"This user is offline. Chat with other online users.");
                } else {
                    self.xyp_mineLeaveTip.text = kXYLLocalString(@"This host is offline. Chat with other online hosts.");
                }
                break;
            case XYLModuleRoomStateType_PrivateChat:
                self.xyp_mineLeaveTip.hidden = NO;
                isShowOfflineTip = YES;
                if (OWLJConvertToolShared.xyf_isGreen || OWLMusicInsideManagerShared.xyp_vc.xyp_isUGC) {
                    self.xyp_mineLeaveTip.text = kXYLLocalString(@"This user is offline. Chat with other online users.");
                } else {
                    self.xyp_mineLeaveTip.text = kXYLLocalString(@"This host is in a private call. Please come back later.");
                }
                break;
            default:
                self.xyp_mineLeaveTip.text = @"";
                break;
        }
    }
    self.xyp_mineAnchorView.xyp_isShowOfflineTip = isShowOfflineTip;
    self.xyp_otherAnchorView.xyp_isShowOfflineTip = isShowOfflineTip;
}

#pragma mark - Getter
#pragma mark 获取不同状态下的大小
/// 自己主播
- (CGRect)xyf_getMineFrame:(BOOL)isPKState isFloat:(BOOL)isFloat {
    return isFloat ? [self xyf_getMineWindowFrame] : [self xyf_getMineNormalFrame:isPKState];
}

/// 对面主播
- (CGRect)xyf_getOtherFrame:(BOOL)isFloat {
    return isFloat ? [self xyf_getOtherWindowFrame] : [self xyf_getOtherNormalFrame];
}

/// 总视图
- (CGRect)xyf_getViewFrame:(BOOL)isFloat {
    return isFloat ? [self xyf_getViewWindowFrame] : [self xyf_getViewNormalFrame];
}

#pragma mark 正常状态下的大小
/// 自己主播
- (CGRect)xyf_getMineNormalFrame:(BOOL)isPKState {
    if (isPKState) {
        return CGRectMake(0, kXYLPKVideoViewY, kXYLScreenWidth / 2.0, kXYLPKVideoViewHeight);
    } else {
        return CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
    }
}

/// 对面主播
- (CGRect)xyf_getOtherNormalFrame {
    return CGRectMake(kXYLScreenWidth / 2.0, kXYLPKVideoViewY, kXYLScreenWidth / 2.0, kXYLPKVideoViewHeight);
}

/// 总视图
- (CGRect)xyf_getViewNormalFrame {
    return CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight);
}

#pragma mark 小窗状态下的大小
/// 自己主播
- (CGRect)xyf_getMineWindowFrame {
    return CGRectMake(0, 0, kXYLSmallVideoWidth, kXYLSmallVideoHeight);
}

/// 对面主播
- (CGRect)xyf_getOtherWindowFrame {
    return CGRectMake(kXYLSmallVideoWidth, 0, kXYLSmallVideoWidth, kXYLSmallVideoHeight);
}

/// 总视图
- (CGRect)xyf_getViewWindowFrame {
    BOOL isPKState = self.xyp_otherAnchorView.xyp_accountID > 0;
    CGFloat viewW = isPKState ? kXYLSmallVideoWidth * 2 : kXYLSmallVideoWidth;
    CGFloat viewH = kXYLSmallVideoHeight;
    return CGRectMake(0, 0, viewW, viewH);
}

/// 初始frame
- (CGRect)xyf_getViewWindowStartFrame {
    CGFloat viewW = [self xyf_getViewWindowFrame].size.width;
    CGFloat viewX = kXYLScreenWidth - viewW;
    CGFloat viewY = kXYLScreenHeight - 109 - kXYLIPhoneBottomHeight - kXYLSmallVideoHeight;
    return CGRectMake(viewX, viewY, viewW, kXYLSmallVideoHeight);
}

/// 是否被禁言
- (BOOL)xyf_isPkState {
    BOOL isPK = false;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(xyf_subManagerIsShowTwoPeople)]) {
        isPK = [self.dataSource xyf_subManagerIsShowTwoPeople];
    }
    return isPK;
}

#pragma mark - Lazy
- (OWLMusicVideoPreview *)xyp_mineAnchorView {
    if (!_xyp_mineAnchorView) {
        // xytodo 注释代码(已还原)
        _xyp_mineAnchorView = [[OWLMusicVideoPreview alloc] initWithFrame:[self xyf_getMineNormalFrame:NO] isMineAnchor:YES];
    }
    return _xyp_mineAnchorView;
}

- (OWLMusicVideoPreview *)xyp_otherAnchorView {
    if (!_xyp_otherAnchorView) {
        _xyp_otherAnchorView = [[OWLMusicVideoPreview alloc] initWithFrame:[self xyf_getOtherNormalFrame] isMineAnchor:NO];
    }
    return _xyp_otherAnchorView;
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

- (UIImageView *)xyp_pkBGView {
    if (!_xyp_pkBGView) {
        _xyp_pkBGView = [[UIImageView alloc] init];
        _xyp_pkBGView.hidden = YES;
        _xyp_pkBGView.image = [XYCUtil xyf_getPngIconWithName:@"xyr_pk_bg_image"];
    }
    return _xyp_pkBGView;
}

@end
