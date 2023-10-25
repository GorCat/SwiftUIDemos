//
//  OWLMusicRoomGoalModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRoomGoalModel : OWLBGMModuleBaseModel

/// 房间号
@property (nonatomic, assign) NSInteger dsb_roomId;
/// 目标描述
@property (nonatomic, copy) NSString *dsb_desc;
/// 目标收入
@property (nonatomic, assign) NSInteger dsb_goalCoin;
/// 当前收入
@property (nonatomic, assign) NSInteger dsb_currentCoin;

/// 获取当前目标进度
- (double)xyf_getCurrentProgress;

@end

NS_ASSUME_NONNULL_END
