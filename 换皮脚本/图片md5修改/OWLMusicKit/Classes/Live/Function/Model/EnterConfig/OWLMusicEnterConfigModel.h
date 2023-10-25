//
//  OWLMusicEnterConfigModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicEnterConfigModel : NSObject

/// 房间id
@property (nonatomic, assign) NSInteger xyp_roomId;
/// 声网房间号
@property (nonatomic, copy) NSString *xyp_agoraRoomId;
/// 主播ID
@property (nonatomic, assign) NSInteger xyp_anchorID;
/// 是否是UGC房间
@property (nonatomic, assign) BOOL xyp_isUGCRoom;
/// 来源
@property (nonatomic, assign) XYLOutDataSourceEnterRoomType xyp_fromWay;

@end

NS_ASSUME_NONNULL_END
