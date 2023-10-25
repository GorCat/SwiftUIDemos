//
//  OWLBGMPKControlView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKControlView.h"
#import "OWLBGMPKProgressView.h"
#import "OWLBGMPKTimeView.h"
#import "OWLBGMPKTopThreeBothSeatView.h"
#import "OWLBGMPKUserVideoInfoView.h"

@interface OWLBGMPKControlView ()

/// 用户pk信息视图
@property (nonatomic, strong) OWLBGMPKUserVideoInfoView *xyp_pkInfoView;
/// 进度条
@property (nonatomic, strong) OWLBGMPKProgressView *xyp_progressView;
/// 时间视图
@property (nonatomic, strong) OWLBGMPKTimeView *xyp_timeView;
/// 前三名座位视图
@property (nonatomic, strong) OWLBGMPKTopThreeBothSeatView *xyp_topSeatView;

@end

@implementation OWLBGMPKControlView

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
    [self addSubview:self.xyp_pkInfoView];
    [self addSubview:self.xyp_topSeatView];
    [self addSubview:self.xyp_timeView];
    [self addSubview:self.xyp_progressView];
    
    [self.xyp_pkInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(kXYLPKVideoViewHeight);
    }];
    
    [self.xyp_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.xyp_progressView.mas_top);
        make.width.mas_equalTo(77);
        make.height.mas_equalTo(22);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setDelegate:(id<OWLBGMModuleBaseViewDelegate>)delegate {
    self.xyp_topSeatView.delegate = delegate;
    self.xyp_pkInfoView.delegate = delegate;
}

- (void)setXyp_pkData:(OWLMusicRoomPKDataModel *)xyp_pkData {
    _xyp_pkData = xyp_pkData;
    self.hidden = !xyp_pkData;
    self.xyp_pkInfoView.xyp_pkDataModel = xyp_pkData;
    self.xyp_progressView.xyp_pkData = xyp_pkData;
    self.xyp_topSeatView.xyp_pkData = xyp_pkData;
    self.xyp_timeView.xyp_pkData = xyp_pkData;
}

#pragma mark - 事件处理
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    [self.xyp_timeView xyf_dealWithEvent:type obj:obj];
    [self.xyp_pkInfoView xyf_dealWithEvent:type obj:obj];
}

#pragma mark - Lazy
- (OWLBGMPKUserVideoInfoView *)xyp_pkInfoView {
    if (!_xyp_pkInfoView) {
        _xyp_pkInfoView = [[OWLBGMPKUserVideoInfoView alloc] init];
        _xyp_pkInfoView.xyp_needCheckTapPoint = YES;
    }
    return _xyp_pkInfoView;
}

- (OWLBGMPKProgressView *)xyp_progressView {
    if (!_xyp_progressView) {
        _xyp_progressView = [[OWLBGMPKProgressView alloc] initWithFrame:CGRectMake(0, kXYLPKVideoViewHeight, kXYLScreenWidth, kXYLPKProgressViewHeight)];
    }
    return _xyp_progressView;
}

- (OWLBGMPKTimeView *)xyp_timeView {
    if (!_xyp_timeView) {
        _xyp_timeView = [[OWLBGMPKTimeView alloc] init];
    }
    return _xyp_timeView;
}

- (OWLBGMPKTopThreeBothSeatView *)xyp_topSeatView {
    if (!_xyp_topSeatView) {
        _xyp_topSeatView = [[OWLBGMPKTopThreeBothSeatView alloc] initWithFrame:CGRectMake(0, self.xyp_h - kXYLPKTopThreeHeight, kXYLScreenWidth, kXYLPKTopThreeHeight)];
        _xyp_topSeatView.xyp_needCheckTapPoint = YES;
    }
    return _xyp_topSeatView;
}

@end
