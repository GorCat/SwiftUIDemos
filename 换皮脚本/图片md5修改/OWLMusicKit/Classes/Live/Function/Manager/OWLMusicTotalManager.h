//
//  OWLMusicTotalManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//


/**
 * @功能描述：直播间总管理类
 * @创建时间：2023.2.16
 * @创建人：许琰
 * @备注：被直播间VC持有，其他的子管理类都在这个类里面【数据 + 点击事件 + 声网 等管理类】
 */

#import <Foundation/Foundation.h>
#import "OWLBGMModuleMainView.h"
#import "OWLMusicVideoContainerView.h"
#import "ZOEPIP_PIPManager.h"

@class XYCModulePushMessageModel, OWLMusicBottomInputView, OWLBGMModuleVC, OWLMusicBroadcastModel;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicTotalManagerDelegate <NSObject>

/// 刷新列表
- (void)xyf_totalManagerRefreshRoomList;

/// 插入或删除cell
- (void)xyf_totalManagerOperateData:(NSInteger)index isDelete:(BOOL)isDelete;

/// 进入对方直播间
- (void)xyf_totalManagerEnterOtherRoom:(BOOL)isAlreadyHasRoom fromWay:(XYLOutDataSourceEnterRoomType)fromWay;

/// 显示引导弹窗
- (void)xyf_totalManagerShowGuideView;

/// 操控滑动手势
- (void)xyf_totalManagerChangePopGesture:(BOOL)isEnable;

/// 更新当前主播ID
- (void)xyf_totalManagerUpdateCurrentHostID:(NSInteger)hostID;

@end


@interface OWLMusicTotalManager : NSObject

#pragma mark - 属性
#pragma mark Setter
/// 目标VC（也就是直播间VC）
@property (nonatomic, strong, nullable) UIViewController *xyp_targetVC;
/// 目标视图（也就是直播间VC.view）
@property (nonatomic, weak) UIView *xyp_targetView;
/// 输入框
@property (nonatomic, weak) OWLMusicBottomInputView *xyp_inputView;
/// 代理
@property (nonatomic, weak) id <OWLMusicTotalManagerDelegate> delegate;
/// 是否需要关闭 (在viewDidDisappear的时候 判断是否需要显示小窗，yes就直接关闭直播间 no就显示小窗)
@property (nonatomic, assign) BOOL xyp_isClose;
/// 画中画管理类
@property (nonatomic, weak) ZOEPIP_PIPManager *xyp_pipManager;

#pragma mark Getter
/// 当前列表
@property (nonatomic, strong) NSMutableArray *xyp_dataSourceRoomList;
/// 当前下标
@property (nonatomic, assign) NSInteger xyp_currentIndex;
/// 当前房间
@property (nonatomic, assign) OWLMusicRoomTotalModel *xyp_currentTotalModel;
/// 点击事件视图
@property (nonatomic, strong, readonly) OWLBGMModuleMainView *xyp_controlView;
/// 视频视图
@property (nonatomic, strong, readonly) OWLMusicVideoContainerView *xyp_videoContainerView;

#pragma mark - 初始化
/// 初始化管理类
- (void)xyf_setupManager;

/// 进入房间（ViewDidLoad调用）
- (void)xyf_joinRoomWithConfigModel:(OWLMusicEnterConfigModel *)configModel;

#pragma mark - 切换房间
/// 滑动切换房间
- (void)xyf_switchChangeRoom:(NSInteger)index;

/// 滑动加入房间
- (void)xyf_switchJoinRoomWithIndex:(NSInteger)index fromWay:(XYLOutDataSourceEnterRoomType)fromWay;

/// 点击横幅进入其他房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model;

#pragma mark - 关闭相关
/// 关闭房间或最小化
- (void)xyf_closeOrFloatWindow:(BOOL)isUserClose;

#pragma mark - 最小化相关
/// 页面最小化
- (void)xyf_changeVCToFloatWindow;

/// 获取小窗状态下的视图
- (UIView *)xyf_fetchFloatingView;

#pragma mark - 退出直播间相关
/// 退出直播间
- (void)xyf_exitLiveRoom:(BOOL)isNeedPopVC;

/// 退出当前页面
- (void)xyf_popLiveVC;

#pragma mark - 处理推送消息
/// 处理推送消息
- (void)xyf_handleOpcode3Data:(XYCModulePushMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
