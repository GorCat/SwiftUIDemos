//
//  OWLMusicVideoContainerView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

/**
 * @功能描述：直播间 - 视频容器视图
 * @创建时间：2023.2.20
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>
#import "OWLMusicVideoPreview.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicVideoContainerView : UIView

/// 数据源
@property (nonatomic, weak) id <OWLMusicSubManagerDataSource> dataSource;
/// 自己主播的视频视图
@property (nonatomic, strong, readonly) OWLMusicVideoPreview *xyp_mineAnchorView;
/// 对方主播的视频视图
@property (nonatomic, strong, readonly) OWLMusicVideoPreview *xyp_otherAnchorView;
/// 是否是小窗状态
@property (nonatomic, assign) BOOL xyp_isFloatState;
/// 当前房间状态
@property (nonatomic, assign) XYLModuleRoomStateType xyp_roomStatus;

/// 更新视频大小
- (void)xyf_changeVideoSize:(BOOL)isPKState;

/// 自动更新视频大小（在内部判断是两个人还是一个人）
- (void)xyf_audoChangeVideoSize;

/// 改变状态
- (void)xyf_changeFloatState:(BOOL)isFloatState;

/// 初始frame
- (CGRect)xyf_getViewWindowStartFrame;

@end

NS_ASSUME_NONNULL_END
