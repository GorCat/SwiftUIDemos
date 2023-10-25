//
//  OWLMusicEnjoyPromptBtn.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 按钮类型
typedef NS_ENUM(NSInteger, XYLPromptType) {
    /// say hi
    XYLPromptType_SayHi    = 1,
    /// 送礼
    XYLPromptType_SendGift  = 2,
    /// 关注
    XYLPromptType_Follow  = 3
};

@interface OWLMusicEnjoyPromptBtn : UIView

@property (nonatomic, copy) void(^xyp_tapPromptThis)(XYLPromptType xyp_type);

/** 设置类型 */
- (void)xyf_setupButtonType:(XYLPromptType)xyp_type;

@end

NS_ASSUME_NONNULL_END
