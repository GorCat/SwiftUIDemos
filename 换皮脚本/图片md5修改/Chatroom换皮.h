//
//  QDDApiClient+MusicPK.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/7/12.
//

#import "QDDApiClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface QDDApiClient (MusicPK)

- (NSURLSessionDataTask *)qdd_requestTrackEvent:(NSMutableDictionary *)dic completion:(ApiCompletion)aCompletion;

@end

NS_ASSUME_NONNULL_END
