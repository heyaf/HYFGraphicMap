//
//  JXPCVoiceListModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCVoiceListModel : JSONModel
/*
    isFree = 0,
     voiceDuration = "31",
     clientVoicePacketSumStar = 136,
     clientGuide =     {
         gender = 1,
         commentNumber = 0,
         updateTime = 1585904961000,
         clientGuideNamePinyin = "chengxianbei",
         id = 54,
         guideSumStar = 0,
         clientGuideName = "程宪北",
         guideLabel = "资深导游",
         clientGuideElephant = "https://qn.jxpapp.com/weijinpng.png",
         createTime = "",
     },
     updateTime = 1585904961000,
     isShelf = 1,
     discountActivity = "喜迎国庆！乐享时惠",
     commentNumber = 16,
     count = 0,
     tellNumber = 21,
     voicePacketName = "天下首府—开封府",
     id = 54,
     label = "商业景区",
     voicePacketImageUrl = "https://qn.jxpapp.com/%E5%A5%89%E8%AF%8F%E4%BA%AD.png",
     clientGuideId = 1,
     isRecommend = 0,
     introduction = "",
     createTime = "",
     price = 1,
     clientScenicSpotBasicId = 4,
     clientOrder =     {
         id = 1976,
         clientOrderSonList =     (
         ),
         orderPrice = 1,
         productName = "天下首府—开封府",
         clientVoiceId = 54,
         shareOrder = 0,
         clientUserId = 2,
         userTime = "2020-09-08 16:06:38",
         createTime = "2020-09-08 15:05:46",
         orderType = 2,
         clientScenicSpotId = 4,
         orderNumber = 1,
         clientOrderId = "71827320197898",
         sumPrice = 1,
     },
     voicePacketNamePinyin = "tianxiashoufukaifengfu",
     voicePacketSort = 1,
 */

@property (nonatomic,strong) NSString *voicePacketName;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *voicePacketImageUrl;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *voicePacketNamePinyin;
@property (nonatomic,strong) NSString *discountActivity;

@property (nonatomic,strong) NSDictionary *clientGuide;
@property (nonatomic,strong) NSDictionary *clientOrder;  //订单信息json(此用户没有购买此语音包 没有订单 不返回)

@property (nonatomic,assign) NSInteger VoiceId;
@property (nonatomic,assign) NSInteger updateTime;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger isRecommend;
@property (nonatomic,assign) NSInteger voicePacketSort;
@property (nonatomic,assign) NSInteger price;
@property (nonatomic,assign) NSInteger commentNumber;
@property (nonatomic,assign) NSInteger clientVoicePacketSumStar;
@property (nonatomic,assign) NSInteger clientScenicSpotBasicId;
@property (nonatomic,assign) NSInteger clientGuideId;
@property (nonatomic,assign) NSInteger isShelf;
@property (nonatomic,assign) NSInteger shareOrder;  //是否是分享订单(0-不是， 1-是)
@property (nonatomic,assign) NSInteger isFree;//是否是免费的语音包(0-不是，1-是，默认不是)    

@property (nonatomic,assign) BOOL isselect;


@end

NS_ASSUME_NONNULL_END
