//
//  OWLMusicTakeHerAlert.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicTakeHerAlert : UIView

@property (nonatomic, copy) void(^xyp_sureTakeHer)(void);

@property (nonatomic, copy) void(^xyp_dismissBlock)(void);

@property (nonatomic, strong, readonly) OWLMusicGiftInfoModel *xyp_giftModel;

/// 初始化
/// @param xyp_gModel 带走礼物
/// @param xyp_showView 父视图
/// @param xyp_coin  带走私聊金币数
/// @param xyp_aAvatar 主播头像
/// @param xyp_uAvatar 用户头像
/// @param xyp_takeHer 带走回调
/// @param xyp_dismissBlock 消失回调
+ (instancetype)xyf_showTakeHerAlertViewWithGift:(OWLMusicGiftInfoModel *)xyp_gModel
                                      targetView:(UIView *)xyp_showView
                                     andChatCoin:(NSInteger)xyp_coin
                                 andAnchorAvatar:(NSString *)xyp_aAvatar
                                   andUserAvatar:(NSString *)xyp_uAvatar
                                     andSureTake:(void(^)(void))xyp_takeHer
                                 andDismissBlock:(void(^)(void))xyp_dismissBlock;

/**
 更新带走礼物数据
 @param xyp_gModel 带走礼物
 */
- (void)xyf_updateTakeGiftData:(OWLMusicGiftInfoModel *)xyp_gModel;

/** 弹出带走弹窗 */
- (void)xyf_alertPrivateChat;

/** 消失 */
- (void)xyf_dismissView;

@end

NS_ASSUME_NONNULL_END
