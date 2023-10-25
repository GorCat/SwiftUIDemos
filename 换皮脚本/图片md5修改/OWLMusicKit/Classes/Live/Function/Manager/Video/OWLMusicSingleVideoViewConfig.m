//
//  OWLMusicSingleVideoViewConfig.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/29.
//

#import "OWLMusicSingleVideoViewConfig.h"

@interface OWLMusicSingleVideoViewConfig ()

#pragma mark - Data
/// 大小类型
@property (nonatomic, assign) XYLModuleSingleVideoSizeType xyp_sizeType;
/// 主播类型
@property (nonatomic, assign) XYLModuleSingleVideoAnchorType xyp_anchorType;

@end


@implementation OWLMusicSingleVideoViewConfig

- (instancetype)initWithSizeType:(XYLModuleSingleVideoSizeType)sizeType anchorType:(XYLModuleSingleVideoAnchorType)anchorType {
    self = [super init];
    if (self) {
        self.xyp_sizeType = sizeType;
        self.xyp_anchorType = anchorType;
        [self xyf_setupFrame];
        [self xyf_setupOtherConfig];
    }
    return self;
}

/// 设置frame
- (void)xyf_setupFrame {
    CGSize size;
    CGFloat x = 0;
    CGFloat y = 0;
    switch (self.xyp_sizeType) {
        case XYLModuleSingleVideoSizeType_FullSingle:
            size = CGSizeMake(kXYLScreenWidth, kXYLScreenHeight);
            break;
        case XYLModuleSingleVideoSizeType_FullPK:
            y = kXYLPKVideoViewY;
            size = CGSizeMake(kXYLScreenWidth / 2.0, kXYLPKVideoViewHeight);
            break;
        case XYLModuleSingleVideoSizeType_FloatState:
            size = CGSizeMake(kXYLSmallVideoWidth, kXYLSmallVideoHeight);
            break;
    }
    
    x = self.xyp_anchorType == XYLModuleSingleVideoAnchorType_Mine ? 0 : size.width;
    
    self.xyp_frame = CGRectMake(x, y, size.width, size.height);
}

/// 设置封面是否显示
- (void)xyf_setupOtherConfig {
    // --- 是否有封面 ---
    /// 如果是在直播间页面的单人直播 不需要显示封面。cell上有封面。（fix bug 上下滑动 页面闪动问题）
    /// 如果是悬浮窗状态 或者 PK状态下 封面是要显示的。
    self.xyp_hasCover = self.xyp_sizeType != XYLModuleSingleVideoSizeType_FullSingle;
    
    // --- 是否有音频按钮 ---
    /// 只有对方视图才有
    self.xyp_hasMuteIcon = self.xyp_anchorType == XYLModuleSingleVideoAnchorType_Other;
    
}

@end
