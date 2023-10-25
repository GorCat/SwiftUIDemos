//
//  OWLMusicJoinFanAlertView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicJoinFanAlertView : UIView

+ (instancetype)xyf_showJoinFanAlertView:(UIView *)targetView
                                fanModel:(OWLMusicFanInfoModel *)fanModel
                                anchorID:(NSInteger)anchorID;

@end

NS_ASSUME_NONNULL_END
