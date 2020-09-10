//
//  JXPCLineScenicModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/11.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCLineScenicModel.h"

@implementation JXPCLineScenicModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"linescenicId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
