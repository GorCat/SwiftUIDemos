//// OWLMusicGameInfoModel.m
// XYYCuteKit
//
// 
//


#import "OWLMusicGameInfoModel.h"

@implementation OWLMusicGameInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_enable": @"enable",
        @"dsb_recoreds": @"recoreds"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_recoreds" : [OWLMusicGameConfigModel class]
    };
}

/// 找到默认游戏
- (OWLMusicGameConfigModel *)xyf_findDefaultGameModel {
    OWLMusicGameConfigModel *gameModel;
    for (OWLMusicGameConfigModel *model in self.dsb_recoreds) {
        if (model.dsb_defaultGame == 1) {
            gameModel = model;
            break;
        }
    }
    return gameModel;
}

/// 检查当前游戏是否开启
- (BOOL)xyf_checkGameIsOpen:(NSInteger)gameID {
    BOOL enable = NO;
    for (OWLMusicGameConfigModel *model in self.dsb_recoreds) {
        if (model.dsb_gameId == gameID) {
            enable = model.dsb_enable;
            break;
        }
    }
    return enable;
}

/// 遍历出所有开启游戏的数组
- (NSMutableArray *)xyf_getAllOpenGame {
    NSMutableArray *gameList = [[NSMutableArray alloc] init];
    for (OWLMusicGameConfigModel *model in self.dsb_recoreds) {
        if (model.dsb_enable) {
            [gameList addObject:model];
        }
    }
    return gameList;
}

@end

@implementation OWLMusicGameConfigModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_gameId" : @"gameId",
        @"dsb_gameName" : @"gameName",
        @"dsb_sort" : @"sort",
        @"dsb_picture" : @"picture",
        @"dsb_gameAdress" : @"gameAdress",
        @"dsb_enable" : @"enable",
        @"dsb_supplier" : @"supplier",
        @"dsb_rate" : @"rate",
        @"dsb_defaultGame" : @"defaultGame"
    };
}

@end
