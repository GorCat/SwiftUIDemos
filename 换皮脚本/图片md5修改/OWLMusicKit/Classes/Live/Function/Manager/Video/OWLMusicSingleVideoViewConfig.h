//
//  OWLMusicSingleVideoViewConfig.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicSingleVideoViewConfig : NSObject

/// frame
@property (nonatomic, assign) CGRect xyp_frame;

/// 是否有封面
@property (nonatomic, assign) BOOL xyp_hasCover;

/// 是否有静音按钮
@property (nonatomic, assign) BOOL xyp_hasMuteIcon;


- (instancetype)initWithSizeType:(XYLModuleSingleVideoSizeType)sizeType anchorType:(XYLModuleSingleVideoAnchorType)anchorType;

@end

NS_ASSUME_NONNULL_END
