//
//  OWLPPReceiveGiftCell.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OWLPPReceiveGiftModel;

@interface OWLPPReceiveGiftCell : UIView

/**
 填充数据
 @param msgModel 礼物数据
 */
- (void)xyf_configGiftData:(OWLPPReceiveGiftModel *)msgModel;

/**
 显示连击特效
 */
//- (void) xyf_showComboEffect;

/**
 移动显示礼物
 */
- (void) xyf_moveToDisplayGift;

/**
 移出当前显示礼物
 */
- (void) xyf_moveToHideGift;

@end

NS_ASSUME_NONNULL_END
