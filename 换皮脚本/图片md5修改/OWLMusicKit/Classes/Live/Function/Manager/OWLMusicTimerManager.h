//
//  OWLMusicTimerManager.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicTimerManager : NSObject

+ (NSString*)xyf_timerTarget:(id)xyp_target
                  selector:(SEL)xyp_selector
                 delayTime:(NSTimeInterval)xyp_start
                  interval:(NSTimeInterval)xyp_interval
                   repeats:(BOOL)xyp_repeats
                     async:(BOOL)xyp_async;

+ (void)xyf_cancelTimer:(NSString *)xyp_timerName;

@end

NS_ASSUME_NONNULL_END
