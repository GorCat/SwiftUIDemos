//
//  OWLMusicGiftConfigModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/24.
//

#import "OWLBGMModuleBaseModel.h"
@class OWLMusicGiftInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicGiftConfigModel : OWLBGMModuleBaseModel

/// 标题
@property (nonatomic, copy) NSString *dsb_title;
/// 标签
@property (nonatomic, copy) NSString *dsb_iconUrl;
/// 礼物
@property (nonatomic, strong) NSArray <OWLMusicGiftInfoModel *> *dsb_giftList;
/// 1：一次性展示，2：永久展示
@property (nonatomic, assign) NSInteger dsb_iconType;
/// 此类礼物可设置私聊带走
@property (nonatomic, assign) BOOL dsb_canBePrivateGift;

@end

@interface OWLMusicGiftListModel : OWLBGMModuleBaseModel

@property (nonatomic, strong) NSArray <OWLMusicGiftInfoModel *> *dsb_giftList;

@end

@interface OWLMusicGiftInfoModel : OWLBGMModuleBaseModel

/// 礼物ID
@property (nonatomic, assign) NSInteger dsb_giftID;
/// 价格
@property (nonatomic, assign) NSInteger dsb_giftCoin;
/// 原价
@property (nonatomic, assign) NSInteger dsb_giftOriginCoin;
/// 礼物图标
@property (nonatomic, copy) NSString *dsb_iconImageUrl;
/// 礼物name
@property (nonatomic, copy) NSString *dsb_giftName;
/// svg文件地址
@property (nonatomic, copy) NSString *dsb_gifUrl;
/// 是否是盲盒
@property (nonatomic, assign) BOOL dsb_isBlindGift;
/// 相芯Bundle URL
@property (nonatomic, copy) NSString *dsb_bundleUrl;
/// 相芯Bundle播放时长（秒）
@property (nonatomic, assign) NSInteger dsb_bundleDuration;
/// 变声器参数
@property (nonatomic, copy) NSString *dsb_voiceChangeConfig;
/// 连击参数
@property (nonatomic, assign) NSInteger dsb_comboNum;
/// 连击图标
@property (nonatomic, copy) NSString *dsb_comboIconImage;

@end

NS_ASSUME_NONNULL_END
