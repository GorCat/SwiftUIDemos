//
//  OWLMusicAgoraManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

#import "OWLMusicAgoraManager.h"
#import "OWLMusicVideoContainerView.h"

@interface OWLMusicAgoraManager () <AgoraRtcEngineDelegate, AgoraRtmChannelDelegate>

/// RTC
@property (nonatomic, strong) AgoraRtcEngineKit * _Nullable xyp_rtcEngine;
/// RTM
@property (nonatomic, strong) AgoraRtmKit * _Nullable xyp_rtmKit;
/// RTMChannel
@property (nonatomic, strong) AgoraRtmChannel * _Nullable xyp_rtmChannel;

@end

@implementation OWLMusicAgoraManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.xyp_rtcEngine = OWLJConvertToolShared.xyf_rtcKit;
        self.xyp_rtmKit = OWLJConvertToolShared.xyf_rtmKit;
    }
    return self;
}

#pragma mark - Public
/// 设置rtc参数(每次进直播间第一次调用)
- (void)xyf_configRTCEngine {
//    AgoraVideoEncoderConfiguration *encoder = [AgoraVideoEncoderConfiguration new];
//    encoder.frameRate = AgoraVideoFrameRateFps24;
//    encoder.bitrate = AgoraVideoBitrateStandard;
//    encoder.orientationMode = AgoraVideoOutputOrientationModeAdaptative;
//    encoder.mirrorMode = AgoraVideoMirrorModeAuto;
//    encoder.dimensions = AgoraVideoDimension840x480;
//    [self.xyp_rtcEngine setVideoEncoderConfiguration:encoder];
    [self.xyp_rtcEngine setClientRole:AgoraClientRoleAudience];
    [self.xyp_rtcEngine setParameters:@"{\"che.video.keepLastFrame\":false}"];
}

/// 离开房间
- (void)xyf_leaveRoomWithChannelID:(NSString *)channelID {
    [self xyf_leaveRtmChannel];
}

/// 加入房间设置视频（在加入房间接口调成功之后调用）
- (void)xyf_setupVideoAfterJoinRoom:(OWLMusicRoomDetailModel *)roomModel {
    if (roomModel.dsb_pkData) { /// 如果是PK
        /// 设置自己主播的画面
        [self xyf_startRemoteViewWithAccountID:roomModel.dsb_ownerAccountID isMine:YES cover:roomModel.dsb_cover avatar:roomModel.dsb_ownerAvatar];
        /// 设置对方主播的画面
        [self xyf_startRemoteViewWithAccountID:roomModel.dsb_pkData.dsb_otherPlayer.dsb_accountID isMine:NO cover:roomModel.dsb_pkData.dsb_otherPlayer.dsb_cover avatar:roomModel.dsb_pkData.dsb_otherPlayer.dsb_avatar];
        /// 更新大小
        [self.xyp_videoContainerView xyf_changeVideoSize:YES];
        /// 改画中画pk状态
        [self.xyp_pipManager zoepip_isPK:YES];
    } else { /// 单人
        /// 清除对方幕布上的画面
        [self xyf_cleanRemoteView:NO];
        /// 设置自己主播的画面
        [self xyf_startRemoteViewWithAccountID:roomModel.dsb_ownerAccountID isMine:YES cover:roomModel.dsb_cover avatar:roomModel.dsb_ownerAvatar];
        /// 更新大小
        [self.xyp_videoContainerView xyf_changeVideoSize:NO];
        /// 改画中画pk状态
        [self.xyp_pipManager zoepip_isPK:NO];
    }
}

/// 清除幕布上的画面
- (void)xyf_cleanRemoteViewWithUid:(NSInteger)uid {
    /// 获取当前画面自己主播的ID
    NSInteger mineID = [self xyf_getVideoViewAccountID:YES];
    /// 获取当前画面对面主播的ID
    NSInteger otherID = [self xyf_getVideoViewAccountID:NO];
    if (uid == mineID) {
        [self xyf_cleanRemoteView:YES];
    } else if (uid == otherID) {
        [self xyf_cleanRemoteView:NO];
    }
}

/// 清除幕布上的画面
- (void)xyf_cleanRemoteView:(BOOL)isMine {
    /// 获取当前画面上的ID
    NSInteger currentID = [self xyf_getVideoViewAccountID:isMine];
    /// 如果为0 说明幕布上没有画面 不需要清除
    if (currentID == 0) { return; }
    /// 停止远端画面
    [self xyf_cleanRemoteViewWithUserID:currentID];
    /// 对应的视图
    OWLMusicVideoPreview *view = [self xyf_getAnchorView:isMine];
    /// 清空视图
    [view xyf_resetView];
}

/// 拉取幕布上的画面
- (void)xyf_startRemoteViewWithAccountID:(NSInteger)accountID isMine:(BOOL)isMine cover:(NSString *)cover avatar:(NSString *)avatar {
    /// 获取当前画面上的ID
    NSInteger currentID = [self xyf_getVideoViewAccountID:isMine];
    /// 设置视图的封面
    [[self xyf_getAnchorView:isMine] xyf_setCover:cover isClean:NO];
    /// 设置头像
    [self xyf_getAnchorView:isMine].xyp_avatar = avatar;
    /// 如果 视图上的ID == 需要拉流的ID 就不做处理
    if (currentID == accountID) { return; }
    /// 如果 视图上的ID > 0 并且 !=需要拉流的ID 就要先停止当前ID的远端画面
    if (currentID > 0 && currentID != accountID) {
        [self xyf_cleanRemoteViewWithUserID:currentID];
    }
    /// 拉取远端画面
    [self xyf_startRemoteView:[self xyf_getVideoRemoteView:isMine] userID:accountID];
    /// 设置视图的ID
    [self xyf_getAnchorView:isMine].xyp_accountID = accountID;
}

/// 判断是否需要拉取对面主播远端画面（此方法 在RTC回调didJoinedOfUid中调用）(xytodo 最后删掉 目前在rtc来流的时候 只拉取自己主播的画面 不拉取对方主播的画面 xytodo数据为准)
/// - Parameters:
///   - uid: rtc回调中的ID
///   - currentOtherID: 当前房间的对面主播的id
//- (BOOL)xyf_judgeIsNeedStartOtherRemoteViewWhenRTCJoined:(NSInteger)uid {
//    BOOL isStartRemote = NO;
//    /// 获取当前房间模型
//    OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
//    /// 获取当前房间的对方主播ID
//    NSInteger otherAccountID = currentModel.xyp_detailModel.dsb_pkData.dsb_otherPlayer.dsb_accountID;
//
//    if (otherAccountID == uid) {
//        /// 如果就是对方主播的流 就直接拉取画面
//        isStartRemote = YES;
//    } else if (currentModel.xyp_detailModel == nil) {
//        /// 如果模型中还没有详情数据 先展示画面（说明接口还没有请求到，先展示视频画面，等接口请求之后，会有视频流的校正）
//        isStartRemote = YES;
//    }
//
//    return isStartRemote;
//}

/// 发送本地消息
- (void)xyf_sendLocalMsg:(OWLMusicMessageModel *)message {
    [self xyf_giveCallBackReceiveRTMChannelMsg:message];
}

/// 重置远端的视频画面
- (void)xyf_resetRemoteView {
    /// 清除自己主播视图上的画面
    [self xyf_cleanRemoteView:YES];
    /// 清除对面主播视图上的画面
    [self xyf_cleanRemoteView:NO];
    /// 更新大小（默认先显示单人直播）
    [self.xyp_videoContainerView xyf_changeVideoSize:NO];
    /// 改画中画pk状态
    [self.xyp_pipManager zoepip_isPK:NO];
}

/// 拉取对面的视频流 并改变大小
- (void)xyf_startOtherRemoteViewAndChangeSize:(OWLMusicRoomPKDataModel *)model {
    /// 拉流
    [self xyf_startRemoteViewWithAccountID:model.dsb_otherPlayer.dsb_accountID isMine:NO cover:model.dsb_otherPlayer.dsb_cover avatar:model.dsb_otherPlayer.dsb_avatar];
    /// 更新大小
    [self.xyp_videoContainerView xyf_changeVideoSize:YES];
    /// 改画中画pk状态
    [self.xyp_pipManager zoepip_isPK:YES];
}

/// 停止对面的视频流 并改变大小
- (void)xyf_stopOtherRemoteViewAndChangeSize {
    /// 停止流
    [self xyf_cleanRemoteView:NO];
    /// 更新大小
    [self.xyp_videoContainerView xyf_changeVideoSize:NO];
    /// 改画中画pk状态
    [self.xyp_pipManager zoepip_isPK:NO];
}

#pragma mark - Private
/// 隐藏/显示视频画面
- (void)xyf_muteVideo:(BOOL)mute uid:(NSInteger)uid {
    [XYCUtil xyf_doInMain:^{
        if (uid == [self xyf_getVideoViewAccountID:YES]) {
            [self xyf_getVideoRemoteView:YES].hidden = mute;
        } else if (uid == [self xyf_getVideoViewAccountID:NO]) {
            [self xyf_getVideoRemoteView:NO].hidden = mute;
        }
    }];
}

/// 控制对方音频按钮的状态
- (void)xyf_changeOtherViewVoiceState:(BOOL)isMute {
    [self xyf_getAnchorView:NO].xyp_isMuted = isMute;
}

/// 显示/隐藏关摄像头视图
- (void)xyf_changeCameraOffState:(BOOL)isCameraOff uid:(NSInteger)uid {
    [XYCUtil xyf_doInMain:^{
        OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
        BOOL isMineAnchorID = (uid == [self xyf_getVideoViewAccountID:YES]) || (uid == [currentModel xyf_getOwnerID]);
        if (isMineAnchorID) {
            [self xyf_getAnchorView:YES].xyp_isCameraOff = isCameraOff;
        } else {
            [self xyf_getAnchorView:NO].xyp_isCameraOff = isCameraOff;
        }
    }];
}

#pragma mark - Getter
/// 获取主播视图
- (OWLMusicVideoPreview *)xyf_getAnchorView:(BOOL)isMine {
    if (isMine) {
        return self.xyp_videoContainerView.xyp_mineAnchorView;
    } else {
        return self.xyp_videoContainerView.xyp_otherAnchorView;
    }
}

/// 获取主播视频承载画面
- (UIView *)xyf_getVideoRemoteView:(BOOL)isMine {
    return [self xyf_getAnchorView:isMine].xyf_getVideoPreview;
}

/// 获取主播视图画面对应的ID
- (NSInteger)xyf_getVideoViewAccountID:(BOOL)isMine {
    return [self xyf_getAnchorView:isMine].xyp_accountID;
}

#pragma mark - RTC
/// 加入RTC房间
- (void)xyf_enterRTCRoom:(NSString *)channelID {
    // xytodo 这边可能会有一些判断
    [self.xyp_rtcEngine joinChannelByToken:nil channelId:channelID info:nil uid:OWLJConvertToolShared.xyf_userAccountID joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
    self.xyp_rtcEngine.delegate = self;
}

/// 退出RTC房间
- (void)xyf_exitRTCRoom {
    [self.xyp_rtcEngine leaveChannel:nil];
}

/// 切换房间
- (void)xyf_switchRTCRoom:(NSString *)channelID {
    /// 重置远端的画面和大小
    [self xyf_resetRemoteView];
    /// RTC切换房间
    [self.xyp_rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        [self.xyp_rtcEngine joinChannelByToken:nil channelId:channelID info:nil uid:OWLJConvertToolShared.xyf_userAccountID joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            
        }];
    }];
}

/// 开始拉取并显示指定用户的远端画面
- (void)xyf_startRemoteView:(UIView *)view userID:(NSInteger)userID {
    if (view == nil || userID == 0) {
        return;
    }
    
    AgoraRtcVideoCanvas *canvas = [AgoraRtcVideoCanvas new];
    canvas.view = view;
    canvas.uid = userID;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    [self.xyp_rtcEngine setupRemoteVideo:canvas];
}

/// 停止拉取用户的远端画面
- (void)xyf_cleanRemoteViewWithUserID:(NSInteger)userID {
    AgoraRtcVideoCanvas *canvas = [AgoraRtcVideoCanvas new];
    canvas.view = nil;
    canvas.uid = userID;
    canvas.renderMode = AgoraVideoRenderModeHidden;
    [self.xyp_rtcEngine setupRemoteVideo:canvas];
}

#pragma mark - RTMChannel
/// 初始化RTMChannel
- (void)xyf_setupRTMChannel:(NSString *)channelID todo:(NSString *)todo completion:(void(^)(BOOL success))completion {
    [self xyf_leaveRtmChannel];
    AgoraRtmChannel *channel = [self.xyp_rtmKit createChannelWithId:channelID delegate:self];
    kXYLWeakSelf
    [channel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmJoinChannelErrorOk) {
            NSLog(@"加入房间 channelID = %@, todo = %@",channelID, todo);
            OWLMusicRoomTotalModel *currentModel = [weakSelf.dataSource xyf_subManagerGetCurrentRoomModel];
            /// 如果加入的channelID和当前房间的ID 不一样 就不发消息
            if (![channelID isEqualToString:[currentModel xyf_getRTCRoomID]]) {
                return;
            }
            /// 系统提示
            [self xyf_sendLocalMsg:[OWLMusicMessageModel xyf_getSystemTipMsg]];
            /// 加入房间
            [self xyf_sendLocalMsg:[OWLMusicMessageModel xyf_getJoinRoomMsg]];
            /// 加入房间发给别人
            [self xyf_sendMessage:[OWLMusicMessageModel xyf_getJoinRoomMsg]];
        }
        if (completion) { completion(errorCode == AgoraRtmJoinChannelErrorOk); }
    }];
    self.xyp_rtmChannel = channel;
}

/// 离开RTMChannel
- (void)xyf_leaveRtmChannel {
    if (self.xyp_rtmChannel) {
        [self.xyp_rtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
            
        }];
        self.xyp_rtmChannel.channelDelegate = nil;
        self.xyp_rtmChannel = nil;
    }
}

/// 发送频道消息
- (void)xyf_sendMessage:(OWLMusicMessageModel *)message {
    NSDictionary *dic = [message mj_JSONObject];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if ([[mutDic allKeys] containsObject:@"dsb_dictionary"]) {
        [mutDic removeObjectForKey:@"dsb_dictionary"];
    }
    
    NSData *data = [mutDic mj_JSONData];
    AgoraRtmRawMessage *rawMsg = [[AgoraRtmRawMessage alloc] initWithRawData:data description:@"iOS"];
    [self.xyp_rtmChannel sendMessage:rawMsg completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
        if (errorCode == AgoraRtmSendChannelMessageErrorOk) {
            NSLog(@"xytest 发送成功");
        }
    }];
}

/// 获取房间内封禁消息
- (void)xyf_getChannelAttWithRoomID:(NSString *)channelID {
    kXYLWeakSelf
    [self.xyp_rtmKit getChannelAllAttributes:channelID completion:^(NSArray<AgoraRtmChannelAttribute *> * _Nullable attributes, AgoraRtmProcessAttributeErrorCode errorCode) {
        [weakSelf xyf_dealCustomAtt:attributes];
    }];
}

/// 处理自定义消息
- (void)xyf_dealCustomAtt:(NSArray<AgoraRtmChannelAttribute *> * _Nullable)attributes {
    for (AgoraRtmChannelAttribute *attribute in attributes) {
        if ([attribute.key isEqualToString:@"muteOpAudio"]) {
            // PK对方主播开关麦状态
            OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
            BOOL isMuted = ![attribute.value isEqualToString:@"false"];
            if (currentModel.xyp_detailModel.xyf_isPKState) {
                [self.xyp_rtcEngine muteRemoteAudioStream:currentModel.xyp_detailModel.dsb_pkData.dsb_otherPlayer.dsb_accountID mute:isMuted];
            }
            [self xyf_changeOtherViewVoiceState:isMuted];
        } else if ([attribute.key isEqualToString:@"muteOpVideo"]) {
            // PK对方主播开关视频状态
            OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
            BOOL isMuted = ![attribute.value isEqualToString:@"false"];
            NSInteger otherID = currentModel.xyp_detailModel.dsb_pkData.dsb_otherPlayer.dsb_accountID;
            if (currentModel.xyp_detailModel.xyf_isPKState) {
                [self.xyp_rtcEngine muteRemoteVideoStream:otherID mute:isMuted];
            }
            [self xyf_muteVideo:isMuted uid:otherID];
        }
    }
}

#pragma mark - AgoraRtcEngineDelegate
/// 用户加入
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    // ---- 之前在收到rtc的流的时候 需要直接更新到页面上 不等数据 现在等数据 xytodo数据为准 ----
    
//    /// 获取当前房间模型
//    OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
//    /// 判断这个流是不是当前房间中的主播
//    BOOL isMineAnchor = currentModel.xyp_tempModel.xyp_anchorID == uid;
//    if (isMineAnchor) { /// 如果是 就直接拉取远端视频画面
//        [self xyf_startRemoteView:uid isMine:YES];
//    } else {
//        /// 判断是否需对方主播的远端视频画面
//        if ([self xyf_judgeIsNeedStartOtherRemoteViewWhenRTCJoined:uid]) {
//            [self xyf_startRemoteView:uid isMine:NO];
//        }
//    }
//    /// 更新视图大小
//    [self.xyp_videoContainerView xyf_audoChangeVideoSize];
    
//    /// 获取当前房间模型
//    OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
//    /// 判断这个流是不是当前房间中的主播
//    BOOL isMineAnchor = currentModel.xyp_tempModel.xyp_anchorID == uid;
//    if (isMineAnchor) { /// 如果是 就直接拉取远端视频画面
//        [self xyf_startRemoteView:uid isMine:YES cover:currentModel.xyp_tempModel.xyp_cover];
//    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed {
    /// 获取当前房间模型
    OWLMusicRoomTotalModel *currentModel = [self.dataSource xyf_subManagerGetCurrentRoomModel];
    /// 判断这个流是不是当前房间中的主播
    BOOL isMineAnchor = currentModel.xyp_tempModel.xyp_anchorID == uid;
    if (isMineAnchor) { /// 如果是 就直接拉取远端视频画面
        [self xyf_startRemoteViewWithAccountID:uid isMine:YES cover:currentModel.xyp_tempModel.xyp_cover avatar:currentModel.xyp_detailModel.dsb_ownerAvatar];
    }
}

/// 用户离开
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    
    // ---- 之前在收到rtc退出的时候 需要直接将两人视频模式变成一人的视频模式 现在等数据 xytodo数据为准----
//    /// 清除远端画面
//    [self xyf_cleanRemoteView:NO];
//    /// 更新视图大小
//    [self.xyp_videoContainerView xyf_audoChangeVideoSize];
    NSInteger anchorID = [self xyf_getVideoViewAccountID:NO];
    if (uid == anchorID) {
        // 过5s检测（正常PK结束的通知会在5s内反馈，则不处理以下代码）
        kXYLWeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            OWLMusicRoomTotalModel *currentModel = [weakSelf.dataSource xyf_subManagerGetCurrentRoomModel];
            if (currentModel.xyp_detailModel.dsb_pkData && currentModel.xyp_detailModel.dsb_pkData.dsb_otherPlayer.dsb_accountID == uid) {
                [OWLMusicRequestApiManager xyf_requestRoomInfoWithRoomID:currentModel.xyf_getRoomID isUGCRoom:currentModel.xyp_isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
                    if (aResponse.xyf_success) {
                        OWLMusicRoomDetailModel *model = [[OWLMusicRoomDetailModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
                        [weakSelf xyf_sendLocalMsg:[OWLMusicMessageModel xyf_getUpdateInfoMsg:model]];
                    }
                }];
            }
        });
    }
    
    /// 清除远端画面
    [self xyf_cleanRemoteViewWithUid:uid];
}

/// 禁视频
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid {
    [self xyf_muteVideo:muted uid:uid];
    [self xyf_changeCameraOffState:muted uid:uid];
}

/// 禁语音
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid {
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine connectionChangedToState:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason {
    
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine remoteVideoStateChangedOfUid:(NSUInteger)uid state:(AgoraVideoRemoteState)state reason:(AgoraVideoRemoteReason)reason elapsed:(NSInteger)elapsed {
    [self xyf_changeCameraOffState:reason == AgoraVideoRemoteReasonRemoteMuted uid:uid];
}

#pragma mark - AgoraRtmChannelDelegate
- (void)channel:(AgoraRtmChannel *)channel messageReceived:(AgoraRtmMessage *)message fromMember:(AgoraRtmMember *)member {
    AgoraRtmRawMessage *rawMsg = (AgoraRtmRawMessage *)message;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:rawMsg.rawData options:NSJSONReadingMutableLeaves error:nil];
    OWLMusicMessageModel *ruleMsg = [[OWLMusicMessageModel alloc] initWithDictionary:dict];
    [self xyf_giveCallBackReceiveRTMChannelMsg:ruleMsg];
}

- (void)channel:(AgoraRtmChannel *)channel attributeUpdate:(NSArray<AgoraRtmChannelAttribute *> *)attributes {
    [self xyf_dealCustomAtt:attributes];
}

#pragma mark - 给回调
/// 收到RTMChannel消息
- (void)xyf_giveCallBackReceiveRTMChannelMsg:(OWLMusicMessageModel *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_roomModuleManagerRTMChannelReceiveMessage:)]) {
        [self.delegate xyf_roomModuleManagerRTMChannelReceiveMessage:message];
    }
}

@end
