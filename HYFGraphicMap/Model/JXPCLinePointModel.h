//
//  JXPCLinePointModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/11.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCLinePointModel : JSONModel
/*
     {
     updateTime = 1576576909000,
     id = 1388,
     ssId = 1,
     ssrsLongitudeLatitude = "34.811763509114584,114.34638861762153",
     ssrsRouteWidth = 5,
     ssrtId = 3,
     userId = 37,
     ssrsOrderNumber = 1,
     ssrsRadius = 3,
     ssrsStatus = 0,
     createTime = "2019-12-12 16:23:03",
     ssrsIsSubmission = 0,
     ssrsArcLine = 0,
     ssrsIsDel = 1,
 }
 */
@property (nonatomic,strong) NSString *ssrsLongitudeLatitude;
@property (nonatomic,strong) NSString *createTime;

@property (nonatomic,assign) NSInteger ssrsArcLine;
@end

NS_ASSUME_NONNULL_END
