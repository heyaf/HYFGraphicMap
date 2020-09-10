//
//  JXPCMapNormalTableViewCell.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCMapNormalTableViewCell.h"

@implementation JXPCMapNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewRadius(self.ImageView, 12);
    self.Label.font = kNormalFont(15);
    self.SelectImageView.hidden = YES;
    self.tagImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
