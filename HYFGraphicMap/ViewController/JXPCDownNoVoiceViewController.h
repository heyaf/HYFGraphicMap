//
//  JXPCDownNoVoiceViewController.h
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/6.
//  Copyright © 2020 he. All rights reserved.
//

#import "TBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXPCDownNoVoiceViewController : TBBaseViewController
@property (nonatomic,copy) void(^chooseVoiceBlock)(void);
@end

NS_ASSUME_NONNULL_END
