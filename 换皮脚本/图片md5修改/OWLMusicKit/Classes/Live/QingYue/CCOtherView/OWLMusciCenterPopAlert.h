//
//  OWLMusciCenterPopAlert.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusciCenterPopAlert : UIView

@property (nonatomic, copy) void(^xyp_clickedSureBtn)(void);


/// 初始化
/// @param type 类型
/// @param anchorID 主播ID
/// @param targetView 父视图
/// @param moreAction 点击更多回调
+ (instancetype)xyf_showCenterPopAlert:(NSInteger)type
                              anchorID:(NSInteger)anchorID
                            targetView:(UIView *)targetView
                            moreAction:(void(^)(void))moreAction;

@end

NS_ASSUME_NONNULL_END
