//
//  OWLMusicEventLabelModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/22.
//

/**
 * @功能描述：直播间用户模型 - 活动标签模型
 * @创建时间：2023.2.22
 * @创建人：许琰
 */

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicEventLabelModel : OWLBGMModuleBaseModel

/// 图标
@property (nonatomic, copy) NSString *dsb_labelUrl;
/// 标题
@property (nonatomic, copy) NSString *dsb_labelTitle;
/// 描述
@property (nonatomic, copy) NSString *dsb_labelTip;
/// 过期时间（从UTC+0时区 2017-01-01 00:00:00 开始到现在的秒数）
@property (nonatomic, assign) NSInteger dsb_leftTime;
/// 宽
@property (nonatomic, assign) NSInteger dsb_width;
/// 高
@property (nonatomic, assign) NSInteger dsb_height;
/// 序号
@property (nonatomic, assign) NSInteger dsb_index;

@end

NS_ASSUME_NONNULL_END
