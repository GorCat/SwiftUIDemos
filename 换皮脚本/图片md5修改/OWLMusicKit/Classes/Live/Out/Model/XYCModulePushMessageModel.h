//
//  XYCModulePushMessageModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/23.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYCModulePushMessageModel : OWLBGMModuleBaseModel

/// 操作码
@property (nonatomic, assign) NSInteger xyp_opCode;
/// 子操作码
@property (nonatomic, assign) NSInteger xyp_subCode;
/// 操作结果码
@property (nonatomic, assign) NSInteger xyp_retCode;
/// 操作结果描述
@property (nonatomic, copy) NSString *xyp_message;
/// 业务数据
@property (nonatomic, strong) NSDictionary *xyp_data;

@end

NS_ASSUME_NONNULL_END
