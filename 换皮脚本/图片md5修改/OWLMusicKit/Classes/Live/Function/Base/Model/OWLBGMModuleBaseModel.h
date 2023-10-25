//
//  OWLBGMModuleBaseModel.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLBGMModuleBaseModel : NSObject

@property (nonatomic, strong) NSDictionary *dsb_dictionary;

- (instancetype)initWithDictionary:(NSDictionary * __nullable )dictionary;

@end

NS_ASSUME_NONNULL_END
