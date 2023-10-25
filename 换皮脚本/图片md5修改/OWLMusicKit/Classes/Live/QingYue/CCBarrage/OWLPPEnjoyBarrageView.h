//
//  OWLPPEnjoyBarrageView.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLPPEnjoyBarrageViewDelegate <NSObject>

/** 发送Hi */
- (void) xyf_sayHi;

/** 打开送礼界面 */
- (void) xyf_openSendGiftAlert;

/** 关注当前主播 */
- (void) xyf_followHer;

/** 点击弹幕用户名字 */
- (void) xyf_clickNickname:(NSInteger)accoundId andType:(OWLMusicMessageUserType)type;

@end

@interface OWLPPEnjoyBarrageView : UIView

@property (nonatomic, weak) id<OWLPPEnjoyBarrageViewDelegate> xyp_delegate;

/**
 添加立即显示的弹幕信息
 @param model 弹幕消息数据
*/
- (void) xyf_addImmediatelyBarrageWith:(OWLMusicMessageModel *)model;

/**
 添加弹幕信息到等待显示池中
 @param model 弹幕消息数据
*/
- (void) xyf_addOneBarrageToPoolWith:(OWLMusicMessageModel *)model;

/**
 新房间RTM链接成功后开始计时操作
*/
- (void) xyf_joinRoomSuccess;

/**
 定时器操作
*/
- (void) xyf_nextSecondAction;

/**
 进入新的直播间清理数据
*/
- (void) xyf_cleanData;

/** 修改弹幕区域frame */
- (void) xyf_outsideChangeTableViewFrame;

/** 滑动到底部 */
- (void) xyf_scrollToBottom;

@end

NS_ASSUME_NONNULL_END
