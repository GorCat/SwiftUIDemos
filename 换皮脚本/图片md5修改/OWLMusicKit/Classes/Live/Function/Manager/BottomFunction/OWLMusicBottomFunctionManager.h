//// OWLMusicBottomFunctionManager.h
// XYYCuteKit
//
// 
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 底部按钮类型（不算最右侧送礼按钮，从左至右排序）
typedef NS_ENUM(NSInteger, OWLMusicBottomFunctionType) {
    /// 举报
    OWLMusicBottomFunctionType_Report = 0,
    /// 更多
    OWLMusicBottomFunctionType_More,
    /// 铁粉
    XYLModuleSingleVideoSizeType_Fan,
    /// 游戏
    OWLMusicBottomFunctionType_Game,
    /// 充值
    XYLModuleSingleVideoSizeType_Recharge,
    /// 快捷送礼
    OWLMusicBottomFunctionType_FastGift,
};

/// 直播间工具视图类型
typedef NS_ENUM(NSInteger, OWLBGMRoomToolsSubCellType) {
    /// 充值
    OWLBGMRoomToolsSubCellType_Recharge = 0,
    /// 广播
    OWLBGMRoomToolsSubCellType_Broadcast,
    /// 流设置
    OWLBGMRoomToolsSubCellType_StreamSettings
};

@interface OWLMusicBottomFunctionManager : NSObject

@property (nonatomic, strong, readonly) NSArray *bottomArray;

@property (nonatomic, strong, readonly) NSMutableArray *moreArray;

@end

NS_ASSUME_NONNULL_END
