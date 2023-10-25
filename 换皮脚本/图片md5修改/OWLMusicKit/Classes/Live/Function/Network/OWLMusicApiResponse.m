//
//  OWLMusicApiResponse.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import "OWLMusicApiResponse.h"

@interface OWLMusicApiResponse () {
    id _responseData;
}

/// 是否请求成功（网络层）
@property (nonatomic, assign) BOOL isRequestApiSuccess;

@end

@implementation OWLMusicApiResponse

- (instancetype)initWithResponseData:(id)aData error:(NSError *)error {
    if (aData == nil) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _responseData = aData;
        _retCode = [[aData xyf_objectForKeyNotNil:@"retCode"] integerValue];
        _responseId = [aData xyf_objectForKeyNotNil:@"responseId"];
        _message = [aData xyf_objectForKeyNotNil:@"message"];
        _extraData = [aData xyf_objectForKeyNotNil:@"message"];
        _isRequestApiSuccess = error == nil;
        [self xyf_dealResponseData];
    }
    return self;
}

- (id)data {
    return _responseData;
}

/// 接口请求成功（网络层） 并且 服务端给了正确的错误码（业务层）
- (BOOL)xyf_success {
    return _retCode == 0 && self.data && self.isRequestApiSuccess;
}

/// 接口请求成功（网络层） 但是 服务端报错（业务层）
- (BOOL)xyf_requestSuccessWithWrongCode {
    return _retCode != 0 && self.data && self.isRequestApiSuccess;
}


#pragma mark - 处理接口逻辑
- (void)xyf_dealResponseData {
    switch (self.retCode) {
        case -47: // -47 账号被封
            self.message = kXYLLocalString(@"Your account has been banned.");
            break;
        case -83:
            self.message = @"";
            break;
        default:
            break;
    }
}

@end
