//// OWLBGMUserDetailDataInfoSubView.h
// qianDuoDuo
//
// 
//

/**
 * @功能描述：直播间用户信息弹窗 - 数据信息视图 - 子视图
 * @创建时间：2023.2.12
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMUserDetailDataInfoSubView : UIView

/// 标题
@property (nonatomic, copy) NSString *xyp_title;
/// 数据
@property (nonatomic, assign) NSInteger xyp_num;

@end

NS_ASSUME_NONNULL_END
