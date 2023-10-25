//
//  OWLMusicGamePopView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicGamePopView : UIView

@property (nonatomic, copy) void (^showBlock)(void);

@property (nonatomic, strong, readonly) OWLMusicGameConfigModel *game;

- (void)xyf_loadModel:(OWLMusicGameConfigModel *)xyp_model initBig:(BOOL)xyp_initBig;

- (void)xyf_hide;

- (void)xyf_mini;

- (void)xyf_big;

- (void)xyf_close;


@end

NS_ASSUME_NONNULL_END
