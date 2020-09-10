//
//  JXPCLineNameModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCLineNameModel : JSONModel
/*
 {
     ssrtRouteNameStatus = 1,
     routeColor = "#FF585F",
     ssrtRouteName = "快速游",
     updateTime = 1587517098000,
     id = 3,
     iconImage = "https://qn.jxpapp.com/lx_fast@3x.png",
     createTime = "2019-10-23 00:00:00",
 }
 **/
@property (nonatomic,strong) NSString *ssrtRouteName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger lineId;
@property (nonatomic,assign) NSInteger ssrtRouteNameStatus;
@property (nonatomic,strong) NSString *routeColor;
@property (nonatomic,strong) NSString *iconImage;


@end

NS_ASSUME_NONNULL_END
