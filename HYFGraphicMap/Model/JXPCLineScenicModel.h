//
//  JXPCLineScenicModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/11.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCLineScenicModel : JSONModel
/*
     {
     ssaLongitudeLatitude = "34.811606,114.347027",
     ssId = 1,
     id = 133,
     ssaName = "孝严祠",
     definiteImage = "http://img.ptocool.com/3332-1518523974125-28",
     clientScenicSpotDefiniteTriggerList =     (
             {
             sstLongitudeLatitude = "34.81153754340278,114.34706244574653",
             id = 42,
             sstRadius = 3,
             ssaId = 133,
         },
     ),
     ssaRadius = 3,
     clientVoicePacketDetails =     {
         updateTime = 1575508137000,
         id = 16,
         clientVoicePacketId = 24,
         voiceUrl = "http://qn-user-test.jxpapp.com/xiaosongcheng.mp3",
         isAudition = 0,
         clientScenicSpotDefiniteId = 133,
         createTime = "",
     },
 }
 */
@property (nonatomic,strong) NSString *definiteImage;
@property (nonatomic,strong) NSString *ssaLongitudeLatitude;
@property (nonatomic,strong) NSString *ssaName;
@property (nonatomic,strong) NSDictionary *clientVoicePacketDetails;
@property (nonatomic,strong) NSArray *clientScenicSpotDefiniteTriggerList;

@property (nonatomic,assign) NSInteger ssId;
@property (nonatomic,assign) NSInteger linescenicId;
@property (nonatomic,assign) NSInteger ssaRadius;




@end

NS_ASSUME_NONNULL_END
