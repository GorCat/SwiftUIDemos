//
//  OWLPPPairShowView.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 配对成功动画展示页面 */
@interface OWLPPPairShowView : UIView

@property (nonatomic ,copy) void(^xyp_playEndPair)(void);

/**
 播放匹配成功动画
 @param xyp_ancAvatar 主播头像
 @param xyp_uAvatar 用户头像
 @param xyp_ancName 主播昵称
 @param xyp_uName 用户昵称
 @param xyp_mine 是否是自己配对成功
*/
- (void) xyf_preparePlaySvgWithAncAvatar:(NSString *) xyp_ancAvatar andUAvatar:(NSString *) xyp_uAvatar andAncName:(NSString *) xyp_ancName andUName:(NSString *) xyp_uName andIsMine:(BOOL) xyp_mine;

/**
 播放完成目标svg动画
 @param xyp_name 动画类型1：目标昵称
*/
- (void) xyf_preparePlaySvgWithShowName:(NSString *) xyp_name;

/**
 播放进入房间svg动画
 @param xyp_avatar 头像
*/
- (void) xyf_preparePlayJoinRoomSvgWithAvatar:(NSString *) xyp_avatar andName:(NSString *) xyp_name;

@end

NS_ASSUME_NONNULL_END
