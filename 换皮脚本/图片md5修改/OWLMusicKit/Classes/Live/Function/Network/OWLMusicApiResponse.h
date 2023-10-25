//
//  OWLMusicApiResponse.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicApiResponse : NSObject

@property (nonatomic, copy) NSString *responseId;

@property (nonatomic, assign) NSInteger retCode;

@property (nonatomic, copy) NSString *message;
/// 服务端在某些错误码 将messgae传信息，所以就用extraData字段表示信息。message在客户端写死文案
@property (nonatomic, copy) NSString *extraData;

- (instancetype)initWithResponseData:(id)aData error:(NSError *)error;

- (id)data;

/// 接口请求成功（网络层） 并且 服务端给了正确的错误码（业务层）
- (BOOL)xyf_success;

/// 接口请求成功（网络层） 但是 服务端报错（业务层）
- (BOOL)xyf_requestSuccessWithWrongCode;

@end

NS_ASSUME_NONNULL_END
