//
//  JXPCEdgeInsets.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/24.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCEdgeInsets.h"

@implementation JXPCEdgeInsets


-(void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0,8,0,8};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
