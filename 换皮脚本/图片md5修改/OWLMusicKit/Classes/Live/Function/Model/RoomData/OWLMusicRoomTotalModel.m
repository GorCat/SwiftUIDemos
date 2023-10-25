//
//  OWLMusicRoomTotalModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

/**
 * @功能描述：直播间房间模型 - 完整房间数据
 * @创建时间：2023.2.17
 * @创建人：许琰
 */

#import "OWLMusicRoomTotalModel.h"
#import "OWLMusicBroadcastModel.h"

@implementation OWLMusicRoomTotalModel

- (void)setXyp_detailModel:(OWLMusicRoomDetailModel *)xyp_detailModel {
    _xyp_detailModel = xyp_detailModel;
    if (_xyp_detailModel != nil) {
        if (self.xyp_tempModel == nil) {
            self.xyp_tempModel = [[OWLMusicRoomTempModel alloc] init];
        }
        self.xyp_tempModel.xyp_roomId = _xyp_detailModel.dsb_roomID;
        self.xyp_tempModel.xyp_agoraRoomId = _xyp_detailModel.dsb_rtcRoomID;
        self.xyp_tempModel.xyp_anchorID = _xyp_detailModel.dsb_ownerAccountID;
        self.xyp_tempModel.xyp_cover = _xyp_detailModel.dsb_cover;
        self.xyp_tempModel.xyp_nickname = _xyp_detailModel.dsb_ownerNickname;
    }
}

/// 根据房间详情模型创建一个房间模型
+ (OWLMusicRoomTotalModel *)xyf_configModelWithDetail:(OWLMusicRoomDetailModel *)detailModel {
    OWLMusicRoomTotalModel *model = [[OWLMusicRoomTotalModel alloc] init];
    model.xyp_detailModel = detailModel;
    
    return model;
}

/// 根据pk模型生成一个房间模型（在跳转到对方页面时使用）
+ (OWLMusicRoomTotalModel *)xyf_configModelWithPkPlayerModel:(OWLMusicRoomPKPlayerModel *)pkModel {
    OWLMusicRoomTotalModel *model = [OWLMusicRoomTotalModel new];
    OWLMusicRoomTempModel *xyp_tempModel = [[OWLMusicRoomTempModel alloc] init];
    xyp_tempModel.xyp_roomId = pkModel.dsb_roomID;
    xyp_tempModel.xyp_agoraRoomId = pkModel.dsb_rtcRoomID;
    xyp_tempModel.xyp_anchorID = pkModel.dsb_accountID;
    xyp_tempModel.xyp_cover = pkModel.dsb_cover;
    xyp_tempModel.xyp_nickname = pkModel.dsb_nickname;
    model.xyp_tempModel = xyp_tempModel;
    
    return model;
}

/// 根据广播模型生成一个房间模型（在跳转到对方页面时使用）
+ (OWLMusicRoomTotalModel *)xyf_configModelWithBroadcastModel:(OWLMusicBroadcastModel *)broadcastModel {
    OWLMusicRoomTotalModel *model = [OWLMusicRoomTotalModel new];
    OWLMusicRoomTempModel *xyp_tempModel = [[OWLMusicRoomTempModel alloc] init];
    xyp_tempModel.xyp_roomId = broadcastModel.xyp_roomId;
    xyp_tempModel.xyp_agoraRoomId = broadcastModel.xyp_agoraRoomId;
    xyp_tempModel.xyp_anchorID = broadcastModel.xyp_recieverUserId;
    xyp_tempModel.xyp_cover = broadcastModel.xyp_roomCover;
    xyp_tempModel.xyp_nickname = broadcastModel.xyp_recieverName;
    
    model.xyp_tempModel = xyp_tempModel;
    return model;
}

/// 更新房间ID
- (void)xyf_updateRoomID:(NSInteger)roomID {
    self.xyp_tempModel.xyp_roomId = roomID;
    self.xyp_detailModel.dsb_roomID = roomID;
}

/// 更新封面
- (void)xyf_updateCover:(NSString *)cover {
    self.xyp_tempModel.xyp_cover = cover;
    self.xyp_detailModel.dsb_cover = cover;
}

/// 获取房主ID
- (NSInteger)xyf_getOwnerID {
    return self.xyp_detailModel.dsb_ownerAccountID > 0 ? self.xyp_detailModel.dsb_ownerAccountID : self.xyp_tempModel.xyp_anchorID;
}

/// 房间ID
- (NSInteger)xyf_getRoomID {
    return self.xyp_detailModel.dsb_roomID > 0 ? self.xyp_detailModel.dsb_roomID : self.xyp_tempModel.xyp_roomId;
}

/// 声网ID
- (NSString *)xyf_getRTCRoomID {
    return self.xyp_detailModel.dsb_rtcRoomID.length > 0 ? self.xyp_detailModel.dsb_rtcRoomID : self.xyp_tempModel.xyp_agoraRoomId;
}

- (BOOL)xyp_isUGCRoom {
    return self.xyp_detailModel.dsb_isUGCRoom;
}

@end
