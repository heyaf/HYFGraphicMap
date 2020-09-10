//
//  JXPCScenicPointModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCScenicPointModel : JSONModel
/*
 {
     ssaLongitudeLatitude = "34.788832,114.346769",
     clientVoicePacketDetails =     {
         isFree = 0,
         id = 653,
         clientVoicePacketId = 54,
         isEffective = 0,
         voiceUrl = "https://qn.jxpapp.com/fengshaotingnanshengbei.mp3",
         isAudition = 0,
         clientScenicSpotDefiniteId = 122,
     },
     ssId = 4,
     updateTime = 1576059493000,
     id = 122,
     ssaName = "奉召厅",
     definiteImage = "https://qn.jxpapp.com/%E5%A5%89%E8%AF%8F%E4%BA%AD.png",
     createTime = "2019-12-09 11:55:00",
     ssaRadius = 0,
 }
 
 
 
 {
     ssaLongitudeLatitude = "34.811406,114.347052",
     ssId = 1,
     id = 3,
     ssaName = "天波楼",
     definiteImage = "http://img.ptocool.com/3332-1518523974125-28",
     clientScenicSpotDefiniteTriggerList =     (
             {
             sstLongitudeLatitude = "34.811506,114.347052",
             id = 2,
             sstRadius = 2,
             ssaId = 3,
         },
             {
             sstLongitudeLatitude = "34.811356,114.347212",
             id = 3,
             sstRadius = 2,
             ssaId = 3,
         },
             {
             sstLongitudeLatitude = "34.811286,114.347032",
             id = 4,
             sstRadius = 2,
             ssaId = 3,
         },
             {
             sstLongitudeLatitude = "34.811366,114.346871",
             id = 5,
             sstRadius = 2,
             ssaId = 3,
         },
     ),
     ssaRadius = 5,
 }
 */
@property (nonatomic,strong) NSString *ssaName;
@property (nonatomic,strong) NSString *ssaLongitudeLatitude;
@property (nonatomic,strong) NSArray *clientScenicSpotDefiniteTriggerList;
@property (nonatomic,assign) NSInteger ssId;
@property (nonatomic,assign) CGFloat ssaRadius;
@property (nonatomic,assign) NSInteger spId;
@property (nonatomic,strong) NSString *definiteImage;
@property (nonatomic,strong) NSDictionary *clientVoicePacketDetails;

@end

NS_ASSUME_NONNULL_END
