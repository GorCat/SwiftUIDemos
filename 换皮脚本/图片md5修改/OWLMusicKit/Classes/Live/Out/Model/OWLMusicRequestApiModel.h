//
//  OWLMusicRequestApiModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

#import <Foundation/Foundation.h>

#define kOWLJRequestMethodPost @"POST"
#define kOWLJRequestMethodGET  @"GET"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRequestApiModel : NSObject

/// body参数
@property (nonatomic, retain) NSMutableDictionary *xyp_bodyDic;
/// query参数
@property (nonatomic, retain) NSMutableDictionary *xyp_queryDic;
/// 请求方式
@property (nonatomic, copy) NSString *xyp_method;
/// 地址
@property (nonatomic, copy) NSString *xyp_url;
/// 前缀
@property (nonatomic, copy) NSString *xyp_host;

+ (OWLMusicRequestApiModel *)xyf_configApiWithUrl:(NSString *)url method:(NSString *)method;

@end

NS_ASSUME_NONNULL_END
