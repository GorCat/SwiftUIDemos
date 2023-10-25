//
//  OWLPPGiftChooseView.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLPPGiftChooseViewDelegate <NSObject>

/** 弹出充值弹窗 */
- (void) xyf_showRechargeAlert;

/** 前去svip页面 */
- (void) xyf_jumpToSvip;

/** 点击礼物 */
- (void) xyf_clickedOneGift:(OWLMusicGiftInfoModel *) gift;

/** 弹出礼物是的弹窗y xytodo */
- (void) xyf_giftAlertContenYChange:(double) xyp_y;

@end

/** 礼物展示列表 */
@interface OWLPPGiftChooseView : UIView

@property (nonatomic, weak) id<OWLPPGiftChooseViewDelegate> xyp_delegate;

/**
 填充数据
 @param dataArray banner数组
 */
- (void) xyf_configGGData:(NSArray *) dataArray;

/** 刷新所有collectionView */
- (void) xyf_refreshAllCollectionView;

/** 弹出礼物选择弹窗 */
- (void) xyf_alertChooseGift;

/** 定时器 */
- (void) xyf_nextSecond;

/** 礼物发送成功后转换 */
- (OWLMusicMessageModel *) xyf_getMessageModelWith:(OWLMusicGiftInfoModel *) gift andBlindId:(NSInteger) blindId;

@end

NS_ASSUME_NONNULL_END
