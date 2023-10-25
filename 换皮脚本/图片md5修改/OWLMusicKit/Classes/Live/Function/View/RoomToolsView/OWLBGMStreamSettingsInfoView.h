//
//  OWLBGMStreamSettingsInfoView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OWLMusciStreamSettingType) {
    /// 应用内最小化
    OWLMusciStreamSettingType_InApp = 0,
    /// 应用外悬浮窗
    OWLMusciStreamSettingType_OutApp,
};

@interface OWLBGMStreamSettingsInfoView : UIView

- (instancetype)initWithType:(OWLMusciStreamSettingType)type;

@end

NS_ASSUME_NONNULL_END
