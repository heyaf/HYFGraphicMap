//
//  JXPCLinePointModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/11.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCLinePointModel.h"

@implementation JXPCLinePointModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"linepointId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
