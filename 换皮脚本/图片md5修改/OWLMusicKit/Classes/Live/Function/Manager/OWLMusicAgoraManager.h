//
//  OWLMusicAgoraManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

#import <Foundation/Foundation.h>
#import "ZOEPIP_PIPManager.h"
@class OWLMusicVideoContainerView;
NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicAgoraManagerDelegate <NSObject>

#pragma mark - RTMChannel相关
/// 收到RTMChannel的房间消息
- (void)xyf_roomModuleManagerRTMChannelReceiveMessage:(OWLMusicMessageModel *)message;



@end

@interface OWLMusicAgoraManager : NSObject

/// 数据源
@property (nonatomic, weak) id <OWLMusicSubManagerDataSource> dataSource;

/// 代理
@property (nonatomic, weak) id <OWLMusicAgoraManagerDelegate> delegate;

/// 视频视图
@property (nonatomic, weak) OWLMusicVideoContainerView *xyp_videoContainerView;

/// 画中画管理类
@property (nonatomic, weak) ZOEPIP_PIPManager *xyp_pipManager;

#pragma mark - Public
/// 加入房间设置视频（在加入房间接口调成功之后调用）
- (void)xyf_setupVideoAfterJoinRoom:(OWLMusicRoomDetailModel *)roomModel;

#pragma mark - RTC
/// 设置rtc参数(每次进直播间第一次调用)
- (void)xyf_configRTCEngine;

/// 加入RTC房间
- (void)xyf_enterRTCRoom:(NSString *)channelID;

/// 退出RTC房间
- (void)xyf_exitRTCRoom;

/// 切换房间
- (void)xyf_switchRTCRoom:(NSString *)channelID;

/// 重置远端的视频画面
- (void)xyf_resetRemoteView;

/// 拉取对面的视频流 并改变大小
- (void)xyf_startOtherRemoteViewAndChangeSize:(OWLMusicRoomPKDataModel *)model;

/// 停止对面的视频流 并改变大小
- (void)xyf_stopOtherRemoteViewAndChangeSize;

#pragma mark - RTMChannel
/// 初始化RTMChannel
- (void)xyf_setupRTMChannel:(NSString *)channelID todo:(NSString *)todo completion:(void(^)(BOOL success))completion;

/// 离开RTM频道
- (void)xyf_leaveRtmChannel;

/// 发送频道消息
- (void)xyf_sendMessage:(OWLMusicMessageModel *)message;

/// 发送本地消息
- (void)xyf_sendLocalMsg:(OWLMusicMessageModel *)message;

/// 获取房间内封禁消息
- (void)xyf_getChannelAttWithRoomID:(NSString *)channelID;

@end

NS_ASSUME_NONNULL_END
