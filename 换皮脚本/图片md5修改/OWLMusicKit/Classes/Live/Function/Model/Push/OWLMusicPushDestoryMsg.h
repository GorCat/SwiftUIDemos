//
//  OWLMusicPushDestoryMsg.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/8.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicPushDestoryMsg : OWLBGMModuleBaseModel

/// 被销毁的房间
@property (nonatomic, strong) OWLMusicRoomDetailModel *dsb_destoryOne;
/// 新的野房间
@property (nonatomic, strong) OWLMusicRoomDetailModel *dsb_newOne;
/// 房间销毁原因
@property (nonatomic, assign) XYLModuleDestoryReasonType dsb_destroyType;

@end

NS_ASSUME_NONNULL_END
