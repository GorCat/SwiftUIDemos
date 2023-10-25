//
//  OWLMusicTongJiTool.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/11.
//


#import "OWLMusicTongJiTool.h"
#import "OWLBGMModuleVC.h"

@implementation OWLMusicTongJiTool

#pragma mark - Public
#pragma mark Thinking
/// 不带dic的埋点事件
+ (void)xyf_thinkingWithName:(NSString *)eventName {
    [self xyf_thinkingEventWithName:eventName dic:[self xyf_addBasicInfo]];
}

/// 带from的埋点事件
+ (void)xyf_thinkingFromWithName:(NSString *)eventName {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:@"live" forKey:@"from"];
    [self xyf_thinkingEventWithName:eventName dic:dic];
}

/// 时间事件埋点
+ (void)xyf_thinkingWithTimeEventName:(NSString *)eventName {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleThinkingType:eventName:dic:)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleThinkingType:XYLOutDataSourceThinkingEventType_Time eventName:eventName dic:nil];
    }
}

/// 点击小窗关闭房间
+ (void)xyf_thinkingMiniCloseRoom {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:@"live" forKey:@"type"];
    [self xyf_thinkingEventWithName:XYLThinkingEventCloseRoomByMinimize dic:dic];
}

/// 点击小窗回到房间
+ (void)xyf_thinkingMiniReturnRoom {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:@"live" forKey:@"type"];
    [self xyf_thinkingEventWithName:XYLThinkingEventReturnRoomByMinimize dic:dic];
}

/// 带走通话事件
+ (void)xyf_thinkingStartCall {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:@"live-take" forKey:@"from"];
    [self xyf_thinkingEventWithName:XYLThinkingEventStartCall dic:dic];
}

/// 送礼点击事件
+ (void)xyf_thinkingSengGift:(OWLMusicGiftInfoModel *)model isPrivate:(BOOL)isPrivate isFast:(BOOL)isFast {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    NSString *giftID = [NSString stringWithFormat:@"%ld",(long)model.dsb_giftID];
    [dic setObject:giftID forKey:@"gift_id"];
    [dic setObject:model.dsb_giftName ?:@"" forKey:@"gift_name"];
    [dic setObject:@(model.dsb_giftCoin) forKey:@"gift_coins"];
    [dic setObject:@(model.dsb_isBlindGift) forKey:@"is_luckybox"];
    [dic setObject:@(isPrivate) forKey:@"is_private"];
    [dic setObject:@(isFast) forKey:@"is_fast"];
    [dic setObject:@"live" forKey:@"from"];
    [dic setObject:@(1) forKey:@"count"];
    [self xyf_thinkingEventWithName:XYLThinkingEventSendGiftSuccess dic:dic];
}

/// 礼物分类点击
+ (void)xyf_thinkingGiftThemeClick:(NSString *)themeName {
    NSString *lower = themeName.lowercaseString;
    if (lower.length == 0) { return; }
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:themeName forKey:@"theme_name"];
    [self xyf_thinkingEventWithName:XYLThinkingEventGiftThemeClick dic:dic];
}

/// 礼物面板内礼物icon点击
+ (void)xyf_thinkingGiftPopupGiftClick:(OWLMusicGiftInfoModel *)model {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    NSString *giftID = [NSString stringWithFormat:@"%ld",(long)model.dsb_giftID];
    [dic setObject:giftID forKey:@"gift_id"];
    [dic setObject:model.dsb_giftName ?:@"" forKey:@"gift_name"];
    [dic setObject:@(model.dsb_giftCoin) forKey:@"gift_coins"];
    [dic setObject:@(model.dsb_isBlindGift) forKey:@"is_luckybox"];
    [dic setObject:@"live" forKey:@"from"];
    [self xyf_thinkingEventWithName:XYLThinkingEventGiftPopupGiftClick dic:dic];
}

/// 成功进入某直播间
+ (void)xyf_thinkingEnterRoomSuccess:(OWLMusicRoomDetailModel *)detailModel fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    NSString *enterWay = [OWLJConvertToolShared xyf_getEnterRoomWayStr:fromWay];
    if (enterWay.length <= 0) { return; }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *roomID = [NSString stringWithFormat:@"%ld",(long)detailModel.dsb_roomID];
    NSString *hostID = [NSString stringWithFormat:@"%ld",(long)detailModel.dsb_ownerAccountID];
    [dic setObject:roomID forKey:@"room_id"];
    [dic setObject:hostID forKey:@"host_id"];
    [dic setObject:detailModel.dsb_ownerDisplayAccountID ?:@"" forKey:@"host_display_id"];
    [dic setObject:@([detailModel xyf_beActive]) forKey:@"is_living"];
    [dic setObject:enterWay forKey:@"from"];
    [dic setObject:@"live" forKey:@"room_type"];
    
    [self xyf_thinkingEventWithName:XYLThinkingEventEnterRoomSuccess dic:dic];
}

/// 进入到离开单个直播的时间(该事件为计时事件/秒)
+ (void)xyf_thinkingTimeForOneLive:(OWLMusicRoomTotalModel *)totalModel {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *roomID = [NSString stringWithFormat:@"%ld",(long)[totalModel xyf_getRoomID]];
    NSString *hostID = [NSString stringWithFormat:@"%ld",(long)[totalModel xyf_getOwnerID]];
    NSString *enterWay = [OWLJConvertToolShared xyf_getEnterRoomWayStr:totalModel.xyp_tempModel.xyp_enterType];
    
    [dic setObject:@"live" forKey:@"room_type"];
    [dic setObject:roomID forKey:@"room_id"];
    [dic setObject:hostID forKey:@"host_id"];
    [dic setObject:totalModel.xyp_detailModel.dsb_ownerDisplayAccountID ?:@"" forKey:@"host_display_id"];
    [dic setObject:enterWay forKey:@"from"];
    [dic setObject:@([totalModel.xyp_detailModel xyf_beActive]) forKey:@"is_living"];
    
    [self xyf_thinkingEventWithName:XYLThinkingEventTimeForOneLive dic:dic];
}

/// 进入PK到退出PK的时长（秒）处于双人直播画面
+ (void)xyf_thinkingTimeForOnePK:(OWLMusicRoomTotalModel *)totalModel {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *roomID = [NSString stringWithFormat:@"%ld",(long)[totalModel xyf_getRoomID]];
    NSString *hostID = [NSString stringWithFormat:@"%ld",(long)[totalModel xyf_getOwnerID]];
    NSString *enterWay = [OWLJConvertToolShared xyf_getEnterRoomWayStr:totalModel.xyp_tempModel.xyp_enterType];
    
    [dic setObject:@"live" forKey:@"room_type"];
    [dic setObject:roomID forKey:@"room_id"];
    [dic setObject:hostID forKey:@"host_id"];
    [dic setObject:totalModel.xyp_detailModel.dsb_ownerDisplayAccountID ?:@"" forKey:@"host_display_id"];
    [dic setObject:enterWay forKey:@"from"];
    
    [self xyf_thinkingEventWithName:XYLThinkingEventTimeForOnePK dic:dic];
}

/// 游戏按钮点击
+ (void)xyf_thinkingClickGameIconWithGameID:(NSInteger)gameID {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    [dic setObject:@"live" forKey:@"from"];
    [dic setObject:@(gameID) forKey:@"gameid"];
    [self xyf_thinkingEventWithName:XYLThinkingEventClickGameIcon dic:dic];
}

/// 点击banner事件
+ (void)xyf_thinkingClickBannerWithName:(NSString *)name {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    NSString *bannerName = name.length > 0 ? name : @"";
    [dic setObject:bannerName forKey:@"banner_name"];
    [dic setObject:@"live" forKey:@"from"];
    [self xyf_thinkingEventWithName:XYLThinkingEventClickBanner dic:dic];
}

/// 1金币转盘点击事件
+ (void)xyf_thinkingClickOneCoinButton {
    NSMutableDictionary *dic = [self xyf_addBasicInfo];
    BOOL overage = OWLJConvertToolShared.xyf_userCoins >= 1;
    [dic setObject:@(overage) forKey:@"overage"];
    [self xyf_thinkingEventWithName:XYLThinkingEventClickOneCoinButton dic:dic];
}

#pragma mark Firebase
/// 金币减少
/*
 sendGift:送礼（送礼接口调成功）
 live-private:直播间带走
 activity:活动扣费
 */
+ (void)xyf_firebaseSpendCoin:(NSInteger)coins spendWay:(NSString *)spendWay {
    NSDictionary *dic = @{
        @"way" : spendWay,
        @"value" : @(coins)
    };
    
    [self xyf_firebaseEventWithType:XYLOutDataSourceFirebaseEventType_SpendCurrency dic:dic];
}

#pragma mark - Private
#pragma mark Thinking
+ (NSMutableDictionary *)xyf_addBasicInfo {
    OWLMusicRoomTotalModel *currentModel = OWLMusicInsideManagerShared.xyp_vc.xyp_currentTotalModel;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *roomID = [NSString stringWithFormat:@"%ld",(long)[currentModel xyf_getRoomID]];
    NSString *hostID = [NSString stringWithFormat:@"%ld",(long)[currentModel xyf_getOwnerID]];
    
    [dic setObject:@"live" forKey:@"room_type"];
    [dic setObject:roomID forKey:@"room_id"];
    [dic setObject:hostID forKey:@"host_id"];
    [dic setObject:currentModel.xyp_detailModel.dsb_ownerDisplayAccountID ?:@"" forKey:@"host_display_id"];
    
    return dic;
}

+ (void)xyf_thinkingEventWithName:(NSString *)eventName dic:(NSDictionary * __nullable)dic {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleThinkingType:eventName:dic:)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleThinkingType:XYLOutDataSourceThinkingEventType_Event eventName:eventName dic:dic];
    }
}

#pragma mark Firebase
+ (void)xyf_firebaseEventWithType:(XYLOutDataSourceFirebaseEventType)type dic:(NSDictionary * __nullable)dic {
    if (OWLBGMModuleManagerShared.delegate && [OWLBGMModuleManagerShared.delegate respondsToSelector:@selector(xyf_outsideModuleFirebaseType:dic:)]) {
        [OWLBGMModuleManagerShared.delegate xyf_outsideModuleFirebaseType:type dic:dic];
    }
}

@end
