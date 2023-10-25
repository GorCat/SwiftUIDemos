//
//  OWLMusicDataSourceManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicDataSourceManagerDelegate <NSObject>

/// 需要刷新列表（tableview reloadData）
- (void)xyf_liveDataSourceManagerRefreshList;

/// 更新当前房间详情模型（在此处刷新控制层模型）
- (void)xyf_liveDataSourceManagerUpdateCurrentRoomDetailModel;

/// 插入或删除列表某个数据
- (void)xyf_liveDataSourceManagerOperateData:(NSInteger)index isDelete:(BOOL)isDelete;

/// 跳转到对面直播间
/// - Parameters:
///   - isAlreadyHasRoom: 当前列表中是否已经有这个数据
///   - fromWay: 点击来源
- (void)xyf_liveDataSourceManagerEnterOtherRoom:(BOOL)isAlreadyHasRoom
                                        fromWay:(XYLOutDataSourceEnterRoomType)fromWay;

/// 刷新恢复的房间（如果恢复的房间为当前房间才会走这个回调）
- (void)xyf_liveDataSourceManagerResumeRoom:(OWLMusicRoomTotalModel *)resumeModel isNeedCleanPK:(BOOL)isNeedCleanPK;

/// 刷新当前主播ID
- (void)xyf_liveDataSourceManagerUpdateCurrentAnchorID:(NSInteger)anchorID;

@end

@interface OWLMusicDataSourceManager : NSObject

#pragma mark - 属性
/// 代理
@property (nonatomic, weak) id <OWLMusicDataSourceManagerDelegate> delegate;

/// 数据源
@property (nonatomic, weak) id <OWLMusicSubManagerDataSource> dataSource;

/// 当前房间列表（tableview列表中的数据）
@property (nonatomic, strong, readonly) NSMutableArray *xyp_currentRoomList;

/// 当前房间的模型
@property (nonatomic, strong, readonly) OWLMusicRoomTotalModel *xyp_currentModel;

/// 当前房间的下标
@property (nonatomic, assign, readonly) NSInteger xyp_currentIndex;

#pragma mark - 方法
/// 初始化数据管理类（只在进入vc时调用）
- (void)xyf_setupDataManagerWithConfigModel:(OWLMusicEnterConfigModel *)configModel;

/// 更新房间详情信息（只在joinRoom接口调用）
- (void)xyf_updateRoomDetailInfoModel:(OWLMusicRoomDetailModel *)model;

/// 更新房间异常状态（只在joinRoom接口失败调用）
- (void)xyf_updateRoomUnnormalState:(BOOL)isUnnormal anchorID:(NSInteger)anchorID;

/// 请求列表
- (void)xyf_requestRoomList:(BOOL)isUGCRoom;

/// 滑动停止之后更新列表
- (void)xyf_refreshListAfterScrollStop:(NSInteger)currentIndex;

/// 滑动更新当前下标
- (void)xyf_switchChangeCurrentIndex:(NSInteger)index fromWay:(XYLOutDataSourceEnterRoomType)fromWay;

/// 添加房间
- (void)xyf_addRoom:(OWLMusicRoomDetailModel *)room;

/// 删除房间
- (void)xyf_deleteRoom:(OWLMusicRoomDetailModel *)room;

/// 恢复房间
- (void)xyf_resumeRoom:(OWLMusicRoomDetailModel *)room;

/// 进入对方房间
- (void)xyf_enterOtherRoom;

/// 通过横幅进入其他房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model;

@end

NS_ASSUME_NONNULL_END
