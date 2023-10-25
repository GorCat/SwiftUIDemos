//// OWLMusicGameInfoModel.h
// XYYCuteKit
//
// 
//


#import "OWLBGMModuleBaseModel.h"
@class OWLMusicGameConfigModel;

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicGameInfoModel : OWLBGMModuleBaseModel

/// 是否开启
@property (nonatomic, assign) BOOL dsb_enable;
/// 配置
@property (nonatomic, strong) NSArray <OWLMusicGameConfigModel *> *dsb_recoreds;

/// 找到默认游戏
- (OWLMusicGameConfigModel *)xyf_findDefaultGameModel;

/// 检查当前游戏是否开启
- (BOOL)xyf_checkGameIsOpen:(NSInteger)gameID;

/// 遍历出所有开启游戏的数组
- (NSMutableArray *)xyf_getAllOpenGame;

@end

@interface OWLMusicGameConfigModel : OWLBGMModuleBaseModel

@property (nonatomic, assign) NSInteger dsb_gameId;

@property (nonatomic, copy) NSString *dsb_gameName;

@property (nonatomic, copy) NSString *dsb_sort;

@property (nonatomic, copy) NSString *dsb_picture;

@property (nonatomic, copy) NSString *dsb_gameAdress;

@property (nonatomic, assign) BOOL dsb_enable;
/// 供应商
@property (nonatomic, assign) NSInteger dsb_supplier;
/// 高宽比
@property (nonatomic, assign) double dsb_rate;
/// 默认游戏：0非默认 1默认
@property (nonatomic, assign) NSInteger dsb_defaultGame;

@end

NS_ASSUME_NONNULL_END
