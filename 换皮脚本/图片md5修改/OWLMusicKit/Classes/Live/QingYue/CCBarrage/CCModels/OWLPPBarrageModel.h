//
//  OWLPPBarrageModel.h
//  AFNetworking
//
//  Created by wdys on 2023/3/16.
//

#import <Foundation/Foundation.h>
@class OWLPPBarrageModel;
NS_ASSUME_NONNULL_BEGIN

@protocol OWLPPBarrageModelDelegate <NSObject>

/// 刷新文案
- (void)xyf_refreshLabel:(OWLPPBarrageModel *)model;

/// 刷新昵称按钮frame
- (void)xyf_refreshNameFrame:(CGRect)frame model:(OWLPPBarrageModel *)model;

@end

@interface OWLPPBarrageModel : NSObject

/// 代理
@property (nonatomic, weak) id <OWLPPBarrageModelDelegate> delegate;
/// 模型
@property (nonatomic, strong) OWLMusicMessageModel *xyp_msgModel;
/// 富文本
@property (nonatomic, strong) NSMutableAttributedString *xyp_atr;
/// 气泡位置
@property (nonatomic, assign) CGRect xyp_bubbleFrame;
/// cell高度
@property (nonatomic, assign) CGFloat xyp_cellHeight;
/// 背景颜色
@property (nonatomic, strong) UIColor *xyp_bgColor;
/// 用户按钮位置
@property (nonatomic, assign) CGRect xyp_userButtonFrame;
/// 标签是否加载
@property (nonatomic, assign) BOOL xyp_medalHasLoad;
/// 标签位置
@property (nonatomic, assign) CGRect xyp_medalFrame;

/// 刷新UI
@property (nonatomic, copy) void(^refreshUIBlock)(void);
/// 刷新姓名位置
@property (nonatomic, copy) void(^refreshNameFrameBlock)(CGRect nameFrame);

- (instancetype)initWithModel:(OWLMusicMessageModel *)model;

//- (void)xyf_refreshMedal:(UIImage *)medalImage;

@end

NS_ASSUME_NONNULL_END
