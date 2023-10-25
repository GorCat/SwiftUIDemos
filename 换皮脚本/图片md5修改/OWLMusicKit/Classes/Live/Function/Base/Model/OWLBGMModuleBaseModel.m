//
//  OWLBGMModuleBaseModel.m
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

#import "OWLBGMModuleBaseModel.h"

@implementation OWLBGMModuleBaseModel

- (instancetype)initWithDictionary:(NSDictionary * __nullable )dictionary {
    if (dictionary != nil) {
        @try {
            self = [[self class] mj_objectWithKeyValues:dictionary];
        } @catch (NSException *exception) {
            
        } @finally {
            self.dsb_dictionary = dictionary;
        }
        return self;
        
    }
    return nil;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"dsb_dictionary"];
}

@end
