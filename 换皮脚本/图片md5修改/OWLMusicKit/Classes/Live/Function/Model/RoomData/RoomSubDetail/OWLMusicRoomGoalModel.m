//
//  OWLMusicRoomGoalModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#import "OWLMusicRoomGoalModel.h"

@implementation OWLMusicRoomGoalModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roomId": @"roomId",
        @"dsb_desc": @"goalDesc",
        @"dsb_goalCoin": @"goalIncome",
        @"dsb_currentCoin" : @"currentIncome"
    };
}

/// 获取当前目标进度
- (double)xyf_getCurrentProgress {
    double progress = 0;
    if (self.dsb_goalCoin > 0) {
        progress = (double)self.dsb_currentCoin / (double)self.dsb_goalCoin;
        if (progress > 1) { progress = 1; }
    } else {
        progress = self.dsb_currentCoin > 0 ? 1 : 0;
    }
    return progress;
}

@end
