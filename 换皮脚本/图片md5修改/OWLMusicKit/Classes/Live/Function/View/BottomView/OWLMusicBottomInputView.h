//
//  OWLMusicBottomInputView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/1.
//

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicBottomInputView : OWLBGMModuleBaseView

- (void)xyf_showInView:(UIView *)view;

- (void)xyf_dismiss;

+ (CGFloat)xyf_getHeight;

@end

NS_ASSUME_NONNULL_END
