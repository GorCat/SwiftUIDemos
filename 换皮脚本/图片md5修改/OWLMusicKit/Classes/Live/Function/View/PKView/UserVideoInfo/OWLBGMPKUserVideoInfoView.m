//
//  OWLBGMPKUserVideoInfoView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 用户pk信息视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKUserVideoInfoView.h"
#import "OWLBGMPKOtherAnchorInfoView.h"
#import "OWLBGMPKUserVideoResultView.h"
#import "OWLBGMPKUserVideoReadyView.h"
#import "OWLBGMPKContinueWinView.h"
#import "OWLMusicPKOppositeEnterView.h"
#import "OWLMusicPKVSContainerView.h"

@interface OWLBGMPKUserVideoInfoView ()

#pragma mark - Views
/// pk结果图标
@property (nonatomic, strong) OWLBGMPKUserVideoResultView *xyp_resultView;
/// 准备
@property (nonatomic, strong) OWLBGMPKUserVideoReadyView *xyp_readyView;
/// 连胜图标
@property (nonatomic, strong) OWLBGMPKContinueWinView *xyp_continueWinView;
/// 用户信息
@property (nonatomic, strong) OWLBGMPKOtherAnchorInfoView *xyp_otherAnchorInfoView;
/// 对方按钮
@property (nonatomic, strong) OWLMusicPKOppositeEnterView *xyp_oppositeView;
/// VS动画
@property (nonatomic, strong) OWLMusicPKVSContainerView *xyp_vsView;

@end

@implementation OWLBGMPKUserVideoInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *responseView = nil;
    
    for (UIView *view in self.subviews) {
        CGPoint tempPoint = [view convertPoint:point fromView:self];
        CGRect bounds = view.bounds;
        if (CGRectContainsPoint(bounds, tempPoint)) {
            if ([view isKindOfClass:[OWLBGMModuleBaseView class]]) {
                OWLBGMModuleBaseView *needCheckView = (OWLBGMModuleBaseView *)view;
                if (needCheckView.xyp_needCheckTapPoint) {
                    responseView = [needCheckView hitTest:tempPoint withEvent:event];
                    if (responseView == needCheckView) {
                        responseView = nil;
                    } else {
                        break;
                    }
                }
            }
        }
    }

    return responseView;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_resultView];
    [self addSubview:self.xyp_otherAnchorInfoView];
    [self addSubview:self.xyp_readyView];
    [self addSubview:self.xyp_continueWinView];
    [self addSubview:self.xyp_oppositeView];
    [self addSubview:self.xyp_vsView];
}

#pragma mark - Setter
- (void)setXyp_pkDataModel:(OWLMusicRoomPKDataModel *)xyp_pkDataModel {
    _xyp_pkDataModel = xyp_pkDataModel;
    /// 准备视图
    self.xyp_readyView.xyp_minePlayerModel = self.xyp_pkDataModel.dsb_ownerPlayer;
    self.xyp_readyView.xyp_otherPlayerModel = self.xyp_pkDataModel.dsb_otherPlayer;
    /// 连胜视图
    self.xyp_continueWinView.xyp_minePlayerModel = self.xyp_pkDataModel.dsb_ownerPlayer;
    self.xyp_continueWinView.xyp_otherPlayerModel = self.xyp_pkDataModel.dsb_otherPlayer;
    /// 对方视图
    self.xyp_otherAnchorInfoView.xyp_otherPlayerModel = self.xyp_pkDataModel.dsb_otherPlayer;
}

- (void)setDelegate:(id<OWLBGMModuleBaseViewDelegate>)delegate {
    self.xyp_oppositeView.delegate = delegate;
    self.xyp_otherAnchorInfoView.delegate = delegate;
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    [self.xyp_vsView xyf_dealWithEvent:type obj:obj];
    [self.xyp_resultView xyf_dealWithEvent:type obj:obj];
}

#pragma mark - Lazy
- (OWLBGMPKUserVideoResultView *)xyp_resultView {
    if (!_xyp_resultView) {
        _xyp_resultView = [[OWLBGMPKUserVideoResultView alloc] init];
        _xyp_resultView.frame = [_xyp_resultView xyf_resultViewFrame];
    }
    return _xyp_resultView;
}

- (OWLBGMPKOtherAnchorInfoView *)xyp_otherAnchorInfoView {
    if (!_xyp_otherAnchorInfoView) {
        _xyp_otherAnchorInfoView = [[OWLBGMPKOtherAnchorInfoView alloc] init];
        _xyp_otherAnchorInfoView.xyp_needCheckTapPoint = YES;
        _xyp_otherAnchorInfoView.frame = [_xyp_otherAnchorInfoView xyf_anchorViewFrame];
    }
    return _xyp_otherAnchorInfoView;
}

- (OWLBGMPKUserVideoReadyView *)xyp_readyView {
    if (!_xyp_readyView) {
        _xyp_readyView = [[OWLBGMPKUserVideoReadyView alloc] init];
        _xyp_readyView.frame = [_xyp_readyView xyf_readyViewFrame];
    }
    return _xyp_readyView;
}

- (OWLBGMPKContinueWinView *)xyp_continueWinView {
    if (!_xyp_continueWinView) {
        _xyp_continueWinView = [[OWLBGMPKContinueWinView alloc] initWithFrame:CGRectMake(0, kXYLPKVideoViewHeight - 24 - 13, kXYLScreenWidth, 24)];
    }
    return _xyp_continueWinView;
}

- (OWLMusicPKOppositeEnterView *)xyp_oppositeView {
    if (!_xyp_oppositeView) {
        _xyp_oppositeView = [[OWLMusicPKOppositeEnterView alloc] init];
        _xyp_oppositeView.xyp_needCheckTapPoint = YES;
        _xyp_oppositeView.frame = [_xyp_oppositeView xyf_oppositeViewFrame];
    }
    return _xyp_oppositeView;
}

- (OWLMusicPKVSContainerView *)xyp_vsView {
    if (!_xyp_vsView) {
        _xyp_vsView = [[OWLMusicPKVSContainerView alloc] initWithFrame:CGRectMake(0, kXYLPKVideoViewHeight - 33 - 210, kXYLScreenWidth, 210)];
    }
    return _xyp_vsView;
}

@end
