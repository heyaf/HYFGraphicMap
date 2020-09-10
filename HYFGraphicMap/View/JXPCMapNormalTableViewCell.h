//
//  JXPCMapNormalTableViewCell.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/2/18.
//  Copyright © 2020 he. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXPCMapNormalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@end

NS_ASSUME_NONNULL_END
