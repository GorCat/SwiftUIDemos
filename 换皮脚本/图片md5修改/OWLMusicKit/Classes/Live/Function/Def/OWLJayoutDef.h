//
//  OWLJayoutDef.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/14.
//

/**
 * @功能描述：直播间视图布局定义
 * @创建时间：2023.2.14
 * @创建人：许琰
 */

#ifndef OWLJayoutDef_h
#define OWLJayoutDef_h

#pragma mark - 控制层UI
#pragma mark 顶部视图
/// 房间信息视图顶部距离
#define kXYLRoomInfoHeaderViewTopMargin (kXYLStatusBarHeight + 5)
/// 顶部房间信息视图高度
#define kXYLRoomInfoHeaderViewHeight (62)
/// 房间详情宽度
#define kXYLDetailRoomWidth (104)
/// 转盘宽高
#define kXYLRandomTableSmallWH (60)
/// 转盘y
#define kXYLRandomTableSmallY (kXYLRoomInfoHeaderViewTopMargin + kXYLRoomInfoHeaderViewHeight + 15)

#pragma mark PK
/// PK视频顶部间距
#define kXYLPKVideoTopMargin (8)
/// PK视频y
#define kXYLPKVideoViewY (kXYLRoomInfoHeaderViewTopMargin + kXYLRoomInfoHeaderViewHeight + kXYLPKVideoTopMargin)
/// PK视频高度
#define kXYLPKVideoViewHeight ([XYCUtil xyf_isIPhoneX] ? 316 : 270)
/// PK进度条高度
#define kXYLPKProgressViewHeight (15)
/// PK前三名高度 (顶部间距6 + 座位高度27)
#define kXYLPKTopThreeHeight (33)
/// PK总高度
#define kXYLPKControlTotalHeight (kXYLPKVideoViewHeight + kXYLPKProgressViewHeight + kXYLPKTopThreeHeight)

#pragma mark 底部视图
/// 底部输入框高度
#define kXYLBottomInputHeight (36)
/// 底部输入框间距
#define kXYLBottomInputMargin ([XYCUtil xyf_isIPhoneX] ? 34 : 10)
/// 底部视图总高度
#define kXYLBottomTotalHeight (kXYLBottomInputHeight + kXYLBottomInputMargin)

#pragma mark 弹幕区域容器
/// 礼物弹幕底部间距
#define kXYLGiftMessageBottomMargin (18)
/// 礼物弹幕高度
#define kXYLGiftMessageHeight (85)
/// 礼物弹幕高度
#define kXYLGiftMessageWidth (267)
/// 弹幕容器顶部间距
#define kXYLMessageBGViewTopMargin (kXYLPKVideoViewY + kXYLPKControlTotalHeight + 8)
/// 弹幕容器高度
#define kXYLMessageBGViewHeight (kXYLScreenHeight - kXYLMessageBGViewTopMargin - kXYLBottomTotalHeight)
/// 弹幕容器高度（键盘弹起时的高度）
#define kXYLMessageBGViewInputShowHeight (140 + 8)
/// 弹幕视图高度
#define kXYLMessageViewHeight (kXYLMessageBGViewHeight - 8)
/// 弹幕视图宽度
#define kXYLMessageViewWidth (kXYLScreenWidth - 114)
/// 弹幕视图高度（键盘弹起时的高度）
#define kXYLMessageViewInputShowHeight (140)
/// 弹幕文本四周间距
#define kXYLMessageTextEdge (UIEdgeInsetsMake(4, 6, 4, 6))
/// 弹幕气泡四周最小间距
#define kXYLMessageBubbleMinEdge (UIEdgeInsetsMake(1.5, 12, 1.5, 0))

#pragma mark banner
/// banner宽度
#define kXYLBannerWidth (85)
/// banner宽度
#define kXYLBannerHeight (105)

#pragma mark 小窗状态下的视频
/// 小窗状态的视频高
#define kXYLSmallVideoHeight (160)
/// 小窗状态的视频宽
#define kXYLSmallVideoWidth (107)

#endif /* OWLJayoutDef_h */
