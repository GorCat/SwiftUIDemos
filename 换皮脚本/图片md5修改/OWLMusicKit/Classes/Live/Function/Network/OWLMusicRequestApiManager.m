//
//  OWLMusicRequestApiManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

/**
 * @功能描述：直播间网络请求工具类
 * @创建时间：2023.2.17
 * @创建人：许琰
 */

#import "OWLMusicRequestApiManager.h"

@implementation OWLMusicRequestApiManager

#pragma mark - 基类方法
+ (void)xyf_requestApiWithModel:(OWLMusicRequestApiModel *)model completion:(XYLApiCompletion)aCompletion {
    [OWLBGMModuleManagerShared.delegate xyf_liveModuleRequstApi:model completionHandler:^(NSDictionary * _Nullable responseDic, NSError * _Nullable error) {
        OWLMusicApiResponse *resp = [[OWLMusicApiResponse alloc] initWithResponseData:responseDic error:error];
        if (aCompletion) {
            aCompletion(resp, error);
        }
    }];
}

#pragma mark - 网络请求
/// 加入房间
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestJoinRoomWithHostID:(NSInteger)hostID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCJoinRoomWithUserID : kXYL_Request_JoinRoomWithAnchorID;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(hostID) forKey:@"hostId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 离开房间
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestLeaveRoomWithRoomID:(NSInteger)roomID
                             isUGCRoom:(BOOL)isUGCRoom
                            completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCLeaveRoom : kXYL_Request_LeaveRoom;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 获取房间信息
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestRoomInfoWithRoomID:(NSInteger)roomID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCRoomInfo : kXYL_Request_RoomInfo;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 获取视频聊天室列表
/// - Parameters:
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestRoomList:(BOOL)isUGCRoom
                 completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCRoomList : kXYL_Request_RoomList;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 获取PK房间送礼列表
/// - Parameters:
///   - anchorID: 主播ID
///   - roomID: 房间ID
///   - aCompletion: 回调
+ (void)xyf_requestPKTopListWithAnchorID:(NSInteger)anchorID
                                  roomID:(NSInteger)roomID
                              completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_PKTopList method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:@(anchorID) forKey:@"hostId"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 用户送礼
/// - Parameters:
///   - roomID: 房间ID
///   - giftID: 礼物ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestSendGiftWithRoomID:(NSInteger)roomID
                               giftID:(NSInteger)giftID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCSendGift : kXYL_Request_SendGift;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:@(giftID) forKey:@"giftId"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 设置礼物已阅
/// - Parameters:
///   - title: 礼物标题
///   - aCompletion: 回调
+ (void)xyf_requestSeeGiftWithTitle:(NSString *)title
                         completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_SeeGift method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    [dic setObject:title?:@"" forKey:@"title"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}


/// 发消息掉接口
/// - Parameters:
///   - text: 文案
///   - roomID: 房间ID
///   - aCompletion: 回调
+ (void)xyf_requestSendText:(NSString *)text
                     roomID:(NSInteger)roomID
                 completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_SendText method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    NSString *content = [text xyf_stringByURLEncode];
    [dic setObject:content?:@"" forKey:@"content"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}


/// 获取禁言列表
/// - Parameters:
///   - rtcRoomID: 声网roomID
///   - isUGCRoom: 是否是ugc房间
///   - aCompletion: 回调
+ (void)xyf_requestMutedMembers:(NSString *)rtcRoomID
                      isUGCRoom:(BOOL)isUGCRoom
                     completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCMutedList : kXYL_Request_MutedList;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    [dic setObject:rtcRoomID?:@"" forKey:@"agoraRoomId"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 用户带走主播
/// - Parameters:
///   - roomID: 房间id
///   - giftID: 礼物ID
///   - aCompletion: 回调
+ (void)xyf_requestTakeAnchor:(NSInteger)roomID giftID:(NSInteger)giftID completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_TakeAnchor method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:@(giftID) forKey:@"giftId"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

#pragma mark - 用户相关
/// 获取主播/用户资料
/// - Parameters:
///   - accountID: 账号id
///   - roomID: 房间ID
///   - isAnchor: 是否是主播
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestAccountInfo:(NSInteger)accountID
                        roomID:(NSInteger)roomID
                      isAnchor:(BOOL)isAnchor
                     isUGCRoom:(BOOL)isUGCRoom
                    completion:(XYLApiCompletion)aCompletion {
    if (isAnchor) {
        [self xyf_requestAnchorInfo:accountID roomID:roomID completion:aCompletion];
    } else {
        [self xyf_requestUserInfo:accountID roomID:roomID isUGCRoom:isUGCRoom completion:aCompletion];
    }
}

/// 获取主播资料
+ (void)xyf_requestAnchorInfo:(NSInteger)accountID
                       roomID:(NSInteger)roomID
                   completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_AnchorInfo method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(accountID) forKey:@"anchorId"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 获取用户资料
+ (void)xyf_requestUserInfo:(NSInteger)accountID
                     roomID:(NSInteger)roomID
                  isUGCRoom:(BOOL)isUGCRoom
                 completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoom ? kXYL_Request_UGCUserInfo : kXYL_Request_UserInfo;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(accountID) forKey:@"userId"];
    [dic setObject:@(roomID) forKey:@"roomId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

/// 获取活动标签列表
/// - Parameters:
///   - accountID: 账号ID
///   - aCompletion: 回调
+ (void)xyf_requestEventLabelList:(NSInteger)accountID completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_LabelList method:kOWLJRequestMethodGET];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(accountID) forKey:@"accountId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}


/// 设置默认活动标签
/// - Parameters:
///   - title: 标签标题
///   - aCompletion: 回调
+ (void)xyf_requestSetDefaultLabel:(NSString *)title completion:(XYLApiCompletion)aCompletion {
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:kXYL_Request_ConfigDefaultLabel method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:title forKey:@"title"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}


/// 举报
/// - Parameters:
///   - relationID: 相关ID（用户ID/房间ID）
///   - content: 内容
///   - images: 图片
///   - isUGCRoomOwner: 是否是UGC房间房主
///   - aCompletion: 回调
+ (void)xyf_requestReport:(NSInteger)relationID
                  content:(NSString *)content
                   images:(NSArray *)images
           isUGCRoomOwner:(BOOL)isUGCRoomOwner
               completion:(XYLApiCompletion)aCompletion {
    NSString *url = isUGCRoomOwner ? kXYL_Request_UGCReportRoom : kXYL_Request_ReportUser;
    
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (isUGCRoomOwner) {
        [dic setObject:@(relationID) forKey:@"roomId"];
        [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    } else {
        [dic setObject:@(relationID) forKey:@"targetAccountId"];
        [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    }
    
    model.xyp_queryDic = dic;
    NSMutableDictionary *bodyDic = [NSMutableDictionary dictionary];
    [bodyDic setObject:content forKey:@"content"];
    [bodyDic setObject:images forKey:@"images"];
    model.xyp_bodyDic = bodyDic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}


/// 拉黑用户
/// - Parameters:
///   - accountID: 用户ID
///   - isBlock: 是否是拉黑
///   - aCompletion: 回调
+ (void)xyf_requestBlockUser:(NSInteger)accountID
                     isBlock:(BOOL)isBlock
                  completion:(XYLApiCompletion)aCompletion {
    NSString *url = isBlock ? kXYL_Request_BlockUser : kXYL_Request_CancelBlockUser;
    OWLMusicRequestApiModel *model = [OWLMusicRequestApiModel xyf_configApiWithUrl:url method:kOWLJRequestMethodPost];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(accountID) forKey:@"targetAccountId"];
    [dic setObject:OWLJConvertToolShared.xyf_userSession?:@"" forKey:@"session"];
    model.xyp_queryDic = dic;
    [self xyf_requestApiWithModel:model completion:aCompletion];
}

@end
