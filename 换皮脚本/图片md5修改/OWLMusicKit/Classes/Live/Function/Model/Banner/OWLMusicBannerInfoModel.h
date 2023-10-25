//
//  OWLMusicBannerInfoModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/24.
//

#import "OWLBGMModuleBaseModel.h"
@class OWLMusicBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicBannerInfoModel : OWLBGMModuleBaseModel

@property (nonatomic, strong) NSArray <OWLMusicBannerModel *> *dsb_bannerList;

@end

@interface OWLMusicBannerModel : OWLBGMModuleBaseModel

/// 图片地址
@property (nonatomic, copy) NSString *dsb_imageUrl;
/// 跳转地址
@property (nonatomic, copy) NSString *dsb_jumpAddr;
/// 类型
@property (nonatomic, assign) NSInteger dsb_type;
/// 额外数据
@property (nonatomic, copy) NSString *dsb_otherData;
/// 名称
@property (nonatomic, copy) NSString *dsb_name;

@end

NS_ASSUME_NONNULL_END
