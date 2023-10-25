//
//  OWLMusicRequestApiManager.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

/**
 * @功能描述：直播间网络请求工具类
 * @创建时间：2023.2.17
 * @创建人：许琰
 */

#import <Foundation/Foundation.h>
#import "OWLMusicApiResponse.h"
#import "XYCAPIDef.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^XYLApiCompletion)(OWLMusicApiResponse *aResponse, NSError *anError);

@interface OWLMusicRequestApiManager : NSObject


/// 加入房间
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestJoinRoomWithHostID:(NSInteger)hostID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion;


/// 离开房间
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestLeaveRoomWithRoomID:(NSInteger)roomID
                             isUGCRoom:(BOOL)isUGCRoom
                            completion:(XYLApiCompletion)aCompletion;


/// 获取房间信息
/// - Parameters:
///   - roomID: 房间ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestRoomInfoWithRoomID:(NSInteger)roomID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion;


/// 获取视频聊天室列表
/// - Parameters:
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestRoomList:(BOOL)isUGCRoom
                 completion:(XYLApiCompletion)aCompletion;


/// 获取PK房间送礼列表
/// - Parameters:
///   - anchorID: 主播ID
///   - roomID: 房间ID
///   - aCompletion: 回调
+ (void)xyf_requestPKTopListWithAnchorID:(NSInteger)anchorID
                                  roomID:(NSInteger)roomID
                              completion:(XYLApiCompletion)aCompletion;


/// 用户送礼
/// - Parameters:
///   - roomID: 房间ID
///   - giftID: 礼物ID
///   - isUGCRoom: 是否是UGC房间
///   - aCompletion: 回调
+ (void)xyf_requestSendGiftWithRoomID:(NSInteger)roomID
                               giftID:(NSInteger)giftID
                            isUGCRoom:(BOOL)isUGCRoom
                           completion:(XYLApiCompletion)aCompletion;


/// 设置礼物已阅
/// - Parameters:
///   - title: 礼物标题
///   - aCompletion: 回调
+ (void)xyf_requestSeeGiftWithTitle:(NSString *)title
                         completion:(XYLApiCompletion)aCompletion;

/// 发消息掉接口
/// - Parameters:
///   - text: 文案
///   - roomID: 房间ID
///   - aCompletion: 回调
+ (void)xyf_requestSendText:(NSString *)text
                     roomID:(NSInteger)roomID
                 completion:(XYLApiCompletion)aCompletion;


/// 获取禁言列表
/// - Parameters:
///   - rtcRoomID: 声网roomID
///   - isUGCRoom: 是否是ugc房间
///   - aCompletion: 回调
+ (void)xyf_requestMutedMembers:(NSString *)rtcRoomID
                      isUGCRoom:(BOOL)isUGCRoom
                     completion:(XYLApiCompletion)aCompletion;


/// 用户带走主播
/// - Parameters:
///   - roomID: 房间id
///   - giftID: 礼物ID
///   - aCompletion: 回调
+ (void)xyf_requestTakeAnchor:(NSInteger)roomID giftID:(NSInteger)giftID completion:(XYLApiCompletion)aCompletion;

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
                    completion:(XYLApiCompletion)aCompletion;


/// 获取活动标签列表
/// - Parameters:
///   - accountID: 账号ID
///   - aCompletion: 回调
+ (void)xyf_requestEventLabelList:(NSInteger)accountID completion:(XYLApiCompletion)aCompletion;


/// 设置默认活动标签
/// - Parameters:
///   - title: 标签标题
///   - aCompletion: 回调
+ (void)xyf_requestSetDefaultLabel:(NSString *)title completion:(XYLApiCompletion)aCompletion;


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
               completion:(XYLApiCompletion)aCompletion;


/// 拉黑用户
/// - Parameters:
///   - accountID: 用户ID
///   - isBlock: 是否是拉黑
///   - aCompletion: 回调
+ (void)xyf_requestBlockUser:(NSInteger)accountID
                     isBlock:(BOOL)isBlock
                  completion:(XYLApiCompletion)aCompletion;


@end

NS_ASSUME_NONNULL_END
