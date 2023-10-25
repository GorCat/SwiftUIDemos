//
//  OWLMusicPayModel.h
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/21.
//

#import "OWLBGMModuleBaseModel.h"

/// 商品类型
typedef NS_ENUM(NSInteger, XYLProductType) {
    XYLProductType_NormalConsume     = 1, /// 一般消耗商品
    XYLProductType_DiscountConsume   = 2, /// 折扣商品
    XYLProductType_RenewProduct      = 3, /// 续订商品
    XYLProductType_FanClub           = 5, /// 铁粉
};

NS_ASSUME_NONNULL_BEGIN

@protocol OWLMusicProductModel;

@interface OWLMusicPayModel : OWLBGMModuleBaseModel

/// 支付类型（1：苹果 2：Paypal，3：Google Play，4：信用卡，5：CashU，6：Coda pay，7：huawei pay，8：Stripe，9：Apple pay，10：PAYERMAX_KNET，11：PAYERMAX_MADA）
@property (nonatomic, assign) NSInteger dsb_payType;
/// 标题
@property (nonatomic, strong) NSString *dsb_title;
/// 支付URL后缀
@property (nonatomic, strong) NSString *dsb_payUrlSuffix;
/// 统计系数*10000
@property (nonatomic, assign) NSInteger dsb_coefficient;
/// 商品
@property (nonatomic, strong) NSArray <OWLMusicProductModel> *dsb_products;

@end

@interface OWLMusicProductModel : OWLBGMModuleBaseModel

/// 产品id
@property (nonatomic, strong) NSString *dsb_productId;
/// 美元价格
@property (nonatomic, assign) double dsb_priceUSD;
/// 基础数量
@property (nonatomic, assign) NSInteger dsb_baseCount;
/// 赠送数量
@property (nonatomic, assign) NSInteger dsb_extraCount;
/// 商品类型
@property (nonatomic, assign) XYLProductType dsb_productType;
/// 是否已经购买
@property (nonatomic, assign) BOOL dsb_isBought;
/// 美元价格（原价）
@property (nonatomic, assign) double dsb_oriPriceUSD;

@end

@interface OWLMusicPayOtherInfoModel : NSObject

/// 支付类型
@property (nonatomic, assign) XYLOutDataSourcePayType xyp_payType;
/// 主播ID
@property (nonatomic, assign) NSInteger xyp_hostID;

@end

NS_ASSUME_NONNULL_END
