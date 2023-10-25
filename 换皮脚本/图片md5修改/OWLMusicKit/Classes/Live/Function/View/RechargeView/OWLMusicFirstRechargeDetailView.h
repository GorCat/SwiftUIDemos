//
//  OWLMusicFirstRechargeDetailView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 首充详情类型
typedef NS_ENUM(NSInteger, OWLMusicFirstRechargeDetailType) {
    /// 金币
    OWLMusicFirstRechargeDetailType_Coin  = 1,
    /// Vip
    OWLMusicFirstRechargeDetailType_Vip   = 2
};

@interface OWLMusicFirstRechargeDetailView : UIView

- (instancetype)initWithType:(OWLMusicFirstRechargeDetailType)type productModel:(OWLMusicProductModel *)productModel;

@end

NS_ASSUME_NONNULL_END
