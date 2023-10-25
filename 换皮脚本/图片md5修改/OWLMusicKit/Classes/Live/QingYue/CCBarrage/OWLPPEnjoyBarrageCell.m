//
//  OWLPPEnjoyBarrageCell.m
//  qianDuoDuo
//
//  Created by wdys on 2023/3/1.
//

#import "OWLPPEnjoyBarrageCell.h"
#import "OWLPPAddAlertTool.h"
#import "OWLPPBarrageModel.h"
#import "OWLMusicAttLabel.h"

@interface OWLPPEnjoyBarrageCell() <OWLPPBarrageModelDelegate>

@property (nonatomic, strong) UIView * xyp_contentView;

@property (nonatomic, strong) OWLMusicAttLabel * xyp_msgLab;

@property (nonatomic, strong) UIImageView * xyp_medalIV;

@property (nonatomic, strong) UIButton * xyp_nameButton;

@end

@implementation OWLPPEnjoyBarrageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xyf_setupUI];
    }
    return self;
}

#pragma mark - 页面初始化
- (void)xyf_setupUI {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.xyp_contentView];
    
    [self.xyp_contentView addSubview:self.xyp_msgLab];
//    [self.xyp_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kXYLMessageBubbleMinEdge.top);
//        make.leading.mas_equalTo(kXYLMessageBubbleMinEdge.left);
//        make.bottom.mas_equalTo(-kXYLMessageBubbleMinEdge.bottom);
//        make.trailing.mas_lessThanOrEqualTo(kXYLMessageBubbleMinEdge.right);
//    }];
    
    [self.xyp_msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.xyp_contentView).offset(kXYLMessageTextEdge.left);
        make.trailing.equalTo(self.xyp_contentView).offset(-(kXYLMessageTextEdge.right - 1));
        make.top.equalTo(self.xyp_contentView).offset(kXYLMessageTextEdge.top);
        make.bottom.equalTo(self.xyp_contentView).offset(-kXYLMessageTextEdge.bottom);
//        make.height.mas_greaterThanOrEqualTo(10);
    }];
    
    [self addSubview:self.xyp_nameButton];
    [self addSubview:self.xyp_medalIV];
}

#pragma mark - 更新模型
- (void)setModel:(OWLPPBarrageModel *)model {
    _model = model;
    
    self.xyp_contentView.frame = model.xyp_bubbleFrame;
    self.xyp_contentView.backgroundColor = model.xyp_bgColor;
    self.xyp_msgLab.attributedText = model.xyp_atr;
    self.xyp_nameButton.frame = model.xyp_userButtonFrame;
    model.delegate = self;
    
    [self xyf_refreshMedal:model];
}

- (void)xyf_refreshMedal:(OWLPPBarrageModel *)model {
    NSURL *url = [NSURL URLWithString:model.xyp_msgModel.dsb_tagUrl];
    self.xyp_medalIV.frame = model.xyp_medalFrame;
    self.xyp_medalIV.hidden = model.xyp_msgModel.dsb_tagUrl.length == 0;
    if (model.xyp_msgModel.dsb_tagUrl.length == 0) { return; }
    [self.xyp_medalIV sd_setImageWithURL:url placeholderImage:[XYCUtil xyf_getIconWithName:@"xyr_medal_default"] completed:nil];
}

- (void)xyf_refreshUI {
    [self.xyp_msgLab setNeedsDisplay];
}

#pragma mark - OWLPPBarrageModelDelegate
/// 刷新文案
- (void)xyf_refreshLabel:(OWLPPBarrageModel *)model {
    [self xyf_refreshUI];
}

/// 刷新昵称按钮frame
- (void)xyf_refreshNameFrame:(CGRect)frame model:(OWLPPBarrageModel *)model {
//    if (model == _model) {
//        self.xyp_nameButton.frame = frame;
//    }
}

#pragma mark - Lazy
- (UIView *)xyp_contentView {
    if (!_xyp_contentView) {
        _xyp_contentView = [[UIView alloc] init];
        _xyp_contentView.layer.cornerRadius = 12.5;
        _xyp_contentView.layer.masksToBounds = YES;
    }
    return _xyp_contentView;
}

- (OWLMusicAttLabel *)xyp_msgLab {
    if (!_xyp_msgLab) {
        _xyp_msgLab = [[OWLMusicAttLabel alloc] init];
        _xyp_msgLab.textColor = UIColor.whiteColor;
        _xyp_msgLab.numberOfLines = 0;
        _xyp_msgLab.lineBreakMode = NSLineBreakByWordWrapping;
        _xyp_msgLab.font = kXYLGilroyBoldFont(14);
        _xyp_msgLab.userInteractionEnabled = NO;
    }
    return _xyp_msgLab;
}

- (UIButton *)xyp_nameButton {
    if (!_xyp_nameButton) {
        _xyp_nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _xyp_nameButton.backgroundColor = UIColor.clearColor;
        [_xyp_nameButton addTarget:self action:@selector(xyf_nameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _xyp_nameButton;
}

- (UIImageView *)xyp_medalIV {
    if (!_xyp_medalIV) {
        _xyp_medalIV = [[UIImageView alloc] init];
    }
    return _xyp_medalIV;
}

#pragma mark - 点击昵称
- (void)xyf_nameButtonClicked {
    if (self.clickNickname) {
        self.clickNickname();
    }
}

@end
