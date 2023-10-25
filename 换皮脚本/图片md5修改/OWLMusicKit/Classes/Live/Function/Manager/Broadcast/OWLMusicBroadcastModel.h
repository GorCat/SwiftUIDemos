//
//  OWLMusicBroadcastModel.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/28.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYLBroadcastShowType) {
    XYLBroadcastShowTypeTake = 1,///带走横幅
    XYLBroadcastShowTypeGift,///全频道横幅
};

typedef NS_ENUM(NSInteger, XYLBroadcastFromType) {
    XYLBroadcastFromTypeNone = 0,
    XYLBroadcastFromTypeChatRoom,
    XYLBroadcastFromTypeLive,
    XYLBroadcastFromTypeUGC,
};

typedef NS_ENUM(NSInteger, XYLBroadcastCellState) {
    XYLBroadcastCellStateWait,
    XYLBroadcastCellStateEnter,
    XYLBroadcastCellStateShow,
    XYLBroadcastCellStateExit,
    XYLBroadcastCellStateEnd,
};


@interface OWLMusicBroadcastModel : OWLBGMModuleBaseModel

@property (nonatomic, copy) NSString * xyp_senderAvatar;
@property (nonatomic, copy) NSString * xyp_senderName;
@property (nonatomic, assign) NSInteger xyp_senderUserId;

@property (nonatomic, copy) NSString * xyp_recieverAvatar;
@property (nonatomic, copy) NSString * xyp_recieverName;
@property (nonatomic, assign) NSInteger xyp_recieverUserId;

@property (nonatomic, copy) NSString * xyp_giftName;
@property (nonatomic, copy) NSString * xyp_giftIconUrl;

@property (nonatomic, copy) NSString * xyp_agoraRoomId;
@property (nonatomic, assign) NSInteger xyp_roomId;
@property (nonatomic, copy) NSString * xyp_roomCover;
@property (nonatomic, assign) XYLBroadcastShowType xyp_showType;
@property (nonatomic, assign) XYLBroadcastFromType xyp_fromType;

@property (nonatomic, assign) XYLBroadcastCellState xyp_state;

@property (nonatomic, assign, readonly) float moveDuration;

@property (nonatomic, assign, readonly) float stayDuration;

@property (nonatomic, assign) float fastStayDuration;

@property(nonatomic,copy)void(^refreshUIBlock)(void);//刷新UI

- (NSMutableAttributedString *)xyp_giftContentAttr;

- (NSMutableAttributedString *)xyp_takeContentAttr;



- (instancetype)initTakeModelWithRoomID:(NSInteger)xyp_roomId userName:(NSString *)xyp_userName userAvatar:(NSString *)xyp_userAvatar anchorName:(NSString *)xyp_anchorName anchorAvatar:(NSString *)xyp_anchorAvatar;

@end

NS_ASSUME_NONNULL_END
