//
//  OWLMusicRoomDetailModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLMusicRoomDetailModel.h"

@implementation OWLMusicRoomDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self.dsb_isUGCRoom) {
        self.dsb_isFollowedOwner = YES;
        self.dsb_memberList = self.dsb_ugcMemberList;
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_roomID": @"roomId",
        @"dsb_title": @"roomTitle",
        @"dsb_cover": @"roomCover",
        @"dsb_roomType": @"roomType",
        @"dsb_rtcRoomID": @"agoraRoomId",
        @"dsb_ownerAccountID": @"hostAccountId",
        @"dsb_ownerDisplayAccountID": @"hostDisplayAccountId",
        @"dsb_ownerNickname": @"hostName",
        @"dsb_ownerAvatar": @"hostAvatar",
        @"dsb_ownerMood": @"hostMood",
        @"dsb_micState": @"hostStatus",
        @"dsb_ownerFansStart": @"hostFollowersBeg",
        @"dsb_ownerFansEnd": @"hostFollowersEnd",
        @"dsb_ownerReceiveGift": @"hostReceivedGifts",
        @"dsb_ownerIncome": @"hostIncome",
        @"dsb_currentPeopleNum": @"memberCount",
        @"dsb_maxPeopleNum": @"maxMemberCount",
        @"dsb_privateChatNum": @"privateChatCount",
        @"dsb_privateChatState": @"privateChatFlag",
        @"dsb_privateChatGiftID": @"privateChatGiftId",
        @"dsb_isFollowedOwner": @"isHostFollowed",
        @"dsb_roomDuration": @"liveDuration",
        @"dsb_roomState": @"roomStatus",
        @"dsb_memberList": @"videoChatRoomMembers",
        @"dsb_ugcMemberList": @"members",
        @"dsb_pkInviteState": @"pkInvitationFlag",
        @"dsb_pkData": @"pkData",
        @"dsb_roomGoal": @"roomGoal",
        @"dsb_giftList": @"gifts",
        @"dsb_isUGCRoom": @"isUgc",
        @"dsb_circlePanState": @"turntableFlag",
        @"dsb_circlePanItems": @"turntableItems",
        @"dsb_circlePanTitle": @"turntableTitle",
        @"dsb_ownerCallPrice": @"hostCallPrice",
        @"dsb_lastMessages": @"latestBarrages",
        @"dsb_quickGift": @"lovelyGift",
        @"dsb_fanInfo": @"stanInfo",
        @"dsb_gameConfig": @"gameConfig"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"dsb_memberList" : [OWLMusicMemberModel class],
        @"dsb_ugcMemberList": [OWLMusicMemberModel class],
        @"dsb_pkData" : [OWLMusicRoomPKDataModel class],
        @"dsb_roomGoal" : [OWLMusicRoomGoalModel class],
        @"dsb_giftList" : [OWLMusicGiftConfigModel class],
        @"dsb_circlePanItems" : [NSString class],
        @"dsb_lastMessages" : [OWLMusicMessageModel class],
        @"dsb_quickGift" : [OWLMusicGiftInfoModel class],
        @"dsb_fanInfo" : [OWLMusicFanInfoModel class],
        @"dsb_gameConfig" : [OWLMusicGameInfoModel class]
    };
}

/// 是否是PK状态
- (BOOL)xyf_isPKState {
    if (self.dsb_pkData != nil && self.dsb_pkData.dsb_ownerPlayer != nil) {
        if (self.dsb_pkData.dsb_ownerPlayer.dsb_roomStatus == XYLModuleRoomStateType_PKing ||
            self.dsb_pkData.dsb_ownerPlayer.dsb_roomStatus == XYLModuleRoomStateType_WaitNextPKing ||
            self.dsb_pkData.dsb_ownerPlayer.dsb_roomStatus == XYLModuleRoomStateType_PKPunishing) {
            return YES;
        }
    }
    return NO;
}

/// 是否是活跃状态
- (BOOL)xyf_beActive {
    switch (self.dsb_roomState) {
        case XYLModuleRoomStateType_NoStart:
        case XYLModuleRoomStateType_PrivateChat:
        case XYLModuleRoomStateType_Finish:
        case XYLModuleRoomStateType_Waiting:
            return NO;
        default:
            return YES;
    }
}

/// 是否开启私聊
- (BOOL)xyf_isOpenPrivate {
    return self.dsb_privateChatState == XYLModulePrivateChatStatusType_Open;
}

@end
