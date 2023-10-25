//
//  OWLPPGiftPublicityView.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLPPGiftPublicityView : UIView

/**
 新增礼物消息显示
*/
- (void) xyf_appendOneGiftMessage:(OWLMusicMessageModel *) msg;

/**
 定时器
*/
- (void) xyf_nextSecond;

/**
 进入新的直播间清理数据
*/
- (void) xyf_cleanData;

@end

NS_ASSUME_NONNULL_END
