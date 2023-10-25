//
//  OWLBGMModuleVC.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import <UIKit/UIKit.h>
@class XYCModulePushMessageModel;
@class OWLMusicEnterConfigModel;
@class OWLMusicRoomTotalModel, OWLMusicBroadcastModel;
NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleVC : UIViewController

#pragma mark - Readonly
/// 当前主播ID(fixbug 极限情况下调两次进入方法，进入方法没有拦住的bug
/// 使用：在初始化时就赋值，在更换房间时，就会维护赋值。目前只在进入方法中拦截判断使用
@property (nonatomic, assign) NSInteger xyp_compairCurrentHostID;

#pragma mark - Getter
/// 进入直播间配置模型
@property (nonatomic, strong) OWLMusicEnterConfigModel *xyp_configModel;

/// 当前主播ID(项目中都用get方法 在数据管理类 =>获取当前模型 => 拿到当前主播ID)
@property (nonatomic, assign) NSInteger xyp_currentAnchorID;

/// 当前房间是否是UGC房间
@property (nonatomic, assign) BOOL xyp_isUGC;

/// 当前房间模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_currentTotalModel;

/// 初始化
- (instancetype)initWithAnchorID:(NSInteger)anchorID;

/// 处理推送消息
- (void)xyf_handleOpcode3Data:(XYCModulePushMessageModel *)model;

/// 关闭房间或者最小化房间
- (void)xyf_closeSelfOrChangeFloatState;

/// 关闭直播间
- (void)xyf_closeSelf:(BOOL)isNeedPopVC;

/// 仅pop直播页面
- (void)xyf_onlyPopSelf;

/// 控制列表能否滑动
- (void)xyf_tableViewIsEnable:(BOOL)isEnable;

/// 点击横幅进入其他房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model;

/// 改变画中画
- (void)xyf_changePIPOpenState:(BOOL)isOpen;

@end

NS_ASSUME_NONNULL_END
