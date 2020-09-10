//
//  JXPCLineNameModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCLineNameModel.h"

@implementation JXPCLineNameModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"lineId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
