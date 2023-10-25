//
//  OWLMusicComboManager.h
//  Pods
//
//  Created by 许琰 on 2023/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicComboManager : NSObject

+ (instancetype)shared;

- (void)xyf_startAnimationWithImage:(nullable UIImage *)xyp_image size:(CGSize)xyp_size container:(UIView *)xyp_container count:(NSInteger)xyp_count senderIsSelf:(BOOL)xyp_isSelf;

- (void)xyf_stopAnimation:(BOOL)immediately;

@end

NS_ASSUME_NONNULL_END
