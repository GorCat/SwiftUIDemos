//
//  OWLMusicInsideManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/10.
//

#import <Foundation/Foundation.h>
#import "OWLMusicBottomFunctionManager.h"
#import "OWLMusicGamePopView.h"
@class OWLBGMModuleVC, XYCModulePushMessageModel;
NS_ASSUME_NONNULL_BEGIN

#define OWLMusicInsideManagerShared ([OWLMusicInsideManager shareInstance])

@interface OWLMusicInsideManager : NSObject

/// 是否需要刷新首页列表
@property (nonatomic, assign) BOOL xyp_isNeedRefreshHomeList;

/// vc
@property (nonatomic, strong, nullable) OWLBGMModuleVC *xyp_vc;

/// 当前房间模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_currentModel;

/// 当前房间ID
@property (nonatomic, assign) NSInteger xyp_currentRoomID;

/// 当前房间ID
@property (nonatomic, assign) NSInteger xyp_hostID;

/// 当前是否是阿语
@property (nonatomic, assign) BOOL xyp_isRTL;

/// 当前语言
@property (nonatomic, strong) NSString *xyp_currentLanguage;

/// 是否在本次启动app中充值过
@property (nonatomic, assign) BOOL xyp_hasRechargeInThisLife;

/// 是否需要自动展示充值弹窗
@property (nonatomic, assign) BOOL xyp_shouldShowAutoDiscountView;

/// -1：停止
@property (nonatomic, assign) NSInteger comboing;

/// 是否支持新进场特效
@property (nonatomic, assign) BOOL xyp_isShowNewEnterEffect;

/// 是否正在带走
@property (nonatomic, assign) BOOL xyp_isTakingAnchor;

/// 是否用主包的svg路径
@property (nonatomic, assign) BOOL xyp_useMainSVGPath;

/// 游戏视图
@property (nonatomic, strong) OWLMusicGamePopView * _Nullable xyp_gamePopView;

/// 底部功能管理类
@property (nonatomic, strong) OWLMusicBottomFunctionManager *xyp_bottomManager;

/// 是否有画中画功能
@property (nonatomic, assign) BOOL xyp_hasPIPFunc;

/// 应用内悬浮窗功能是否开启
@property (nonatomic, assign) BOOL xyp_isOpenWindowInApp;

/// 应用外画中画功能是否开启
@property (nonatomic, assign) BOOL xyp_isOpenWindowOutApp;

#pragma mark - 单例
+ (instancetype)shareInstance;

#pragma mark - 处理外部推送
/// 处理外部推送
- (void)xyf_insideHandleOpcode3Data:(XYCModulePushMessageModel *)model;

#pragma mark - 关闭房间
/// 关闭或最小化
- (void)xyf_insideCloseOrFloatWindow;

/// 关闭房间
- (void)xyf_insideCloseLivePage:(BOOL)isPopVC;

/// 仅返回页面
- (void)xyf_insideOnlyPopLiveVC;

#pragma mark - 其他方法
/// 控制列表是否能滑动
- (void)xyf_tableViewCanScroll:(BOOL)scrollEnabled;

/// 移除连击视图
- (void)xyf_removeComboView;

#pragma mark - Getter
/// 是否充值过
- (BOOL)xyf_hasRecharge;

@end

NS_ASSUME_NONNULL_END
