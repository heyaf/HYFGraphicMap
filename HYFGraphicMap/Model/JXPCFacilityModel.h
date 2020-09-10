//
//  JXPCFacilityModel.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCFacilityModel : JSONModel
/*
 {
     ssfnFacilitiesName = "洗手间",
     createTime = "2019-11-04 15:42:44",
     ssfnFacilitiesNameState = 1,
     id = 1,
     clientFacilitiesDetailsList =     (
             {
             ssftId = 1,
             ssfInletAndOutlet = 1,
             ssfLongitudeLatitude = "34.810814,114.346451",
             updateTime = 1576070752000,
             id = 1,
             userId = 37,
             ssId = 1,
             createTime = "2019-11-04 15:42:44",
         },
             {
             ssftId = 1,
             ssfInletAndOutlet = 1,
             ssfLongitudeLatitude = "34.810506,114.347292",
             updateTime = 1576070759000,
             id = 2,
             userId = 37,
             ssId = 1,
             createTime = "2019-11-04 15:43:24",
         },
     ),
     updateTime = 1576070752000,
 }
 */

@property (nonatomic,strong) NSString *ssfnFacilitiesName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSArray *clientFacilitiesDetailsList;

@property (nonatomic,assign) NSInteger ssfnFacilitiesNameState;
@property (nonatomic,assign) NSInteger facilityId;


@end

NS_ASSUME_NONNULL_END
