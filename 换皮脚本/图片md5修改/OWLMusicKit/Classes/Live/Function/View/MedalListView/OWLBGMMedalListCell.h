//
//  OWLBGMMedalListCell.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/13.
//

/**
 * @功能描述：直播间用户奖章弹窗 - cell
 * @创建时间：2023.2.13
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>
#import "OWLMusicEventLabelModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMMedalListCell : UITableViewCell

@property (nonatomic, strong) OWLMusicEventLabelModel *xyp_model;

///选中当前行
- (void) xyf_setCellSelected:(BOOL) xy_select;

@end

NS_ASSUME_NONNULL_END
