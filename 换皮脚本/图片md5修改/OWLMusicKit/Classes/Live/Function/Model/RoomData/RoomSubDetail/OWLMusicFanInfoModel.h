//
//  OWLMusicFanInfoModel.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/11.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicFanInfoModel : OWLBGMModuleBaseModel

/// 是否是铁粉
@property (nonatomic, assign) BOOL dsb_isFan;
/// 铁粉图标
@property (nonatomic, copy) NSString *dsb_fanIconUrl;
/// 是否买过铁粉
@property (nonatomic, assign) BOOL dsb_isGainedFan;

@end

NS_ASSUME_NONNULL_END
