//
//  OWLMusicRandomTableMsgModel.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/25.
//

#import "OWLBGMModuleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLMusicRandomTableMsgModel : OWLBGMModuleBaseModel

/// 选择下标
@property (nonatomic, assign) NSInteger dsb_selectedIndex;
/// 列表
@property (nonatomic, strong) NSArray <NSString *> *dsb_turnTableInfoList;
/// 是否开启
@property (nonatomic, assign) NSInteger dsb_turnTableIsOpen;
/// 标题
@property (nonatomic, strong) NSString *dsb_turnTableTitle;

@end

NS_ASSUME_NONNULL_END
