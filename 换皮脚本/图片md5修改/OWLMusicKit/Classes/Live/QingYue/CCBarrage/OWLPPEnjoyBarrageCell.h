//
//  OWLPPEnjoyBarrageCell.h
//  qianDuoDuo
//
//  Created by wdys on 2023/3/1.
//

#import <UIKit/UIKit.h>
@class OWLPPBarrageModel;
NS_ASSUME_NONNULL_BEGIN

@interface OWLPPEnjoyBarrageCell : UITableViewCell

@property (nonatomic, copy) void(^clickNickname)(void);

@property (nonatomic, strong) OWLPPBarrageModel *model;

@end

NS_ASSUME_NONNULL_END
