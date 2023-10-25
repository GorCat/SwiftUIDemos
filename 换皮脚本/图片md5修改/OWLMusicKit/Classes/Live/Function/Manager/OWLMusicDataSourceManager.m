//
//  OWLMusicDataSourceManager.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLMusicDataSourceManager.h"
#import "OWLMusicRoomListTotalModel.h"
#import "OWLMusicBroadcastModel.h"

@interface OWLMusicDataSourceManager ()

#pragma mark - Data
/// 当前房间的模型
@property (nonatomic, strong) OWLMusicRoomTotalModel *xyp_currentModel;
/// 需要更新的数据列表（为了防止崩溃，在某些情况下，需要更新的数据会先放在这个列表中存在，等一个时机统一刷新）
@property (nonatomic, strong) NSMutableArray *xyp_updateRoomList;
/// 当前房间列表（tableview列表中的数据）
@property (nonatomic, strong) NSMutableArray *xyp_currentRoomList;
/// 当前房间的下标
@property (nonatomic, assign) NSInteger xyp_currentIndex;

#pragma mark - BOOL
/// 是否正在请求房间列表（在请求房间列表的时候 不处理房间新增或者关闭的消息）
@property (nonatomic, assign) BOOL isRequestingList;

@end

@implementation OWLMusicDataSourceManager

#pragma mark - Public
/// 初始化数据管理类（只在进入vc时调用）
- (void)xyf_setupDataManagerWithConfigModel:(OWLMusicEnterConfigModel *)configModel {
    
    OWLMusicRoomTotalModel *model = [[OWLMusicRoomTotalModel alloc] init];
    OWLMusicRoomTempModel *tempModel = [[OWLMusicRoomTempModel alloc] init];
    tempModel.xyp_roomId = configModel.xyp_roomId;
    tempModel.xyp_agoraRoomId = configModel.xyp_agoraRoomId;
    tempModel.xyp_anchorID = configModel.xyp_anchorID;
    tempModel.xyp_enterType = configModel.xyp_fromWay;
    model.xyp_tempModel = tempModel;
    /// 更新当前数据
    self.xyp_currentModel = model;
    self.xyp_currentIndex = 0;
    /// 更新当前ID
    [self xyf_giveCallBackCurrentAnchorID:configModel.xyp_anchorID];
    /// 更新当前房间列表
    [self.xyp_currentRoomList removeAllObjects];
    [self.xyp_currentRoomList addObject:model];
    /// 回调刷新列表
    [self xyf_giveCallBackReloadData];
}

/// 更新房间详情信息（只在joinRoom接口成功调用）
- (void)xyf_updateRoomDetailInfoModel:(OWLMusicRoomDetailModel *)model {
    /// 如果当前房间的主播ID 和 模型的ID 不一致，就返回（防止数据和房间对不上）
    if (self.xyp_currentModel.xyf_getOwnerID != model.dsb_ownerAccountID) {
        return;
    }
    /// 重置房间异常状态
    self.xyp_currentModel.xyp_isUnnormalJoin = NO;
    /// 更新当前模型的房间详情模型
    self.xyp_currentModel.xyp_detailModel = model;
    /// 回调刷新当前房间状态
    [self xyf_giveCallBackUpdateCurrentRoomDetailModel];
}

/// 更新房间异常状态（只在joinRoom接口失败调用）
- (void)xyf_updateRoomUnnormalState:(BOOL)isUnnormal anchorID:(NSInteger)anchorID {
    /// 如果当前房间的主播ID 和 主播ID 不一致，就返回
    if (self.xyp_currentModel.xyf_getOwnerID != anchorID) {
        return;
    }
    /// 设置当前房间异常状态
    self.xyp_currentModel.xyp_isUnnormalJoin = isUnnormal;
}

/// 请求列表（只会在第一次进入房间接口成功之后调用此方法请求房间列表）
- (void)xyf_requestRoomList:(BOOL)isUGCRoom {
    kXYLWeakSelf
    self.isRequestingList = YES;
    [OWLMusicRequestApiManager xyf_requestRoomList:isUGCRoom completion:^(OWLMusicApiResponse * _Nonnull aResponse, NSError * _Nonnull anError) {
        if (aResponse.xyf_success) {
            OWLMusicRoomListTotalModel *model = [[OWLMusicRoomListTotalModel alloc] initWithDictionary:[aResponse.data xyf_objectForKeyNotNil:@"data"]];
            // 在调请求列表的时候 只会有一个房间的数据，所以只需要和当前模型做判断（在请求列表的间隙来消息的话，外部会做拦截。）
            for (OWLMusicRoomDetailModel *roomModel in model.dsb_roomList) {
                /// 如果列表中的模型不是当前模型，就更新到数组中去。是当前房间模型的话 不需要做更新处理，因为有在维护。
                if (roomModel.dsb_ownerAccountID != weakSelf.xyp_currentModel.xyp_tempModel.xyp_anchorID) {
                    OWLMusicRoomTotalModel *totalModel = [[OWLMusicRoomTotalModel alloc] init];
                    totalModel.xyp_detailModel = roomModel;
                    [weakSelf.xyp_currentRoomList addObject:totalModel];
                }
            }
            [weakSelf xyf_giveCallBackReloadData];
        }
        weakSelf.isRequestingList = NO;
    }];
}

/// 滑动更新当前下标
- (void)xyf_switchChangeCurrentIndex:(NSInteger)index fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    /// 更新当前数据
    self.xyp_currentModel = [self.xyp_currentRoomList xyf_objectAtIndexSafe:index];
    self.xyp_currentModel.xyp_tempModel.xyp_enterType = fromWay;
    self.xyp_currentIndex = index;
    /// 更新当前ID
    [self xyf_giveCallBackCurrentAnchorID:[self.xyp_currentModel xyf_getOwnerID]];
    /// 通知刷新
    [self xyf_giveCallBackReloadData];
}

/// 滑动停止之后更新列表
- (void)xyf_refreshListAfterScrollStop:(NSInteger)currentIndex {
    NSInteger index = -1;
    NSMutableArray *newArr = [NSMutableArray array];
    for (OWLMusicRoomTotalModel *model in self.xyp_currentRoomList) {
        index += 1;
        /// 在当前房间之前的数据都会在
        if (index <= currentIndex) {
            [newArr addObject:model];
        } else if (model.xyp_detailModel.xyf_beActive) {
            [newArr addObject:model];
        }
    }
    
    [newArr addObjectsFromArray:self.xyp_updateRoomList];
    self.xyp_currentRoomList = newArr;
    [self.xyp_updateRoomList removeAllObjects];
    /// 通知刷新
    [self xyf_giveCallBackReloadData];
}

/// 添加房间
- (void)xyf_addRoom:(OWLMusicRoomDetailModel *)room {
    /// 如果正在请求房间列表 就直接返回
    if (self.isRequestingList) { return; }
    
    /// 当前列表中的老模型
    OWLMusicRoomTotalModel *currentOldModel = [self xyf_findSameModelWithAccountID:room.dsb_ownerAccountID rtcRoomID:room.dsb_rtcRoomID inList:self.xyp_currentRoomList];
    [currentOldModel xyf_updateRoomID:room.dsb_roomID];
    
    /// 如果当前列表中有对应的房间，就不做处理。因为joinRoom的时候需要重新调接口拿数据。
    if (currentOldModel) { return; }
    /// 生成一个总模型
    OWLMusicRoomTotalModel *model = [[OWLMusicRoomTotalModel alloc] init];
    model.xyp_detailModel = room;
    /// 加到更新列表中去
    [self.xyp_updateRoomList addObject:model];
}

/// 删除房间
- (void)xyf_deleteRoom:(OWLMusicRoomDetailModel *)room {
    /// 如果正在请求房间列表 就直接返回
    if (self.isRequestingList) { return; }
    
    // ---------- 更新列表的刷新 ----------
    /// 需要更新的列表中的老模型
    OWLMusicRoomTotalModel *updateOldModel = [self xyf_findSameModelWithAccountID:room.dsb_ownerAccountID rtcRoomID:room.dsb_rtcRoomID inList:self.xyp_updateRoomList];
    /// 如果存在，则要把更新列表中的数据直接删除
    if (updateOldModel) {
        [self.xyp_updateRoomList removeObject:updateOldModel];
    }
    
    // ---------- 当前列表的刷新 ----------
    /// 更新当前列表的老模型
    OWLMusicRoomTotalModel *currentOldModel = [self xyf_findSameModelWithAccountID:room.dsb_ownerAccountID rtcRoomID:room.dsb_rtcRoomID inList:self.xyp_currentRoomList];
    currentOldModel.xyp_detailModel.dsb_roomState = XYLModuleRoomStateType_Finish;
}

/// 恢复房间
- (void)xyf_resumeRoom:(OWLMusicRoomDetailModel *)room {
    // ---------- 当前列表的刷新 ----------
    /// 当前列表中的老模型
    OWLMusicRoomTotalModel *currentOldModel = [self xyf_findSameModelWithAccountID:room.dsb_ownerAccountID rtcRoomID:room.dsb_rtcRoomID inList:self.xyp_currentRoomList];
    /// 如果当前列表不存在，就插入到更新列表中
    if (!currentOldModel) {
        OWLMusicRoomTotalModel *totalModel = [OWLMusicRoomTotalModel xyf_configModelWithDetail:room];
        [self xyf_addNewRoomToUpdateList:totalModel];
        return;
    }
    
    /// 更新模型
    OWLMusicRoomDetailModel *oldDetail = currentOldModel.xyp_detailModel;
    BOOL isNeedCleanPK = oldDetail.xyf_isPKState;
    room.dsb_isFollowedOwner = oldDetail.dsb_isFollowedOwner;
    room.dsb_memberList = oldDetail.dsb_memberList;
    room.dsb_giftList = oldDetail.dsb_giftList;
    room.dsb_gameConfig = oldDetail.dsb_gameConfig;
    currentOldModel.xyp_detailModel = room;
    
    /// 如果恢复的房间就是当前房间
    if (currentOldModel.xyp_indexInList == self.xyp_currentIndex) {
        [self xyf_giveCallBackResumeRoom:currentOldModel isNeedCleanPK:isNeedCleanPK];
    }
    
}

/// 进入对方房间
- (void)xyf_enterOtherRoom {
    /// 获取当前PK对方数据
    OWLMusicRoomPKPlayerModel *otherPlayer = self.xyp_currentModel.xyp_detailModel.dsb_pkData.dsb_otherPlayer;
    if (!otherPlayer) { return; }
    /// 当前列表中是否有该主播的模型
    OWLMusicRoomTotalModel *currentOldModel = [self xyf_findSameModelWithAccountID:otherPlayer.dsb_accountID rtcRoomID:otherPlayer.dsb_rtcRoomID inList:self.xyp_currentRoomList];
    /// 如果存在，就直接跳转
    if (currentOldModel) {
        /// 更新当前房间数据
        [self xyf_updateCurrentRoom:currentOldModel];
        /// 回调跳转房间
        [self xyf_giveCallBackEnterSomeRoom:YES fromWay:XYLOutDataSourceEnterRoomType_Scroll];
        return;
    }
    /// 如果当前列表中没有该主播的房间，就生成一个房间
    OWLMusicRoomTotalModel *otherNewModel = [OWLMusicRoomTotalModel xyf_configModelWithPkPlayerModel:otherPlayer];
    [self.xyp_currentRoomList addObject:otherNewModel];
    otherNewModel.xyp_indexInList = self.xyp_currentRoomList.count - 1;
    /// 更新当前房间数据
    [self xyf_updateCurrentRoom:otherNewModel];
    /// 回调跳转房间
    [self xyf_giveCallBackEnterSomeRoom:NO fromWay:XYLOutDataSourceEnterRoomType_Scroll];
}

/// 通过横幅进入其他房间
- (void)xyf_enterOtherRoomByBroadcast:(OWLMusicBroadcastModel *)model {
    /// 当前列表中是否有该主播的模型
    OWLMusicRoomTotalModel *currentOldModel = [self xyf_findSameModelWithAccountID:model.xyp_recieverUserId rtcRoomID:model.xyp_agoraRoomId inList:self.xyp_currentRoomList];
    /// 如果存在，就直接跳转
    if (currentOldModel) {
        /// 更新当前房间数据
        [self xyf_updateCurrentRoom:currentOldModel];
        /// 回调跳转房间
        [self xyf_giveCallBackEnterSomeRoom:YES fromWay:XYLOutDataSourceEnterRoomType_Broadcast];
        return;
    }
    /// 如果当前列表中没有该主播的房间，就生成一个房间
    OWLMusicRoomTotalModel *otherNewModel = [OWLMusicRoomTotalModel xyf_configModelWithBroadcastModel:model];
    [self.xyp_currentRoomList addObject:otherNewModel];
    otherNewModel.xyp_indexInList = self.xyp_currentRoomList.count - 1;
    /// 更新当前房间数据
    [self xyf_updateCurrentRoom:otherNewModel];
    /// 回调跳转房间
    [self xyf_giveCallBackEnterSomeRoom:NO fromWay:XYLOutDataSourceEnterRoomType_Broadcast];
}

#pragma mark - Private
/// 更新当前房间信息
- (void)xyf_updateCurrentRoom:(OWLMusicRoomTotalModel *)room {
    self.xyp_currentModel = room;
    self.xyp_currentIndex = room.xyp_indexInList;
    /// 更新当前ID
    [self xyf_giveCallBackCurrentAnchorID:[self.xyp_currentModel xyf_getOwnerID]];
}

/// 向更新列表中添加房间数据
- (void)xyf_addNewRoomToUpdateList:(OWLMusicRoomTotalModel *)room {
    OWLMusicRoomTotalModel *oldUpdateModel = [self xyf_findSameModelWithAccountID:[room xyf_getOwnerID] rtcRoomID:[room xyf_getRTCRoomID] inList:self.xyp_updateRoomList];
    /// 如果更新列表中已经有了，就直接替换
    if (oldUpdateModel) {
        [self.xyp_updateRoomList replaceObjectAtIndex:oldUpdateModel.xyp_indexInList withObject:room];
        return;
    }
    
    /// 如果更新列表中没有，就新增
    [self.xyp_updateRoomList addObject:room];
}

/// 在列表中找到一样的房间模型
/// - Parameters:
///   - accountID: 主播ID
///   - rtcRoomID: 声网房间ID
///   - list: 房间列表
- (OWLMusicRoomTotalModel *)xyf_findSameModelWithAccountID:(NSInteger)accountID
                                                   rtcRoomID:(NSString *)rtcRoomID
                                                      inList:(NSMutableArray *)list {
    __block OWLMusicRoomTotalModel *findModel = nil;
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OWLMusicRoomTotalModel *model = (OWLMusicRoomTotalModel *)obj;
        if (model.xyp_tempModel.xyp_anchorID == accountID || [rtcRoomID isEqualToString:[model xyf_getRTCRoomID]]) {
            findModel = model;
            findModel.xyp_indexInList = idx;
            *stop = YES;
        }
    }];
    
    return findModel;
}

    
#pragma mark - 给回调
/// 需要刷新列表的回调
- (void)xyf_giveCallBackReloadData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerRefreshList)]) {
        [self.delegate xyf_liveDataSourceManagerRefreshList];
    }
}

/// 更新当前房间详情模型的回调
- (void)xyf_giveCallBackUpdateCurrentRoomDetailModel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerUpdateCurrentRoomDetailModel)]) {
        [self.delegate xyf_liveDataSourceManagerUpdateCurrentRoomDetailModel];
    }
}

/// 操作某个数据
- (void)xyf_giveCallBackOperateData:(NSInteger)index isDelete:(BOOL)isDelete {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerOperateData:isDelete:)]) {
        [self.delegate xyf_liveDataSourceManagerOperateData:index isDelete:isDelete];
    }
}

/// 跳转到某直播间
- (void)xyf_giveCallBackEnterSomeRoom:(BOOL)isAlreadyHas fromWay:(XYLOutDataSourceEnterRoomType)fromWay {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerEnterOtherRoom:fromWay:)]) {
        [self.delegate xyf_liveDataSourceManagerEnterOtherRoom:isAlreadyHas fromWay:fromWay];
    }
}

/// 刷新恢复的房间
- (void)xyf_giveCallBackResumeRoom:(OWLMusicRoomTotalModel *)resumeModel isNeedCleanPK:(BOOL)isNeedCleanPK {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerResumeRoom:isNeedCleanPK:)]) {
        [self.delegate xyf_liveDataSourceManagerResumeRoom:resumeModel isNeedCleanPK:isNeedCleanPK];
    }
}

/// 刷新当前主播ID
- (void)xyf_giveCallBackCurrentAnchorID:(NSInteger)anchorID {
    if (self.delegate && [self.delegate respondsToSelector:@selector(xyf_liveDataSourceManagerUpdateCurrentAnchorID:)]) {
        [self.delegate xyf_liveDataSourceManagerUpdateCurrentAnchorID:anchorID];
    }
}

#pragma mark - Lazy
- (NSMutableArray *)xyp_currentRoomList {
    if (!_xyp_currentRoomList) {
        _xyp_currentRoomList = [[NSMutableArray alloc] init];
    }
    return _xyp_currentRoomList;
}

- (NSMutableArray *)xyp_updateRoomList {
    if (!_xyp_updateRoomList) {
        _xyp_updateRoomList = [[NSMutableArray alloc] init];
    }
    return _xyp_updateRoomList;
}

@end
