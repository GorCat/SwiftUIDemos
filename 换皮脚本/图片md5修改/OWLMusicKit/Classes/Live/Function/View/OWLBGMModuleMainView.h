//
//  OWLBGMModuleMainView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/10.
//

/**
 * @功能描述：直播间主页面
 * @创建时间：2023.2.10
 * @创建人：许琰
 * @备注：没有必要在每个cell中都创建这么多元素。所以采用 一个VC持有一个主页面的方案，在滑动的时候添加移除，在请求到数据之后更新【滑动+控制层+关闭按钮等ui】
 */

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleMainView : OWLBGMModuleBaseView

@property (nonatomic, weak) id <OWLBGMModuleBaseViewDelegate> mainDelegate;

/// 更新观众列表
- (void)xyf_updateMemberList:(NSMutableArray *)memberList;

/// 更新PK数据
- (void)xyf_updatePKData:(nullable OWLMusicRoomPKDataModel *)pkModel;

/// 键盘弹起更新消息frame
- (void)xyf_updateFrameWhenKeyboardChanged:(CGFloat)bottomHeight changeType:(XYLModuleChangeInputViewHeightType)changeType;

/// 礼物弹窗弹起更新礼物弹幕frame
- (void)xyf_updateGiftWhenPopGiftView:(CGFloat)viewY;

/// 送礼
- (void)xyf_receiveGiftMessage:(OWLMusicGiftInfoModel *)model;

/// 清空礼物
- (void)xyf_removeGift;

@end

NS_ASSUME_NONNULL_END
