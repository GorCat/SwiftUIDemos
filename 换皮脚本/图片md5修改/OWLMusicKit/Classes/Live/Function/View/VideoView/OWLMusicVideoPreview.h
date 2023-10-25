//
//  OWLMusicVideoPreview.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

/**
 * @功能描述：直播间 - 显示视频视图
 * @创建时间：2023.2.20
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicVideoPreview : UIView

/// 账号ID
@property (nonatomic, assign) NSInteger xyp_accountID;

/// 改变音频状态(只会在对方幕布上显示)
@property (nonatomic, assign) BOOL xyp_isMuted;

/// 是否是PK状态
@property (nonatomic, assign) BOOL xyp_isPKState;

/// 是否由主播关闭摄像头
@property (nonatomic, assign) BOOL xyp_isCameraOff;

/// 头像
@property (nonatomic, copy) NSString *xyp_avatar;

/// 是否是自己观看的主播
@property (nonatomic, assign, readonly) BOOL xyp_isMineAnchor;

/// 是否正在显示离线文案
@property (nonatomic, assign) BOOL xyp_isShowOfflineTip;

- (instancetype)initWithFrame:(CGRect)frame isMineAnchor:(BOOL)xyp_isMineAnchor;

/// 设置封面
- (void)xyf_setCover:(NSString *)cover isClean:(BOOL)isClean;

/// 获取视频幕布
- (UIView *)xyf_getVideoPreview;

/// 清空视图
- (void)xyf_resetView;

/// 改变浮窗状态
- (void)xyf_changeFloatState:(BOOL)isFloat;

@end

NS_ASSUME_NONNULL_END
