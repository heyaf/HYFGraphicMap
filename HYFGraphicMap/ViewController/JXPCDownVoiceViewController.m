//
//  JXPCDownVoiceViewController.m
//  JXPClientSideProject
//
//  Created by iOS on 2020/3/6.
//  Copyright © 2020 he. All rights reserved.
//

#import "JXPCDownVoiceViewController.h"
#import "JXPCDownVoiceTableViewCell.h"
#import "HSDownloadManager.h"

@interface JXPCDownVoiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *mutMusicArr;

@property (nonatomic,strong) NSMutableArray *downingMusicArr;  //正在下载的语音包数组
@property (nonatomic,strong) NSMutableArray *downingindexMusicArr;  //正在下载的语音包序号数组，存储的是index
@property (nonatomic,strong) NSMutableArray *pauseingindexMusicArr;  //正在暂停中的语音包序号数组，存储的是index

@end

@implementation JXPCDownVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kClearColor;
    self.mutMusicArr = [NSMutableArray arrayWithArray:self.voiceArray];
    self.downingindexMusicArr = [NSMutableArray arrayWithCapacity:0];
    self.pauseingindexMusicArr = [NSMutableArray arrayWithCapacity:0];
    
//    [self deleteSomeMp3];
    [self CreatUI];
}
- (void)CreatUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    bgView.backgroundColor = kRGBA(0, 0, 0, 0.3);
    [self.view addSubview:bgView];
    bgView.userInteractionEnabled = YES;


    CGFloat H = 360+kSafeAreaBottom;
    UIView *view1 = [[UIView alloc] init];
    view1.frame = CGRectMake(0,kScreenH-H,kScreenW,H+15);
    view1.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self.view addSubview:view1];

    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(kScreenW-50, 0, 50, 50);
    [btn setImage:kIMAGE_Name(@"yytc_cancel") forState:0];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [view1 addSubview:btn];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    view1.layer.cornerRadius = 15;
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, kScreenW-160, 16)];
    titlelabel.text = @"离线下载";
    titlelabel.textColor =kMainBlackColor;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = kNormalFont(18);
    [view1 addSubview:titlelabel];
     
    UILabel *titlelabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 44, kScreenW-40, 12)];
    titlelabel1.text = @"在Wi-Fi的网络环境下下载离线包";
    titlelabel1.textColor =kRGB(102, 102, 102);
    titlelabel1.textAlignment = NSTextAlignmentCenter;
    titlelabel1.font = kNormalFont(12);
    [view1 addSubview:titlelabel1];
    
    [view1 addSubview:self.tableView];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, kScreenW, 360+kSafeAreaBottom-71) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voiceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 117;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"JXPCDownVoiceTableViewCell";
    JXPCDownVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStringFormat(@"%@%li",cellID,indexPath.row)];
    if (!cell) {
        cell = [[[NSBundle  mainBundle]  loadNibNamed:@"JXPCDownVoiceTableViewCell" owner:self options:nil]  lastObject];
    }
    cell.dataDic = self.voiceArray[indexPath.row];
    NSArray *arr = self.voiceArray[indexPath.row][@"clientVoicePacketDetailsList"];
    NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dataDic in arr) {
        [musicArr addObject:dataDic[@"voiceUrl"]];
    }
    CGFloat f = [self CalculateProgressWithArray:musicArr];
    cell.Layerprogress = f;
    if (f>0&&f<1) {
        cell.btnImageStates =0;
    }
    cell.btnClickBlock = ^{
        [self cellButtonClickedIndex:indexPath.row];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}
- (void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
}
//下载按钮点击事件
-(void)cellButtonClickedIndex:(NSInteger)index{
    NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = self.voiceArray[index];
    NSArray *voiceArr = dic[@"clientVoicePacketDetailsList"];
    for (NSDictionary *dataDic in voiceArr) {
        [musicArr addObject:dataDic[@"voiceUrl"]];
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
    CGFloat f = [self CalculateProgressWithArray:musicArr];
    if (f==0) { //没有下载，此时应该去下载
        self.downingMusicArr = musicArr;
//        [self downMusicWithUrl:musicArr[0] andindex:index num:0];
        [_downingindexMusicArr addObject:kStringFormat(@"%ld",(long)index)];
        [self DownLoadContinueWithIndex:index];
        
    }else if (f==1){ //已经下载完成，此时删除
        for (NSString *url in musicArr) {
            [downManager deleteFile:url];
        }

        voiceCell.Layerprogress = 0;
    }else{
        //下载了一部分，此时有两种情况：暂停或者继续下载
        if ([_downingindexMusicArr containsObject:kStringFormat(@"%ld",(long)index)])
        {//正在下载，此时应该暂停
            
            [_pauseingindexMusicArr addObject:kStringFormat(@"%ld",(long)index)];
            [_downingindexMusicArr removeObject:kStringFormat(@"%ld",(long)index)];
            voiceCell.btnImageStates = 0;
            
        }else{ //暂停中，此时应该继续下载
            [_downingindexMusicArr addObject:kStringFormat(@"%ld",(long)index)];
            [_pauseingindexMusicArr removeObject:kStringFormat(@"%ld",(long)index)];
            voiceCell.btnImageStates=1;
            self.downingMusicArr = musicArr;
            [self DownLoadContinueWithIndex:index];
        }
        
    }
}

/// 计算下载进度,当progress>0.9默认下载完毕，是为了避免出现偶尔下载出现错误导致程序卡顿
/// @param musicArr 当前语音数组
-(CGFloat)CalculateProgressWithArray:(NSArray *)musicArr{
    CGFloat progress = [self getProgressWithArr:musicArr];
    if (progress>0.9) {
        return 1;
    }
    return progress;
}


//删除未下载完的数据
- (void)deleteSomeMp3{
    for (NSDictionary *musicDic in self.mutMusicArr) {
        NSArray *videoArr = musicDic[@"clientVoicePacketDetailsList"];
        NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *ddic in videoArr) {
            [mutArr addObject:ddic[@"voiceUrl"]];
        }
        if (![self chargeCompleteState:mutArr]) {
            for (NSString *urlStr in mutArr) {
                [[HSDownloadManager sharedInstance] deleteFile:urlStr];
            }
        }
    }
}

- (void)cellBtnClick:(NSInteger) index{
    NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = self.voiceArray[index];
    NSArray *voiceArr = dic[@"clientVoicePacketDetailsList"];
    for (NSDictionary *dataDic in voiceArr) {
        [musicArr addObject:dataDic[@"voiceUrl"]];
    }
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

    CGFloat f = [self chargeMusicArray:musicArr index:index];
    if (f==0) {
        self.downingMusicArr = musicArr;
        [self downMusicWithUrl:musicArr[0] andindex:index num:0];
    }else if (f==1){
        for (NSString *url in musicArr) {
            [downManager deleteFile:url];
        }
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
        JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
        voiceCell.Layerprogress = 1;
    }

}
//  0表示未下载 0-1表示下载中 1表示下载完成
- (CGFloat)chargeMusicArray:(NSArray *)musicArr index:(NSInteger)index{
    ASLog(@"判断进度--%f",[self getProgressWithArr:musicArr]);
    return [self getProgressWithArr:musicArr]>0.8?1:0;
}
//继续下载(把当前index下没下载的整理好放进一个数组)
- (void)DownLoadContinueWithIndex:(NSInteger)index{
    
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

    NSDictionary *musicDic = self.mutMusicArr[index];
    NSArray *videoArr = musicDic[@"clientVoicePacketDetailsList"];
    NSMutableArray *unDownloadArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *ddic in videoArr) {
        NSString *videoUrl = ddic[@"voiceUrl"];
        if (![downManager isCompletion:videoUrl]) {
            [unDownloadArr addObject:ddic[@"voiceUrl"]];
        }
    }
    
    NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dataDic in videoArr) {
        [musicArr addObject:dataDic[@"voiceUrl"]];
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
    //b判断当前index对应的数组是否已经下载完毕
    if (unDownloadArr.count==0) { //

        voiceCell.Layerprogress = 1;
        
    }else{
        voiceCell.Layerprogress = [self CalculateProgressWithArray:musicArr];
        voiceCell.btnImageStates = 1;
        
        if ([_pauseingindexMusicArr containsObject:kStringFormat(@"%ld",(long)index)]) {
            voiceCell.Layerprogress = [self CalculateProgressWithArray:self.downingMusicArr];
            voiceCell.btnImageStates = 0;
        }else{
            [self DownLoadContinueWithURl:unDownloadArr[0] index:index];

        }
    }
    
}
//继续下载，选择一个地址继续下载
- (void)DownLoadContinueWithURl:(NSString *)url index:(NSInteger)index{
       //暂停的数组中有当前index，则取消下载
        HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

        [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            
        } state:^(DownloadState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
            if (state==DownloadStateCompleted||state == DownloadStateFailed) {
                [self DownLoadContinueWithIndex:index];
            }
            });

        }];


}


- (void)downMusicWithUrl:(NSString *)url andindex:(NSInteger) index num:(NSInteger)Num{
    
    if ([_pauseingindexMusicArr containsObject:kStringFormat(@"%ld",(long)index)]) {
        
    }else{   //暂停的数组中有当前index，则取消下载
        HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

        [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            
        } state:^(DownloadState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
            if (state==DownloadStateCompleted) {
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                    voiceCell.Layerprogress = [self getProgressWithArr:self.downingMusicArr];
                    ASLog(@"下载成功%@",url);
                if (Num <self.downingMusicArr.count-1) {
                    NSInteger num = Num+1;
                    [self downMusicWithUrl:self.downingMusicArr[num] andindex:index num:num];
                }else{
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                    voiceCell.Layerprogress = 1;
                }
            }else if (state == DownloadStateFailed){
                if (Num <self.downingMusicArr.count-1) {
                    NSInteger num = Num+1;
                    [self downMusicWithUrl:self.downingMusicArr[num] andindex:index num:num];
                }else{
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                    voiceCell.Layerprogress = 1;
                }
            }
            });

        }];
    }

}



- (CGFloat)getProgressWithArr:(NSArray *)musicArr{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
    NSInteger size = 0;
    CGFloat progress = 0;
    for (NSString *Url in musicArr) {
       size += [downManager fileTotalLength:Url];
        progress += [downManager progress:Url];
    }
    return progress/musicArr.count;
}
- (NSInteger)getFileSizeWithArr:(NSArray *)musicArr{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
    NSInteger size = 0;
    for (NSString *Url in musicArr) {
       size += [downManager fileTotalLength:Url];
    }
    return size;
}
- (BOOL)chargeCompleteState:(NSArray *)musicArr{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
    for (NSString *Url in musicArr) {
//        BOOL completion = [downManager isCompletion:Url];
        if (![downManager isCompletion:Url]){
            return NO;
        }
    }
    
    return YES;
}
- (NSArray *)getNoComplateArrayWithArray:(NSArray *)musicArr{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *Url in musicArr) {
        if (![downManager isCompletion:Url]){
            [mutArr addObject:Url];
        }
    }
        
    return mutArr;
    
}


- (void)downMusicWithArray:(NSArray *)musicArray andindex:(NSInteger) index{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
//    [downManager deleteAllFile];
    for (NSString *Url in musicArray) {
        [downManager download:Url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                ASLog(@"----%f---%f",[self getProgressWithArr:musicArray],progress);


                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];
            });
        } state:^(DownloadState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (state==DownloadStateCompleted) {
                    
                    
//                    NSArray *arr = self.voiceArray[index][@"clientVoicePacket"][@"clientVoicePacketDetailsList"];
//                       NSMutableArray *musicArr = [NSMutableArray arrayWithCapacity:0];
//                       for (NSDictionary *dataDic in arr) {
//                           [musicArr addObject:dataDic[@"voiceUrl"]];
//                       }
//                    if ([self getNoComplateArrayWithArray:musicArr].cou) {
//
//                    }
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                    JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                    voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];
                    
                    ASLog(@"第1次下载成功%f",[self chargeMusicArray:musicArray index:index]);


                }else if (state==DownloadStateFailed){  //下载失败重新下载
                    ASLog(@"第1次下载失败");
                    [self downloadWithURL:Url andMusicArray:musicArray andindex:index];

                }
            });
        }];
    }
}


-(void)downloadWithURL:(NSString *)url andMusicArray:(NSArray *)musicArray andindex:(NSInteger) index{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];
    ASLog(@"第二次下载");
    [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
            JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
            voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (state==DownloadStateCompleted) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];

            }else if (state==DownloadStateFailed){  //下载失败重新下载
                [self downloadWithURL1:url andMusicArray:musicArray andindex:index];
                ASLog(@"第2次下载失败");

            }
            ASLog(@"第2次下载%u",state);

        });
    }];
}
-(void)downloadWithURL1:(NSString *)url andMusicArray:(NSArray *)musicArray andindex:(NSInteger) index{
    HSDownloadManager *downManager = [HSDownloadManager sharedInstance];

    ASLog(@"第三次下载");
    [downManager download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                 JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (state==DownloadStateCompleted) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                JXPCDownVoiceTableViewCell *voiceCell = [self.tableView cellForRowAtIndexPath:indexpath];
                voiceCell.Layerprogress = [self chargeMusicArray:musicArray index:index];

            }else if (state==DownloadStateFailed){  //下载失败重新下载
//                [SVProgressHUD showErrorWithStatus:@"下载失败，请稍后重试"];
            }
        });
    }];
}
@end
