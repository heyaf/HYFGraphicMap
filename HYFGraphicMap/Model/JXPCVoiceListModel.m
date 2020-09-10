//
//  JXPCVoiceListModel.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/9.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCVoiceListModel.h"

@implementation JXPCVoiceListModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"VoiceId"}];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
  return YES;
}
@end
