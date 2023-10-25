//
//  OWLMusicFloatWindow.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define OWLMusicFloatWindowShared ([OWLMusicFloatWindow sharedInstance])

@interface OWLMusicFloatWindow : UIWindow

/// 浮窗是否显示
@property (nonatomic, assign, readonly) BOOL xyp_isShowing;

/// 返回VC
@property (nonatomic, strong, nullable) UIViewController *xyp_backVC;

+ (instancetype)sharedInstance;

/// 显示浮窗
- (void)xyf_showFloatingWindow:(UIView *)contentView startFrame:(CGRect)startFrame;

/// 隐藏浮窗
- (void)xyf_hideFloatingView;

/// 重置浮窗
- (void)xyf_resetFloatingView;

/// 返回VC
- (void)xyf_backToVC;

@end

NS_ASSUME_NONNULL_END
