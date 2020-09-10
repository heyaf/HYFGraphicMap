//
//  JXPCScenicPointModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCScenicPointModel.h"

@implementation JXPCScenicPointModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"spId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
