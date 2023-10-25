//
//  OWLMusicMessageModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/20.
//

#import "OWLMusicMessageModel.h"
#import "OWLMusicEnterPrivateChatModel.h"

@interface OWLMusicMessageModel ()

@end

@implementation OWLMusicMessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"dsb_systemType": @"systemMsgType",
        @"dsb_msgType": @"type",
        @"dsb_userType": @"userType",
        @"dsb_isVipUser" : @"isVip",
        @"dsb_isSVipUser" : @"isSvip",
        @"dsb_isPrivilegeUser" : @"isPrivilege",
        @"dsb_accountID" : @"userId",
        @"dsb_nickname" : @"userName",
        @"dsb_avatar" : @"avatar",
        @"dsb_text" : @"content",
        @"dsb_giftID" : @"giftId",
        @"dsb_giftCombo" : @"combo",
        @"dsb_isblindGift" : @"isblindBox",
        @"dsb_tagUrl" : @"uniqueTagUrl",
        @"dsb_tagHeight" : @"uniqueTagHeight",
        @"dsb_tagWidth" : @"uniqueTagWidth"
    };
}

#pragma mark - 方法
/// 是否需要显示到消息列表上
- (BOOL)xyf_isShowInMessageList {
    switch (self.dsb_msgType) {
        case OWLMusicMessageType_SystemTip:
        case OWLMusicMessageType_JoinRoom:
        case OWLMusicMessageType_TextMessage:
        case OWLMusicMessageType_SendGift:
        case OWLMusicMessageType_MuteUser:
            return YES;
        default:
            return NO;
    }
}

#pragma mark - 初始化
/// 1.系统提示消息
+ (OWLMusicMessageModel *)xyf_getSystemTipMsg {
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_SystemTip),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : kXYLLocalString(@"Please don't spread vulgar, pornographic, abusive content, or any content violating customs, rights or laws. Exposure of personal information is also prohibited. Violators will be muted or banned."),
                          @"userType" : @(OWLMusicMessageUserType_User)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 1.1PK结束消息
+ (OWLMusicMessageModel *)xyf_pkEndTipMsg {
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_SystemTip),
                          @"systemMsgType" : @(OWLMusicMessageSystemType_PkEnd),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : kXYLLocalString(@"This round of PK is over. Please wait for the next round."),
                          @"userType" : @(OWLMusicMessageUserType_User)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 2.加入直播间消息
+ (OWLMusicMessageModel *)xyf_getJoinRoomMsg {
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_JoinRoom),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"isPrivilege" : @(OWLJConvertToolShared.xyf_userIsPrivilege),
                          @"content" : @"Join the room",
                          @"userType" : @(OWLMusicMessageUserType_User),
                          @"uniqueTagUrl" : OWLJConvertToolShared.xyf_configTagUrl,
                          @"uniqueTagHeight" : @(OWLJConvertToolShared.xyf_configTagHeight),
                          @"uniqueTagWidth" : @(OWLJConvertToolShared.xyf_configTagWidth)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 3.文本消息
+ (OWLMusicMessageModel *)xyf_getTextMessage:(NSString *)text {
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_TextMessage),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : text,
                          @"userType" : @(OWLMusicMessageUserType_User),
                          @"uniqueTagUrl" : OWLJConvertToolShared.xyf_configTagUrl,
                          @"uniqueTagHeight" : @(OWLJConvertToolShared.xyf_configTagHeight),
                          @"uniqueTagWidth" : @(OWLJConvertToolShared.xyf_configTagWidth)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 4.礼物消息
+ (OWLMusicMessageModel *)xyf_getSendGiftMsg:(OWLMusicGiftInfoModel *)gift giftNum:(NSInteger)giftNum {
    NSString *str = [gift mj_JSONString];
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_SendGift),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"uniqueTagUrl" : OWLJConvertToolShared.xyf_configTagUrl,
                          @"uniqueTagHeight" : @(OWLJConvertToolShared.xyf_configTagHeight),
                          @"uniqueTagWidth" : @(OWLJConvertToolShared.xyf_configTagWidth),
                          @"content" : str?:@"",
                          @"giftId" : @(gift.dsb_giftID),
                          @"combo" : @(giftNum),
                          @"userType" : @(OWLMusicMessageUserType_User),
                          @"isblindBox" : @(gift.dsb_isBlindGift)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 7.房间消息
+ (OWLMusicMessageModel *)xyf_getUpdateInfoMsg:(OWLMusicRoomDetailModel *)room {
    OWLMusicRoomDetailModel *detailModel = [[OWLMusicRoomDetailModel alloc] initWithDictionary:room.mj_keyValues];
    detailModel.dsb_dictionary = @{};
    detailModel.dsb_giftList = @[];
    NSString *text = [detailModel mj_JSONString];
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_UpdateRoomInfo),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : text?:@"",
                          @"userType" : @(OWLMusicMessageUserType_User)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 8.带走消息
+ (OWLMusicMessageModel *)xyf_getTakeAnchorMsg:(OWLMusicGiftInfoModel *)gift
                                privateVideoDict:(NSDictionary *)privateVideoDict {
    NSMutableDictionary *privateMutDic = [privateVideoDict mutableCopy];
    [privateMutDic setValue:[NSNumber numberWithBool:NO] forKey:@"isTruthOrDareOn"];
    [privateMutDic setValue:OWLJConvertToolShared.xyf_userAccountDic forKey:@"callUser"];
    NSString *content = [privateMutDic mj_JSONString];
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_UserTakeAnchor),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : content?:@"",
                          @"giftId" : @(gift.dsb_giftID),
                          @"combo" : @(1),
                          @"userType" : @(OWLMusicMessageUserType_User)
    };
    
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}

/// 16.刷新观众列表
+ (OWLMusicMessageModel *)xyf_getUpdateMemberListMsg:(NSArray *)memberList {
    NSString *text = [[OWLMusicMemberModel mj_keyValuesArrayWithObjectArray:memberList] mj_JSONString];
    NSDictionary *dic = @{@"type": @(OWLMusicMessageType_UpdateMemberList),
                          @"userId" : @(OWLJConvertToolShared.xyf_userAccountID),
                          @"userName" : OWLJConvertToolShared.xyf_userName,
                          @"avatar" : OWLJConvertToolShared.xyf_userAvatar,
                          @"isVip" : @(OWLJConvertToolShared.xyf_userTotalRecharge > 0.1),
                          @"isSvip" : @(OWLJConvertToolShared.xyf_userIsSvip),
                          @"content" : text?:@"",
                          @"userType" : @(OWLMusicMessageUserType_User)
    };
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] initWithDictionary:dic];
    return message;
}


/// 19.禁言列表
+ (OWLMusicMessageModel *)xyf_getMutedMembersInfoMsg:(NSArray *)muteList {
    OWLMusicMessageModel *message = [[OWLMusicMessageModel alloc] init];
    message.dsb_msgType = OWLMusicMessageType_MutedMembersInfo;
    message.dsb_text = [muteList mj_JSONObject];
    
    return message;
}

@end
