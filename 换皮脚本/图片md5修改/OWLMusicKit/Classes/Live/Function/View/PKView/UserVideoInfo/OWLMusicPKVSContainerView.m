//
//  OWLMusicPKVSContainerView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/15.
//

#import "OWLMusicPKVSContainerView.h"
#import "OWLMusicPKVSUserView.h"

@interface OWLMusicPKVSContainerView ()

/// VS动画
@property (nonatomic, strong) UIImageView *xyp_vsGIF;
/// 主播容器
@property (nonatomic, strong) UIView *xyp_anchorBGView;

@end

@implementation OWLMusicPKVSContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    self.userInteractionEnabled = NO;
    [self addSubview:self.xyp_vsGIF];
    
    [self addSubview:self.xyp_anchorBGView];
}

#pragma mark - 动画
- (void)xyf_showAnimation:(OWLMusicRoomPKDataModel *)model {
    kXYLWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf xyf_showVSAnimation];
        [weakSelf xyf_showAnchorAnimation:model];
    });
}

- (void)xyf_dismissAnimation {
    [self xyf_dismissVSAnimation];
    [self xyf_removeAnchorAnimation];
}

#pragma mark 中间VS动画
- (void)xyf_showVSAnimation {
    [self xyf_dismissVSAnimation];
    [self.xyp_vsGIF startAnimating];
}

- (void)xyf_dismissVSAnimation {
    if (self.xyp_vsGIF.isAnimating) {
        [self.xyp_vsGIF stopAnimating];
    }
}

#pragma mark 两边主播动画
- (void)xyf_showAnchorAnimation:(OWLMusicRoomPKDataModel *)model {
    [self.xyp_anchorBGView xyf_removeAllSubviews];
    OWLMusicPKVSUserView *xyp_mineView = [[OWLMusicPKVSUserView alloc] initWithIsOtherAnchor:NO];
    xyp_mineView.xyp_playerModel = model.dsb_ownerPlayer;
    xyp_mineView.frame = CGRectMake(0, 0, 153, 50);
    OWLMusicPKVSUserView *xyp_otherView = [[OWLMusicPKVSUserView alloc] initWithIsOtherAnchor:YES];
    xyp_otherView.xyp_playerModel = model.dsb_otherPlayer;
    xyp_otherView.frame = CGRectMake(kXYLScreenWidth - 153, 0, 153, 50);
    
    [self.xyp_anchorBGView addSubview:xyp_mineView];
    [self.xyp_anchorBGView addSubview:xyp_otherView];
    
    xyp_mineView.transform = CGAffineTransformMakeTranslation(-153, 0);
    xyp_otherView.transform = CGAffineTransformMakeTranslation(153, 0);
    
    [UIView animateWithDuration:0.5 animations:^{
        xyp_mineView.transform = CGAffineTransformIdentity;
        xyp_otherView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                xyp_mineView.transform = CGAffineTransformMakeTranslation(-153, 0);
                xyp_otherView.transform = CGAffineTransformMakeTranslation(153, 0);
            } completion:^(BOOL finished) {
                [xyp_mineView removeFromSuperview];
                [xyp_otherView removeFromSuperview];
            }];
        });
    }];
}

- (void)xyf_removeAnchorAnimation {
    [self.xyp_anchorBGView xyf_removeAllSubviews];
}

#pragma mark - 事件处理
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject *)obj {
    switch (type) {
        case XYLModuleEventType_ClearAllData:
            [self xyf_dealClearAllData];
            break;
        case XYLModuleEventType_PKMatchSuccess:
            [self xyf_dealEventPKMatchSuccess:obj];
            break;
        default:
            break;
    }
}

- (void)xyf_dealClearAllData {
    [self xyf_dismissAnimation];
}

- (void)xyf_dealEventPKMatchSuccess:(NSObject * __nullable)obj {
    OWLMusicRoomPKDataModel *pkModel = (OWLMusicRoomPKDataModel *)obj;
    [self xyf_showAnimation:pkModel];
}

#pragma mark - Lazy
- (UIImageView *)xyp_vsGIF {
    if (!_xyp_vsGIF) {
        _xyp_vsGIF = [[UIImageView alloc] initWithFrame:CGRectMake((kXYLScreenWidth - 210) / 2, 0, 210, 210)];
        NSMutableArray *marr = [@[] mutableCopy];
        for (int i = 0; i < 57; i++) {
            NSString *str = [NSString stringWithFormat:@"xyr_pk_vs_image_%02d",i];
            [marr xyf_addObjectIfNotNil:[XYCUtil xyf_getPngIconWithName:str]];
        }
        _xyp_vsGIF.animationImages = marr;
        _xyp_vsGIF.animationDuration = 2.5;
        _xyp_vsGIF.animationRepeatCount = 1;
    }
    return _xyp_vsGIF;
}

- (UIView *)xyp_anchorBGView {
    if (!_xyp_anchorBGView) {
        _xyp_anchorBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kXYLScreenWidth, 50)];
    }
    return _xyp_anchorBGView;
}

@end
