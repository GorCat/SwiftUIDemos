//
//  OWLMusicTopAudienceListCell.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/2/9.
//

/**
 * @功能描述：直播间顶部视图观众列表头像cell
 * @创建时间：2023.2.9
 * @创建人：许琰
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicTopAudienceListCellDelegate <NSObject>

/// 点击头像（fix 点击不走didSelectItemAtIndexPath 估计重写hitTest有问题了 但懒得改）
- (void)xyf_topAudienceListCellClickUser:(OWLMusicMemberModel *)model;

@end

@interface OWLMusicTopAudienceListCell : UICollectionViewCell

@property (nonatomic, weak) id <OWLMusicTopAudienceListCellDelegate> delegate;

@property (nonatomic, strong) OWLMusicMemberModel *model;

@end

NS_ASSUME_NONNULL_END
