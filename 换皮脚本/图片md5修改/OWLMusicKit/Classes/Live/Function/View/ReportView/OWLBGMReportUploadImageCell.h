//// OWLBGMReportUploadImageCell.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间举报弹窗 - 上传图片cell
 * @创建时间：2023.2.11
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMReportUploadImageCell : UICollectionViewCell

@property (nonatomic, copy) void(^xyp_deleltePicture)(void);

/** 填充图片 */
- (void)xyf_setupPicture:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END
