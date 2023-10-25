//
//  OWLBGMPKTimeView.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间PK控制层 - 时间视图
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#import "OWLBGMPKTimeView.h"

@interface OWLBGMPKTimeView ()

#pragma mark - Views
/// 背景
@property (nonatomic, strong) UIImageView *xyp_bgIV;
/// 时间背景
@property (nonatomic, strong) UIView *xyp_timeBGView;
/// vs图片
@property (nonatomic, strong) UIImageView *xyp_vsIV;
/// 时间
@property (nonatomic, strong) UILabel *xyp_timeLabel;
/// 惩罚
@property (nonatomic, strong) UILabel *xyp_punishLabel;

#pragma mark - 定时器
@property (nonatomic, strong) NSTimer *xyp_timer;

@property (nonatomic, assign) NSInteger xyp_leftTime;

@end

@implementation OWLBGMPKTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self xyf_setupView];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupView {
    [self addSubview:self.xyp_bgIV];
    [self.xyp_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_timeBGView];
    [self.xyp_timeBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_bgIV);
    }];
    
    [self.xyp_timeBGView addSubview:self.xyp_vsIV];
    [self.xyp_vsIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10.5);
        make.width.mas_equalTo(18.5);
        make.centerY.equalTo(self.xyp_timeBGView);
        make.leading.equalTo(self.xyp_timeBGView).offset(12);
    }];
    
    [self.xyp_timeBGView addSubview:self.xyp_timeLabel];
    [self.xyp_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_vsIV.mas_trailing).offset(5);
        make.centerY.equalTo(self.xyp_timeBGView);
        make.trailing.equalTo(self.xyp_timeBGView);
    }];
    
    [self.xyp_bgIV addSubview:self.xyp_punishLabel];
    [self.xyp_punishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.xyp_bgIV);
    }];
}

#pragma mark - Setter
- (void)setXyp_pkData:(OWLMusicRoomPKDataModel *)xyp_pkData {
    _xyp_pkData = xyp_pkData;
    /// 如果不存在pk数据了，就停止定时器
    if (xyp_pkData == nil) {
        [self xyf_removeTimer];
        return;
    }
    /// 如果pk时间到了，就停止定时器，显示对应样式
    if (xyp_pkData.dsb_leftTime <= 0) {
        [self xyf_removeTimer];
        self.xyp_timeBGView.hidden = YES;
        self.xyp_punishLabel.transform = CGAffineTransformIdentity;
        if (xyp_pkData.dsb_winAnchorData.dsb_accountID == 0) {
            self.xyp_punishLabel.text = kXYLLocalString(@"Draw");
        } else {
            self.xyp_punishLabel.text = kXYLLocalString(@"Punishing");
        }
        return;
    }
}

#pragma mark - 事件处理
/// 处理事件(触发事件)
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj {
    switch (type) {
        case XYLModuleEventType_PKMatchSuccess:
            [self xyf_dealEventPKMatchSuccess:obj];
            break;
        case XYLModuleEventType_PKTimeEnd:
            [self xyf_dealWithPKTimeEnd:obj];
            break;
        default:
            break;
    }
}

- (void)xyf_dealEventPKMatchSuccess:(NSObject * __nullable)obj {
    OWLMusicRoomPKDataModel *pkModel = (OWLMusicRoomPKDataModel *)obj;
    self.xyp_leftTime = pkModel.dsb_leftTime - 1 > 0 ? pkModel.dsb_leftTime - 1 : 0;
    
    NSInteger minute = self.xyp_leftTime / 60;
    NSInteger second = self.xyp_leftTime % 60;
    self.xyp_timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
    if (self.xyp_leftTime <= 0) {
        self.xyp_punishLabel.transform = CGAffineTransformIdentity;
        if (pkModel.dsb_winAnchorData.dsb_accountID == 0) {
            self.xyp_punishLabel.text = kXYLLocalString(@"Draw");
        } else {
            self.xyp_punishLabel.text = kXYLLocalString(@"Punishing");
        }
        self.xyp_punishLabel.hidden = NO;
        self.xyp_timeBGView.hidden = YES;
    } else {
        [self xyf_addTimer];
    }
}

- (void)xyf_dealWithPKTimeEnd:(NSObject * __nullable)obj {
    OWLMusicRoomPKDataModel *pkModel = (OWLMusicRoomPKDataModel *)obj;
    [self xyf_removeTimer];
    self.xyp_timeBGView.hidden = YES;
    self.xyp_punishLabel.transform = CGAffineTransformIdentity;
    if (pkModel.dsb_winAnchorData.dsb_accountID == 0) {
        self.xyp_punishLabel.text = kXYLLocalString(@"Draw");
    } else {
        self.xyp_punishLabel.text = kXYLLocalString(@"Punishing");
    }
}

#pragma mark - 定时器
- (void)xyf_addTimer {
    if (self.xyp_timer == nil) {
        self.xyp_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(xyf_changeTime) userInfo:nil repeats:YES];
        // 将定时器添加到runloop中，否则定时器不会启动
        [[NSRunLoop mainRunLoop] addTimer:self.xyp_timer forMode:NSRunLoopCommonModes];
    }
}

/// 移除定时器
- (void)xyf_removeTimer {
    if (self.xyp_timer) {
        self.xyp_leftTime = 0;
        [self.xyp_timer invalidate];
        self.xyp_timer = nil;
    }
}

/// 改变时间
- (void)xyf_changeTime {
    
    NSInteger minute = self.xyp_leftTime / 60;
    NSInteger second = self.xyp_leftTime % 60;
    if (self.xyp_leftTime >= 10) {
        self.xyp_timeBGView.hidden = NO;
        self.xyp_punishLabel.hidden = YES;
        self.xyp_timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
        
    } else if (self.xyp_leftTime < 10 && self.xyp_leftTime >= 0) {
        self.xyp_timeBGView.hidden = YES;
        self.xyp_punishLabel.hidden = NO;
        self.xyp_punishLabel.text = [NSString stringWithFormat:@"%ld", second];
        kXYLWeakSelf
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.xyp_punishLabel.transform = CGAffineTransformMakeScale(2.7, 2.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                if (weakSelf.xyp_leftTime == 0) {
                    weakSelf.xyp_punishLabel.transform = CGAffineTransformIdentity;
                } else {
                    weakSelf.xyp_punishLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
                }
            } completion:^(BOOL finished) {
                if (weakSelf.xyp_leftTime == 0) weakSelf.xyp_punishLabel.transform = CGAffineTransformIdentity;
            }];
        }];
    } else {
        self.xyp_timeLabel.transform = CGAffineTransformIdentity;
        self.xyp_timeBGView.hidden = YES;
//        self.xyp_punishLabel.hidden = NO;
//        self.xyp_punishLabel.text = kXYLLocalString(@"Punishing");
        [self xyf_removeTimer];
    }
    
    self.xyp_leftTime -= 1;
}

#pragma mark - Lazy
- (UIImageView *)xyp_bgIV {
    if (!_xyp_bgIV) {
        _xyp_bgIV = [[UIImageView alloc] init];
        [XYCUtil xyf_loadIconImage:_xyp_bgIV iconStr:@"xyr_pk_time_bg_image"];
    }
    return _xyp_bgIV;
}

- (UIView *)xyp_timeBGView {
    if (!_xyp_timeBGView) {
        _xyp_timeBGView = [[UIView alloc] init];
        _xyp_timeBGView.hidden = YES;
    }
    return _xyp_timeBGView;
}

- (UIImageView *)xyp_vsIV {
    if (!_xyp_vsIV) {
        _xyp_vsIV = [[UIImageView alloc] init];
        _xyp_vsIV.contentMode = UIViewContentModeScaleAspectFill;
        _xyp_vsIV.clipsToBounds = YES;
        [XYCUtil xyf_loadIconImage:_xyp_vsIV iconStr:@"xyr_pk_time_vs_image"];
    }
    return _xyp_vsIV;
}

- (UILabel *)xyp_timeLabel {
    if (!_xyp_timeLabel) {
        _xyp_timeLabel = [[UILabel alloc] init];
        _xyp_timeLabel.font = kXYLGilroyMediumFont(12);
        _xyp_timeLabel.textColor = UIColor.whiteColor;
        _xyp_timeLabel.text = @"00:00";
    }
    return _xyp_timeLabel;
}

- (UILabel *)xyp_punishLabel {
    if (!_xyp_punishLabel) {
        _xyp_punishLabel = [[UILabel alloc] init];
        _xyp_punishLabel.font = kXYLGilroyMediumFont(12);
        _xyp_punishLabel.textColor = UIColor.whiteColor;
        _xyp_punishLabel.text = kXYLLocalString(@"Punishing");
        _xyp_punishLabel.textAlignment = NSTextAlignmentCenter;
        _xyp_punishLabel.hidden = YES;
    }
    return _xyp_punishLabel;
}

@end
