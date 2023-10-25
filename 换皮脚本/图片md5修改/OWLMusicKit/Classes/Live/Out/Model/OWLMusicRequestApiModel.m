//
//  OWLMusicRequestApiModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/16.
//

#import "OWLMusicRequestApiModel.h"

@implementation OWLMusicRequestApiModel

+ (OWLMusicRequestApiModel *)xyf_configApiWithUrl:(NSString *)url method:(NSString *)method {
    OWLMusicRequestApiModel *requestModel = [[OWLMusicRequestApiModel alloc] init];
    requestModel.xyp_url = url;
    requestModel.xyp_method = method;
    
    return requestModel;
}

@end
