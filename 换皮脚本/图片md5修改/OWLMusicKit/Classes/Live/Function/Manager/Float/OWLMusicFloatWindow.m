//
//  OWLMusicFloatWindow.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/3.
//

#import "OWLMusicFloatWindow.h"
#import "OWLMusicFloatWindowVC.h"
#import "OWLMusicInsideManager.h"

@interface OWLMusicFloatWindow ()

/// 关闭按钮
@property (nonatomic, strong) UIButton *xyp_closeButton;
/// 浮窗容器
@property (nonatomic, strong) UIView *xyp_contentView;
/// 浮窗是否显示
@property (nonatomic, assign) BOOL xyp_isShowing;
/// 内容视图
@property (nonatomic, weak) UIView *xyp_videoView;

@end

@implementation OWLMusicFloatWindow

+ (instancetype)sharedInstance {
    static OWLMusicFloatWindow *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OWLMusicFloatWindow alloc] initWithFrame:CGRectMake(0, 0, kXYLScreenWidth, kXYLScreenHeight)];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar - 1;
        OWLMusicFloatWindowVC *vc = [[OWLMusicFloatWindowVC alloc] init];
        self.rootViewController = vc;
        [self addSubview:self.xyp_contentView];
        self.hidden = YES;
        [self xyf_observeNotification:xyl_live_float_window_change_size];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.xyp_contentView.bounds, [self.xyp_contentView convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }
    return NO;
}

#pragma mark - 浮窗逻辑
/// 显示浮窗
- (void)xyf_showFloatingWindow:(UIView *)contentView startFrame:(CGRect)startFrame {
    if (self.xyp_isShowing) { return; }
    
    [self xyf_setFloatingView:contentView startFrame:startFrame];
    self.hidden = NO;
    self.xyp_isShowing = YES;
}

/// 设置浮窗
- (void)xyf_setFloatingView:(UIView *)view startFrame:(CGRect)startFrame {
    [self.xyp_contentView xyf_removeAllSubviews];
    [self.xyp_contentView addSubview:view];
    [self.xyp_contentView addSubview:self.xyp_closeButton];
    [self.xyp_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(40);
        make.top.equalTo(self.xyp_contentView).offset(-4);
        make.trailing.equalTo(self.xyp_contentView).offset(4);
    }];
    self.xyp_contentView.frame = startFrame;
    view.frame = self.xyp_contentView.bounds;
    self.xyp_videoView = view;
}

/// 隐藏浮窗
- (void)xyf_hideFloatingView {
    self.xyp_isShowing = NO;
    self.hidden = YES;
    
    [self.xyp_contentView xyf_removeAllSubviews];
}

/// 重置浮窗
- (void)xyf_resetFloatingView {
    [self xyf_hideFloatingView];
    self.xyp_backVC = nil;
    self.xyp_isShowing = NO;
}

#pragma mark - Private
/// 返回VC
- (void)xyf_backToVC {
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingMiniReturnRoom];
    /// 隐藏悬浮窗
    [self xyf_hideFloatingView];
    /// 如果vc不存在了 就重置悬浮窗
    if (!self.xyp_backVC) {
        [self xyf_resetFloatingView];
        return;
    }
    /// 返回到上一个vc
    [self xyf_backToLiveVC];
}

- (void)xyf_backToLiveVC {
    UIViewController *topVC = OWLJConvertToolShared.xyf_getCurrentVC;
    if (topVC.presentingViewController && !topVC.navigationController) { /// 模态
        [topVC.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self xyf_backToLiveVC];
        }];
    } else if ([[topVC.navigationController viewControllers] containsObject:self.xyp_backVC]) {
        [topVC.navigationController popToViewController:self.xyp_backVC animated:YES];
    } else {
        
        UINavigationController *currentNav = topVC.navigationController;
        if (!currentNav) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.xyp_backVC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            UINavigationController *cNav = [XYCUtil xyf_getLastedPushedViewController].navigationController;
            [cNav presentViewController:nav animated:YES completion:nil];
        } else {
            self.xyp_backVC.hidesBottomBarWhenPushed = YES;
            [currentNav pushViewController:self.xyp_backVC animated:YES];
        }
    }
}

/// 检查内容视图frame有没有超出边界
- (void)xyf_checkContentViewFrame {
//    NSLog(@"xytest %f",CGRectGetMaxY(self.xyp_contentView.frame));
    if (CGRectGetMaxY(self.xyp_contentView.frame) > kXYLScreenWidth) {
        self.xyp_contentView.xyp_x = kXYLScreenWidth - self.xyp_contentView.xyp_w;
    }
}

#pragma mark - Action
- (void)xyf_closeButtonAction {
    /// 埋点
    [OWLMusicTongJiTool xyf_thinkingMiniCloseRoom];
    /// 关闭房间
    [OWLMusicInsideManagerShared xyf_insideCloseLivePage:YES];
}

- (void)xyf_tapAction {
    [self xyf_backToVC];
}

- (void)xyf_panAction:(UIPanGestureRecognizer *)pan {
    CGFloat margin = 0;
    switch (pan.state) {
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [pan translationInView:self];
            CGPoint center = self.xyp_contentView.center;
            center.x += translation.x;
            center.y += translation.y;
            self.xyp_contentView.center = center;
            
            UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
            CGFloat minX = edgeInsets.left;
            CGFloat minY = kXYLStatusBarHeight + edgeInsets.top;
            CGFloat maxX = self.xyp_w - self.xyp_contentView.xyp_w + edgeInsets.right;
            CGFloat maxY = self.xyp_h - self.xyp_contentView.xyp_h - margin + edgeInsets.bottom;
            
            CGRect frame = self.xyp_contentView.frame;
            frame.origin.x = frame.origin.x > maxX ? maxX : frame.origin.x;
            frame.origin.x = frame.origin.x < minX ? minX : frame.origin.x;
            frame.origin.y = frame.origin.y > maxY ? maxY : frame.origin.y;
            frame.origin.y = frame.origin.y < minY ? minY : frame.origin.y;
            self.xyp_contentView.frame = frame;
            
            [pan setTranslation:CGPointZero inView:self];
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            if (self.xyp_contentView.center.x > kXYLScreenWidth / 2.0) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.xyp_contentView.xyp_x = kXYLScreenWidth - margin - self.xyp_contentView.xyp_w;
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    self.xyp_contentView.xyp_x = margin;
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification
- (void)xyf_handleNotification:(NSNotification *)notification {
    [super xyf_handleNotification:notification];
    if ([notification.name isEqualToString:xyl_live_float_window_change_size]) {
        self.xyp_contentView.xyp_size = self.xyp_videoView.xyp_size;
        [self xyf_checkContentViewFrame];
    }
}

#pragma mark - Lazy
- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
        _xyp_contentView.layer.masksToBounds = YES;
        _xyp_contentView.layer.cornerRadius = 5;
        [_xyp_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_tapAction)]];
        [_xyp_contentView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(xyf_panAction:)]];
    }
    return _xyp_contentView;
}

- (UIButton *)xyp_closeButton {
    if (!_xyp_closeButton) {
        _xyp_closeButton = [[UIButton alloc] init];
        [_xyp_closeButton setImage:[XYCUtil xyf_getIconWithName:@"xyr_window_float_close_icon"] forState:UIControlStateNormal];
        [_xyp_closeButton addTarget:self action:@selector(xyf_closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_closeButton;
}

@end
