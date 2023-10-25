//
//  XYCNotificationDef.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#ifndef XYCNotificationDef_h
#define XYCNotificationDef_h

#pragma mark - 内部接受的通知（外部不用管）
/// 更新用户金币 携带数字 @(userCoins)
#define xyl_user_update_coins @"xyl_user_update_coins"

/*
 用户关注或取关主播
 携带字典 @{    kXYLNotificationAccountIDKey : @(主播ID),
            kXYLNotificationFollowStateKey : @(followState 最终关注状态的bool值) }
 */
#define xyl_user_operate_follow_anchor @"xyl_user_operate_follow_anchor"

/*
 用户拉黑或者取消拉黑主播
 携带字典 @{    kXYLNotificationAccountIDKey : @(主播ID),
             kXYLNotificationBlockStateKey : @(blockState 最终拉黑状态的bool值) }
 */
#define xyl_user_operate_block_anchor @"xyl_user_operate_block_anchor"

/// 直播间恢复 携带主播ID
#define xyl_live_room_resume @"xyl_live_room_resume"

/// 清除房间信息通知（用于移除各种视图）
#define xyl_live_clear_room_info @"xyl_live_clear_room_info"

/// 通知浮窗改变大小
#define xyl_live_float_window_change_size @"xyl_live_float_window_change_size"

/// 充值成功
#define xyl_module_recharge_success @"xyl_module_recharge_success"

/// 买svip
#define xyl_module_buy_svip_success @"xyl_module_buy_svip_success"

/*
 买铁粉成功
 携带字典 @{    kXYLNotificationAccountIDKey : @(主播ID),
              kXYLNotificationFanInfoKey : 铁粉信息字典 }
 */
#define xyl_module_buy_fan_success @"xyl_module_buy_fan_success"

/// 移除banner
#define xyl_module_remove_banner @"xyl_module_remove_banner"

/// 改变应用内悬浮窗是否开启状态
#define xyl_module_update_window_inapp_isOpen @"xyl_module_update_window_inapp_isOpen"

/// 改变应用外画中画是否开启状态
#define xyl_module_update_window_outapp_isOpen @"xyl_module_update_window_outapp_isOpen"

/// 用户成功转了1金币转盘
#define xyl_module_success_open_onecoin_turntable @"xyl_module_success_open_onecoin_turntable"

/// 刷新私聊按钮（fix 快速滑动然后再滑到同一个房间中 私聊按钮图片没了）
#define xyl_module_refresh_private_image @"xyl_module_refresh_private_image"

#pragma mark - 通知携带信息的名称
/// 账号id
#define kXYLNotificationAccountIDKey @"kXYLNotificationAccountIDKey"
/// 关注状态
#define kXYLNotificationFollowStateKey @"kXYLNotificationFollowStateKey"
/// 拉黑状态
#define kXYLNotificationBlockStateKey @"kXYLNotificationBlockStateKey"
/// 用户金币
#define kXYLNotificationCoinsKey @"kXYLNotificationCoinsKey"
/// 铁粉信息
#define kXYLNotificationFanInfoKey @"kXYLNotificationFanInfoKey"
/// 一金币转盘状态
#define kXYLNotificationOneCoinStateKey @"kXYLNotificationOneCoinStateKey"
/// 内购优惠状态
#define kXYLNotificationPayDiscountStateKey @"kXYLNotificationPayDiscountStateKey"

#endif /* XYCNotificationDef_h */
