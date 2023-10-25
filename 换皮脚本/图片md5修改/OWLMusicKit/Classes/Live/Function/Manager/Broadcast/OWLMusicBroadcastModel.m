//
//  OWLMusicBroadcastModel.m
//  XYYCuteKit
//
//  Created by 许琰 on 2023/4/28.
//

#import "OWLMusicBroadcastModel.h"
#import "OWLMusicTextAttachment.h"

@implementation OWLMusicBroadcastModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"xyp_senderAvatar" : @"senderAvatar",
             @"xyp_senderName" : @"senderName",
             @"xyp_senderUserId" : @"senderUserId",
             @"xyp_recieverAvatar" : @"recieverAvatar",
             @"xyp_recieverName" : @"recieverName",
             @"xyp_recieverUserId" : @"recieverUserId",
             @"xyp_giftName" : @"giftName",
             @"xyp_giftIconUrl" : @"giftIconUrl",
             @"xyp_agoraRoomId" : @"agoraRoomId",
             @"xyp_roomId" : @"roomId",
             @"xyp_fromType": @"roomType",
             @"xyp_roomCover":@"roomCover",
            };
}

- (instancetype)initTakeModelWithRoomID:(NSInteger)xyp_roomId userName:(NSString *)xyp_userName userAvatar:(NSString *)xyp_userAvatar anchorName:(NSString *)xyp_anchorName anchorAvatar:(NSString *)xyp_anchorAvatar{
    self = [super init];
    if(self){
        self.xyp_roomId = xyp_roomId;
        self.xyp_senderName = xyp_userName;
        self.xyp_senderAvatar = xyp_userAvatar;
        self.xyp_recieverName = xyp_anchorName;
        self.xyp_recieverAvatar = xyp_anchorAvatar;
        self.xyp_showType = XYLBroadcastShowTypeTake;
        self.xyp_fromType = XYLBroadcastFromTypeNone;
    }
    return self;
        
}

#pragma mark public
- (NSMutableAttributedString *)xyp_giftContentAttr{
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]init];
    if(self.xyp_senderName && self.xyp_recieverName && self.xyp_giftIconUrl){
        NSAttributedString * senderNameAttr = [[NSAttributedString alloc]initWithString:self.xyp_senderName attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0xE55CFF)}];
        NSAttributedString * sendAttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",kXYLLocalString(@"Sent")] attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0x7A4FE9)}];
        NSAttributedString * toAttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",kXYLLocalString(@"to")] attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0x7A4FE9)}];
        NSAttributedString * recieverNameAttr = [[NSAttributedString alloc]initWithString:self.xyp_recieverName attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0xE55CFF)}];
        OWLMusicTextAttachment * giftAtt = [[OWLMusicTextAttachment alloc] init];;
        
        NSURL *imageUrl = [NSURL URLWithString:self.xyp_giftIconUrl?:@""];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:imageUrl]];
        if(image.size.height > 0){
            CGFloat width = image.size.width * 25 / image.size.height;
            giftAtt.bounds = CGRectMake(0, 0, width, 25);
        }else{
            giftAtt.bounds = CGRectMake(0, 0, 25, 25);
        }
        UIView *clearView = [[UIView alloc]initWithFrame:giftAtt.bounds];
        clearView.backgroundColor = [UIColor clearColor];
        giftAtt.image = [clearView xyf_getImageFromView];
        kXYLWeakSelf
        __weak typeof(giftAtt) weakGiftAtt = giftAtt;
        giftAtt.xyp_contentViewBlock = ^UIView * _Nonnull{
            kXYLStrongSelf
            UIImageView *imageView = [[UIImageView alloc]init];
            NSURL *imageUrl = [NSURL URLWithString:strongSelf.xyp_giftIconUrl?:@""];
            [imageView sd_setImageWithURL:imageUrl placeholderImage:[XYCUtil xyf_getIconWithName:@"xyr_gift_default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if(image.size.height > 0){
                    CGFloat width = image.size.width * 25 / image.size.height;
                    weakGiftAtt.bounds = CGRectMake(0, 0, width, 25);
                    if(strongSelf.refreshUIBlock){
                        strongSelf.refreshUIBlock();
                    }
                }
            }];
            return imageView;
        };
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:giftAtt];
        
        [attribute appendAttributedString:senderNameAttr];
        [attribute appendAttributedString:sendAttr];
        [attribute appendAttributedString:imageAttr];
        [attribute appendAttributedString:toAttr];
        [attribute appendAttributedString:recieverNameAttr];
        
        return attribute;
    }
    
    return nil;
    
}


- (NSMutableAttributedString *)xyp_takeContentAttr {
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]init];
    if(self.xyp_senderName && self.xyp_recieverName){
        NSAttributedString * senderNameAttr = [[NSAttributedString alloc]initWithString:self.xyp_senderName attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0xF8FF00)}];
        NSAttributedString * andttr = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",kXYLLocalString(@"and")] attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : UIColor.whiteColor}];
        NSAttributedString * recieverNameAttr = [[NSAttributedString alloc]initWithString:self.xyp_recieverName attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : kXYLColorFromRGB(0xF8FF00)}];
        NSAttributedString * chatAttr = [[NSAttributedString alloc]initWithString:[@" " stringByAppendingString:kXYLLocalString(@"started a private chat")] attributes:@{NSFontAttributeName : kXYLGilroyBoldFont(15), NSForegroundColorAttributeName : UIColor.whiteColor}];
      
        
        [attribute appendAttributedString:senderNameAttr];
        [attribute appendAttributedString:andttr];
        [attribute appendAttributedString:recieverNameAttr];
        [attribute appendAttributedString:chatAttr];
        
        return attribute;
    }
    
    return nil;
    
    
}

#pragma mark getter
- (float)stayDuration{
    return self.xyp_showType == XYLBroadcastShowTypeGift ? 3 : 2;
}

- (float)moveDuration{
    return self.xyp_showType == XYLBroadcastShowTypeGift ? 0.8 : 0.8;
}

@end
