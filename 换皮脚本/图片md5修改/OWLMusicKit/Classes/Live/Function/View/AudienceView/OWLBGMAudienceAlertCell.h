//// OWLBGMAudienceAlertCell.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间观众列表弹窗 - 观众cell
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMAudienceAlertCell : UITableViewCell

/// 用户模型
@property (nonatomic, strong) OWLMusicMemberModel *xyp_model;

/// 排序
@property (nonatomic, assign) NSInteger xyp_index;

@end

NS_ASSUME_NONNULL_END
