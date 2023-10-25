//
//  OWLMusicSubManagerDataSource.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/22.
//

/**
 * @功能描述：直播间子管理类的数据源
 * @创建时间：2023.2.22
 * @创建人：许琰
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicSubManagerDataSource <NSObject>

/// 获取观众列表
- (NSMutableArray *)xyf_subManagerGetMemberList;

/// 获取当前房间ID
- (NSInteger)xyf_subManagerGetCurrentRoomID;

/// 获取当前房间模型
- (OWLMusicRoomTotalModel *)xyf_subManagerGetCurrentRoomModel;

/// 当前是否被禁言
- (BOOL)xyf_subManagerGetIsMute;

/// 是否显示两个视图
- (BOOL)xyf_subManagerIsShowTwoPeople;

@end

NS_ASSUME_NONNULL_END
