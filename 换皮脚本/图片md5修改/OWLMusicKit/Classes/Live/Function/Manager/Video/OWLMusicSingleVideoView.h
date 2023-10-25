//
//  OWLMusicSingleVideoView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicSingleVideoView : UIView

#pragma mark - Setter
/// 账号ID
@property (nonatomic, assign) NSInteger xyp_accountID;
/// 改变音频状态(只会在对方幕布上显示)
@property (nonatomic, assign) BOOL xyp_isMuted;

#pragma mark - Getter
/// 大小类型
@property (nonatomic, assign, readonly) XYLModuleSingleVideoSizeType xyp_sizeType;
/// 主播类型
@property (nonatomic, assign, readonly) XYLModuleSingleVideoAnchorType xyp_anchorType;

- (instancetype)initWithSizeType:(XYLModuleSingleVideoSizeType)sizeType anchorType:(XYLModuleSingleVideoAnchorType)anchorType;


@end

NS_ASSUME_NONNULL_END
