//
//  OWLBGMModuleBaseView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间基类视图
 * @创建时间：2023.2.9
 * @创建人：许琰
 */



#import <UIKit/UIKit.h>

typedef void(^XYLVoidBlock)(void);
typedef void(^XYLTextBlock) (NSString * __nullable stringValue);
NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleBaseView : UIView

@property (nonatomic, weak) id <OWLBGMModuleBaseViewDelegate> delegate;

/// 是否需要检查点击事件（PK视图使用 用于穿透点击事件）
@property (nonatomic, assign) BOOL xyp_needCheckTapPoint;

/// 刷新房间数据(数据相关的更新 都通过模型更新)
- (void)xyf_updateRoomData:(OWLMusicRoomTotalModel *)model;

/// 处理事件(触发事件)
/// 注：当更新页面数据的时候 基本都是用上一个方法 当有些事件是特殊的时间点需要做的时候 再调用这个方法。
- (void)xyf_dealWithEvent:(XYLModuleEventType)type obj:(NSObject * __nullable)obj;

@end

NS_ASSUME_NONNULL_END
