//
//  OWLMusicVideoContentView.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicVideoContentView : UIView

#pragma mark - Getter
/// 是否是小窗
@property (nonatomic, assign, readonly) BOOL xyp_isSmall;

- (instancetype)initWithIsSmall:(BOOL)isSmall;


@end

NS_ASSUME_NONNULL_END
