//
//  JXPCDownVoiceTableViewCell.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/6.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCDownVoiceTableViewCell.h"
#import "HSDownloadManager.h"
//#import "JXPCFileSize.h"
@interface JXPCDownVoiceTableViewCell()

@property (nonatomic,assign) dispatch_queue_t andQueue;
@property (nonatomic,assign) NSInteger state; //1 未下载 2已下载未播放 3 已下载播放中 4 删除
@end
@implementation JXPCDownVoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kViewBorderRadius(_MainBGView, 5, 1, kRGB(161, 229, 207));
    kViewBorderRadius(_btnBgView, 16, 3, kRGB(237, 237, 237));
    self.btnlayer = [CAShapeLayer layer];
    self.btnlayer.frame = CGRectMake(0, 0, 32, 32);
    self.btnlayer.position = CGPointMake(16, 16);
    self.btnlayer.lineWidth = 3;
    self.btnlayer.fillColor = [UIColor clearColor].CGColor;
    self.btnlayer.strokeColor = KTagColor.CGColor;
    self.btnlayer.lineCap = kCALineCapSquare;
    self.btnlayer.strokeEnd = 0;


    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 32, 32)];
    self.btnlayer.path = path.CGPath;
    [_downBtn.layer addSublayer:self.btnlayer];
    _state =1;
    
    self.VoiceSizeLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.VoiceTitle.text =dataDic[@"voicePacketName"];
    
//    NSArray *voiceArray = dataDic[@"clientVoicePacketDetailsList"];
//    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
//    for (NSDictionary *dic in voiceArray) {
//        [mutArr addObject:dic[@"voiceUrl"]];
//    }
//
//    JXPCFileSize *fileIsze = [[JXPCFileSize alloc] init];
//
//    [fileIsze getUrlFileLengthArr:mutArr withResultBlock:^(long long length, NSError * _Nonnull error) {
//
//    }];
//    fileIsze.sizeBlock = ^(NSString * sizeStr) {
//        self.VoiceSizeLabel.text = sizeStr;
//    };
}


- (IBAction)downBtnClicked:(id)sender {
 
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
 
}
//- (void)downMusicWithArray:(NSArray *)musicArray{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    [downManager deleteAllFile];
//    for (NSString *Url in musicArray) {
//        [downManager download:Url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                ASLog(@"----%f---%f",[self getProgressWithArr:musicArray],progress);
//
//                [self changeProgress:[self getProgressWithArr:musicArray]];
//            });
//        } state:^(DownloadState state) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (state==DownloadStateCompleted) {
//                    [self downCompletionWithArray:musicArray];
//                    ASLog(@"第1次下载成功");
//
//
//                }else if (state==DownloadStateFailed){  //下载失败重新下载
//                    ASLog(@"第1次下载失败");
//
//                    [self downloadWithURL:Url andMusicArray:musicArray];
//
//                }
//            });
//        }];
//    }
//}
-(void)setLayerprogress:(CGFloat)Layerprogress{
    _Layerprogress = Layerprogress;
    
    ASLog(@"-----%f",Layerprogress);
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = 0.0001f;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:Layerprogress];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;

    [self.btnlayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];

    if (Layerprogress==1) {
        [self.downBtn setImage:kIMAGE_Name(@"lxxz_Voice delete") forState:0];
    }else if(Layerprogress==0) {
        [self.downBtn setImage:kIMAGE_Name(@"lxxz_download") forState:0];
    }else{
        [self.downBtn setImage:kIMAGE_Name(@"lxxz_suspended") forState:0];

    }
}

/// 设置按钮图片
/// @param btnImageStates 1代表继续状态， 0代表暂停状态
-(void)setBtnImageStates:(NSInteger)btnImageStates{
    _btnImageStates = btnImageStates;
    if (btnImageStates==1) { //
        [self.downBtn setImage:kIMAGE_Name(@"lxxz_suspended") forState:0];
    }else{
        [self.downBtn setImage:kIMAGE_Name(@"lxxz_Continue") forState:0];
    }
}

//-(void)downloadWithURL:(NSString *)url andMusicArray:(NSArray *)musicArray{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    ASLog(@"第二次下载");
//    [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self changeProgress:[self getProgressWithArr:musicArray]];
//            ASLog(@"...");
//        });
//    } state:^(DownloadState state) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (state==DownloadStateCompleted) {
//                [self downCompletionWithArray:musicArray];
//                ASLog(@"第2次下载成功");
//
//            }else if (state==DownloadStateFailed){  //下载失败重新下载
//                [self downloadWithURL1:url andMusicArray:musicArray];
//                ASLog(@"第2次下载失败");
//
//            }
//            ASLog(@"第2次下载%u",state);
//
//        });
//    }];
//}
//-(void)downloadWithURL1:(NSString *)url andMusicArray:(NSArray *)musicArray{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//
//    [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self changeProgress:[self getProgressWithArr:musicArray]];
//        });
//    } state:^(DownloadState state) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (state==DownloadStateCompleted) {
//                [self downCompletionWithArray:musicArray];
//                ASLog(@"第3次下载成功");
//
//            }else if (state==DownloadStateFailed){  //下载失败重新下载
//                ASLog(@"第三次下载失败");
//            }
//        });
//    }];
//}
//
//- (void)downCompletionWithArray:(NSArray *) array{
//    if ([self chargeCompleteState:array]) {
//        [self.downBtn setImage:kIMAGE_Name(@"lxxz_Continue") forState:0];
//        _state =2;
//    }else{
//        ASLog(@"没有下载完");
//    }
//}
//
//- (CGFloat)getProgressWithArr:(NSArray *)musicArr{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    NSInteger size = 0;
//    CGFloat progress = 0;
//    for (NSString *Url in musicArr) {
//       size += [downManager fileTotalLength:Url];
//        progress += [downManager progress:Url];
//    }
//    return progress/musicArr.count;
//}
//- (NSInteger)getFileSizeWithArr:(NSArray *)musicArr{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    NSInteger size = 0;
//    for (NSString *Url in musicArr) {
//       size += [downManager fileTotalLength:Url];
//    }
//    return size;
//}
//- (BOOL)chargeCompleteState:(NSArray *)musicArr{
//    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    for (NSString *Url in musicArr) {
////        BOOL completion = [downManager isCompletion:Url];
//        if (![downManager isCompletion:Url]){
//            return NO;
//        }
//    }
//
//    return YES;
//}
@end
