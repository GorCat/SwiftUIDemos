//// OWLBGMRoomToolsSubCell.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间工具视图弹窗 - 工具类型cell
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMRoomToolsSubCell : UICollectionViewCell

/// 类型
@property (nonatomic, assign) OWLBGMRoomToolsSubCellType xyp_type;
/// 是否开启广播
@property (nonatomic, assign) BOOL xyp_isOpenBroadcast;

@end

NS_ASSUME_NONNULL_END
