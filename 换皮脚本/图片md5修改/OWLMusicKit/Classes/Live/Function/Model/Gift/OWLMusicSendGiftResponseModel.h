//
//  OWLMusicSendGiftResponseModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/27.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicSendGiftResponseModel : OWLBGMModuleBaseModel

/// 礼物ID
@property (nonatomic, assign) NSInteger dsb_giftID;
/// 剩余金币
@property (nonatomic, assign) NSInteger dsb_leftCoins;

@end

NS_ASSUME_NONNULL_END
