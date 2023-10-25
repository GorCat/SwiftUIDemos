//
//  OWLPPGiftItem.h
//  qianDuoDuo
//
//  Created by wdys on 2023/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^OWLPPGiftItemVoidBlock) (void);
@interface OWLPPGiftItem : UICollectionViewCell

@property (nonatomic, assign) BOOL xyp_isSvv;

@property (nonatomic, strong) OWLMusicGiftInfoModel * xyp_ggModel;

@property (nonatomic, copy) OWLPPGiftItemVoidBlock xyp_sendGiftBlock;

@end

NS_ASSUME_NONNULL_END
