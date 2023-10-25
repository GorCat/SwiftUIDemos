//
//  OWLMusicRandomTabelContainerView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLBGMModuleBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRandomTabelContainerView : OWLBGMModuleBaseView

/// 用户主动隐藏转盘
@property (nonatomic, copy) XYLVoidBlock xyp_hiddenBlock;

/// 展示结果
@property (nonatomic, copy) XYLTextBlock xyp_showResultBlock;

@property (nonatomic, assign) BOOL xyp_isShowing;

- (void)xyf_showView;

- (void)xyf_hiddenView;



@end

NS_ASSUME_NONNULL_END
