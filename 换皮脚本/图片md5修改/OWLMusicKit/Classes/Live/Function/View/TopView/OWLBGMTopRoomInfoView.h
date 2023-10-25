//
//  OWLBGMTopRoomInfoView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间顶部房间信息视图
 * @创建时间：2023.2.9
 * @创建人：许琰
 * @备注：顶部 【主播信息 + 观众列表 + 房间主题 + 目标金额 + 房间ID】
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMTopRoomInfoView : OWLBGMModuleBaseView

/// 列表
@property (nonatomic, strong) NSArray *xyp_audienceList;

@end

NS_ASSUME_NONNULL_END
