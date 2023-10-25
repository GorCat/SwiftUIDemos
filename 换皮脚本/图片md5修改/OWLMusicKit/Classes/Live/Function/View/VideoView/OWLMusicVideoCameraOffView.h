//
//  OWLMusicVideoCameraOffView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicVideoCameraOffView : UIView

/// 主播是否关闭摄像头
@property (nonatomic, assign) BOOL xyp_muteVideo;

/// 是否是PK状态
@property (nonatomic, assign) BOOL xyp_isPKState;

/// 改变浮窗状态
@property (nonatomic, assign) BOOL xyp_floatState;

/// 是否显示离开文案
@property (nonatomic, assign) BOOL xyp_isShowOfflineTip;

/// 头像
@property (nonatomic, copy) NSString *xyp_avatar;

- (instancetype)initWithIsMine:(BOOL)isMine;

- (void)xyf_cleanView;

@end

NS_ASSUME_NONNULL_END
