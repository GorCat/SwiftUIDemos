//// OWLMusicBottomFunctionManager.m
// XYYCuteKit
//
// 
//


#import "OWLMusicBottomFunctionManager.h"

@interface OWLMusicBottomFunctionManager()

@property (nonatomic, strong) NSArray *bottomArray;

@property (nonatomic, strong) NSMutableArray *moreArray;

@end

@implementation OWLMusicBottomFunctionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self xyf_setupFunction];
    }
    return self;
}

#pragma mark - 初始化
- (void)xyf_setupFunction {
    // 🙂写注释是我为数不多的良心。哪个有缘人要改这段代码 v50 谢谢(*^▽^*)
    /*
     总原则：最多显示五个
     从左至右顺序(✅为必须显示)：举报、更多、铁粉、游戏、充值、快捷送礼(✅)、送礼(✅送礼按钮不在这个层级)
     举报：无马甲的包显示，有马甲的包隐藏。(目前不管这个举报了)
     铁粉：1.主包服务端控制是否开启铁粉功能（目前隐藏处理） 2.房间信息"是否为该房主粉丝"字段控制显示隐藏
     游戏：1.绿号不显示 2.房间信息字段控制显示隐藏
     充值：充值放得下就放外面 放不下就放更多里面
     */
    
    
    /// 除去最右弹窗，最多显示四个，且快捷送礼必须显示。游戏、充值都能放的下
    /// 顺序：举报（不考虑）、更多、铁粉（不考虑）、游戏、充值、快捷送礼(✅)
    
    NSMutableArray *bottomArray = [[NSMutableArray alloc] init];
    NSMutableArray *moreArray = [[NSMutableArray alloc] init];
    
    
    // ------ 配置更多按钮中的按钮列表 ------
    /// 广播
    if ([self xyf_hasBroadcast]) {
        [moreArray addObject:@(OWLBGMRoomToolsSubCellType_Broadcast)];
    }
    
    /// 视频流设置
    if ([self xyf_hasStreamSetting]) {
        [moreArray addObject:@(OWLBGMRoomToolsSubCellType_StreamSettings)];
    }
    
    self.moreArray = moreArray;
    
    // ------ 配置底部按钮 ------
    /// 更多
    if (self.moreArray.count > 0) {
        [bottomArray addObject:@(OWLMusicBottomFunctionType_More)];
    }
    
    /// 游戏
    if ([self xyf_hasGame]) {
        [bottomArray addObject:@(OWLMusicBottomFunctionType_Game)];
    }
    
    /// 充值
    [bottomArray addObject:@(XYLModuleSingleVideoSizeType_Recharge)];
    
    /// 快捷送礼（必须有）
    [bottomArray addObject:@(OWLMusicBottomFunctionType_FastGift)];
    
    /// 根据枚举值排序（目前写死了 不需要再排序了）
//    NSArray *realBottomArray = [bottomArray sortedArrayUsingSelector:@selector(compare:)];
    self.bottomArray = bottomArray;
}

#pragma mark - Getter
#pragma mark 底部按钮
/// 举报: 无马甲的包才添加按钮
- (BOOL)xyf_hasReport {
    return OWLJConvertToolShared.xyf_isJustMain;
}

/// 游戏：绿号不显示
- (BOOL)xyf_hasGame {
    return !OWLJConvertToolShared.xyf_isGreen;
}

#pragma mark 更多模块
/// 广播：绿号不显示
- (BOOL)xyf_hasBroadcast {
    return !OWLJConvertToolShared.xyf_isGreen;
}

/// 视频流设置：等稳定了之后再改成YES
- (BOOL)xyf_hasStreamSetting {
    return YES;
}

@end
