//
//  OWLMusicTimerManager.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/5/5.
//

#import "OWLMusicTimerManager.h"

@interface OWLMusicTimerManager()


@property (nonatomic, strong) NSMutableArray<NSString *>*idArray;

@end


@implementation OWLMusicTimerManager

static NSMutableDictionary * xyp_timersz_;
dispatch_semaphore_t xyp_semaphorez_;



+ (instancetype)shared{
    static OWLMusicTimerManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OWLMusicTimerManager alloc]init];
    });
    return manager;
}

/**
 load 与 initialize区别，这里选用initialize
 */
+(void)initialize{
    
    //GCD一次性函数
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xyp_timersz_ = [NSMutableDictionary dictionary];
        xyp_semaphorez_ = dispatch_semaphore_create(1);
    });
}
//经测试这个方法不走dealloc，所以调用target方法。
+ (NSString*)xyf_timerTask:(void(^)(void))xyp_task
                 start:(NSTimeInterval) xyp_start
              interval:(NSTimeInterval) xyp_interval
               repeats:(BOOL) xyp_repeats
                 async:(BOOL)xyp_async{
    
    /**
     对参数做一些限制
     1.如果task不存在，那就没有执行的必要（!task）
     2.开始时间必须大于当前时间
     3.当需要重复执行时，重复间隔时间必须 >0
     以上条件必须满足，定时器才算是比较合理，否则没必要执行
     */
    if (!xyp_task || xyp_start < 0 || (xyp_interval <= 0 && xyp_repeats)) {
        
        return nil;
    }
    /**
     队列
     asyc：YES 全局队列 dispatch_get_global_queue(0, 0) 可以简单理解为其他线程(非主线程)
     asyc：NO 主队列 dispatch_get_main_queue() 可以理解为主线程
     */
    dispatch_queue_t queue = xyp_async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    /**
     创建定时器 dispatch_source_t timer
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_semaphore_wait(xyp_semaphorez_, DISPATCH_TIME_FOREVER);
    // 定时器的唯一标识
    NSString *timerName = [[OWLMusicTimerManager shared] xyp_crateID];
    // 存放到字典中
    xyp_timersz_[timerName] = timer;
    dispatch_semaphore_signal(xyp_semaphorez_);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, xyp_start * NSEC_PER_SEC), xyp_interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        //定时任务
        xyp_task();
        //如果不需要重复，执行一次即可
        if (!xyp_repeats) {
            [self xyf_cancelTimer:timerName];
        }
    });
    //启动定时器
    dispatch_resume(timer);
    return timerName;
}

+ (NSString*)xyf_timerTarget:(id)xyp_target
                  selector:(SEL)xyp_selector
                 delayTime:(NSTimeInterval)xyp_start
                  interval:(NSTimeInterval)xyp_interval
                   repeats:(BOOL)xyp_repeats
                     async:(BOOL)xyp_async{
    
    if (!xyp_target || !xyp_selector) return nil;
    //避免循环引用
    __weak typeof(xyp_target) weakSelf = xyp_target;
    return [self xyf_timerTask:^{
        if ([weakSelf respondsToSelector:xyp_selector]) {
            //（这是消除警告的处理）
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [weakSelf performSelector:xyp_selector];
#pragma clang diagnostic pop
        }
        
    } start:xyp_start interval:xyp_interval repeats:xyp_repeats async:xyp_async];

}

+(void)xyf_cancelTimer:(NSString*) xyp_timerName{
    
    if (xyp_timerName.length == 0) {
        
        return;
    }
    
    dispatch_semaphore_wait(xyp_semaphorez_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = xyp_timersz_[xyp_timerName];
    if (timer) {
        dispatch_source_cancel(timer);
        [xyp_timersz_ removeObjectForKey:xyp_timerName];
    }
    
    dispatch_semaphore_signal(xyp_semaphorez_);

}


- (NSString *)xyp_crateID{
    long time = [[NSDate date] timeIntervalSince1970] * 10000 + arc4random() % 100000;
    if(self.idArray.count == 0){
        [self.idArray addObject:[NSNumber numberWithLong:time]];
        return [NSString stringWithFormat:@"%ld",time];
    }else{
        while ([self contain:time]) {
            time += 1;
        }
        [self.idArray addObject:[NSNumber numberWithLong:time]];
        return [NSString stringWithFormat:@"%ld",time];
    }
}


- (BOOL)contain:(long)new{
    BOOL have = NO;
    for (NSNumber * number in self.idArray) {
        if(number.longValue == new){
            have = YES;
            break;
        }
    }
    return have;
}

@end
