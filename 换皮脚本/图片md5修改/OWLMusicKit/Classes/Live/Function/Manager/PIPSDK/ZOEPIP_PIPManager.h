//
//  ZOEPIP_PIPManager.h
//  ZBNChatRoomDemo
//
//  Created by zzzzzzzzzz on 2023/6/26.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "ZOEPIP_SampleBufferRender.h"
#import "ZOEPIP_CVPBufferTool.h"
#import "ZOEPIP_AVPIPController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
NS_ASSUME_NONNULL_BEGIN
@protocol ZOEPIPPictureInPictureManagerDelegate <NSObject>  //目前已知问题RTC4.1.0以下画面会黑屏
//uid 无法匹配时传 -1  直播间语聊房判断 私聊带走不用判断传0即可
//语聊房 0：主持人 1：boss 2-7：上位主播
//直播间 0：当前主播 1：pk的主播
//私聊 0：主播
//必实现 若是语聊房我传你uid 你告诉我Index
-(NSInteger)zoepip_getPIPViewIndexWithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId;

//在后台关闭画中画 你需要关闭声音
- (void)zoepip_closePIPWindowInBackMode;

@optional

//语聊房必须实现这个给我反frame
-(CGRect)zoepip_getPIPViewFrameWithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId;


//可选

//切至后台画中画主窗口的尺寸//可选 我有默认的
-(CGSize)zoepip_getPIPMainWindowSizeWithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId;

//视图画面的尺寸、一般语聊房为正方形尺寸、直播间语聊房为手机屏幕尺寸  //可选 我有默认的
-(CGSize)zoepip_getPIPViewSizeWithUid:(NSUInteger)uid channelId:(NSString * _Nonnull)channelId;


//录屏遮盖的本地图片名称或网络图片 //可选 我有默认的
- (NSString *)zoepip_getScreenCoverImgString;

//录屏遮盖的UIView，若实现优先使用这个遮盖  (你需要持有这个view，我这边只弱引用避免循环引用)  //可选 我有默认的
- (UIView *)zoepip_getScreenCoverView;


//直播间语聊房实现，小窗模式时画中画结束需回到大窗模式
- (void)zoepip_finishPIPGoBigSizeView;


//视图层可以把需要展示的uiview传给我  我加在画中画上
- (UIView *)zoepip_getAnyViewAddtoPIPWithWindowFrame:(CGRect)frame;
- (void)zoepip_finishAnyViewRemovetoPIP;

@end



typedef NS_ENUM(NSInteger, ZOEPIP_PIPVCType) {
    ZOEPIP_PIPVCTypeMultibeam = 1,///语聊房
    ZOEPIP_PIPVCTypeLiveRoom,///直播间
    ZOEPIP_PIPVCTypePrivateChat,/// 私聊、带走
};

@interface ZOEPIP_PIPManager : NSObject
//最好在vc中使用
- (instancetype)initAndRtcKit:(AgoraRtcEngineKit *)rtcKit //(你需要持有这个rtcKit，我这边只弱引用避免循环引用)
                   WithvcType:(ZOEPIP_PIPVCType)vcType
                       WithVC:(UIViewController *)vc //语聊房的vc/直播间的vc/私聊、带走的vc (你需要持有这个vc，我这边只弱引用避免循环引用)
                 WithDelegate:(id<ZOEPIPPictureInPictureManagerDelegate>)delegate
                   WithIsOpen:(BOOL)isOpen;  //isOpen  NO 为关闭 YES为开启


- (instancetype)initAndRtcKit:(AgoraRtcEngineKit *)rtcKit
                   WithvcType:(ZOEPIP_PIPVCType)vcType
                       WithVC:(UIViewController *)vc
                 WithDelegate:(id<ZOEPIPPictureInPictureManagerDelegate>)delegate
                WithIsSwiftUI:(BOOL)isSwiftUI
                   WithIsOpen:(BOOL)isOpen;

//销毁画中画，vc销毁前、前调用、一定要调不然后面用的时候会唤不起画中画
- (void)zoepip_destroyPIP;

//直播间调用、进入完成时pk传yes  退出pk完成时传no
- (void)zoepip_isPK:(BOOL)ispk;

//清除上一帧画面，
//上下滑动直播间或语聊房的时候调用
//语聊房 boss位、主播上麦状态发生变化的时候调用
//或者重新进入vc时最好调用一下
- (void)zoepip_clearLastPicture;


//isOpen  NO 为关闭 YES为开启 房间内切换或者小窗去设置里切换的时候调用;
- (void)zoepip_swichOpen:(BOOL)isOpen;

@property (nonatomic,weak)id<ZOEPIPPictureInPictureManagerDelegate>delegate;
@property (nonatomic,strong) UIImage * __nullable  zoepip_multibeamBgImage; //语聊房下载好了背景给赋值
@end

NS_ASSUME_NONNULL_END
