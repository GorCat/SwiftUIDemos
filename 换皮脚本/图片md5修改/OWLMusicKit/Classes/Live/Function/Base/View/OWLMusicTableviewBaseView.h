//
//  OWLMusicTableviewBaseView.h
//  qianDuoDuo
//
//  Created by 许琰 on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XYCTapClickBaseTableViewDelegate <NSObject>

- (void)xyf_tapClickBaseTabelViewClickTouchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@interface OWLMusicTableviewBaseView : UITableView

@property (nonatomic, weak) id <XYCTapClickBaseTableViewDelegate> xyp_tapDelegate;

@end

NS_ASSUME_NONNULL_END
