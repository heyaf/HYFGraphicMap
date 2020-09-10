//
//  JXPCFacilityModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCFacilityModel.h"

@implementation JXPCFacilityModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"facilityId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
