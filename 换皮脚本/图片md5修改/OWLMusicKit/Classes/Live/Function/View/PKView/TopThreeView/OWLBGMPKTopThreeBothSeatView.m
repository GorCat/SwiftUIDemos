//
//  OWLBGMPKTopThreeBothSeatView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/15.
//

/**
 * @功能描述：直播间PK控制层 - 两边前三名座位
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKTopThreeBothSeatView.h"
#import "OWLBGMPKTopThreeSeatView.h"

@interface OWLBGMPKTopThreeBothSeatView ()

/// 自己主播
@property (nonatomic, strong) OWLBGMPKTopThreeSeatView *xyp_mineView;
/// 对面主播
@property (nonatomic, strong) OWLBGMPKTopThreeSeatView *xyp_otherView;

@end

@implementation OWLBGMPKTopThreeBothSeatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha < 0.01) {
        return nil;
    }
    
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    for (UIView *view in self.subviews) {
        CGPoint tempPoint = [view convertPoint:point fromView:self];
        CGRect bounds = view.bounds;
        if (CGRectContainsPoint(bounds, tempPoint)) {
            if ([view isKindOfClass:[OWLBGMPKTopThreeSeatView class]]) {
                return view;
            }
        }
    }
    
    return nil;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_mineView];
    [self addSubview:self.xyp_otherView];
}

#pragma mark - Setter
- (void)setXyp_pkData:(OWLMusicRoomPKDataModel *)xyp_pkData {
    _xyp_pkData = xyp_pkData;
    self.xyp_mineView.xyp_avatarList = xyp_pkData.dsb_ownerPoint.dsb_topThreeAvatars;
    self.xyp_otherView.xyp_avatarList = xyp_pkData.dsb_otherPoint.dsb_topThreeAvatars;
}

#pragma mark - Actions
- (void)xyf_mineViewAction {
    [self xyf_giveCallBackShowPKRankListIsOther:NO];
}

- (void)xyf_otherViewAction {
    [self xyf_giveCallBackShowPKRankListIsOther:YES];
}

#pragma mark - 给回调
- (void)xyf_giveCallBackShowPKRankListIsOther:(BOOL)isOther {
    [OWLMusicTongJiTool xyf_thinkingWithName:XYLThinkingEventClickPKRankList];
    NSInteger anchorID = isOther ? self.xyp_pkData.dsb_otherPlayer.dsb_accountID : self.xyp_pkData.dsb_ownerPlayer.dsb_accountID;
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_lModuleBaseViewShowPKRankWithAccountID:isOtherAnchor:)]) {
        [self.delegate xyf_lModuleBaseViewShowPKRankWithAccountID:anchorID isOtherAnchor:isOther];
    }
}

#pragma mark - Lazy
- (OWLBGMPKTopThreeSeatView *)xyp_mineView {
    if (!_xyp_mineView) {
        _xyp_mineView = [[OWLBGMPKTopThreeSeatView alloc] initWithframe:CGRectMake(12, 6, 93, 27) isOtherAnchor:NO];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_mineViewAction)];
        [_xyp_mineView addGestureRecognizer:tap];
    }
    return _xyp_mineView;
}

- (OWLBGMPKTopThreeSeatView *)xyp_otherView {
    if (!_xyp_otherView) {
        _xyp_otherView = [[OWLBGMPKTopThreeSeatView alloc] initWithframe:CGRectMake(kXYLScreenWidth - 93 - 12, 6, 93, 27) isOtherAnchor:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_otherViewAction)];
        [_xyp_otherView addGestureRecognizer:tap];
    }
    return _xyp_otherView;
}

@end
