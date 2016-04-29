//
//  MusicPlayViewController.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//


#import "MusicPlayViewController.h"
#import "ListModel.h"
#import "MusicPlayManager.h"
#import "ListRequestManager.h"
#import "UIImageView+WebCache.h"
#import "LyricManager.h"
#import "LyricModel.h"
//枚举器 播放模式
typedef NS_ENUM(NSInteger, PlayType){
    //单曲
    PlayTypeSingle,
    //顺序
    PlayTypeShunXun,
    //顺序
    PlayTypeRandom,

};
@interface MusicPlayViewController ()<AVplayerDelegate, UITableViewDataSource, UITableViewDelegate>
//歌曲图片
@property (weak, nonatomic) IBOutlet UIImageView *singerImageView;
#pragma mark - 26
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
//时间量程（进度条）
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
//音量量程
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
//播放或停止按钮
@property (weak, nonatomic) IBOutlet UIButton *startOrStopButton;

//当前播放的下标
@property (nonatomic, assign) NSInteger currentIndex;

//播放模式
@property (nonatomic, assign) PlayType playModel;


//歌词显示
@property (weak, nonatomic) IBOutlet UITableView *LyricTable;
@end


static NSString *identifi = @"lyricCell";

@implementation MusicPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //151
    self.LyricTable.dataSource = self;
    self.LyricTable.delegate = self;
    
    //108 设置滑竿的初始值，最大。最小
    self.volumeSlider.minimumValue = 0.0;
    self.volumeSlider.maximumValue = 1.0;
    self.volumeSlider.value = [MusicPlayManager shareInstance].volume;
    
   //99 设置时间滑竿的起始值及最小值
    self.timeSlider.minimumValue = 0;
    self.timeSlider.value = 0;
    
    //93设置代理
    [MusicPlayManager shareInstance].playDelegate = self;
    
    //24、打开layer的masksToBounds属性  为yes,
    self.singerImageView.layer.masksToBounds = YES;
    //self.singerImageView.clipsToBounds = YES;
   
    //25、
    //圆角之前使约束提前生效；
//    [self.singerImageView layoutIfNeeded];
    self.singerImageView.layer.cornerRadius = CGRectGetHeight(self.singerImageView.frame) / 2;

//   
//    //49（1）根据下标获取模型
//    ListModel *model = [[ListRequestManager shareInstance] modelWithIndex:self.index];
//    //50（2）设置唱片
//    [[MusicPlayManager shareInstance] prePareTopPlayWithModel:model];
    

    //55设置歌曲
//    [self exchangeMusic];
    //62  -1 是为了避免第一次播放选择的是第0首或者是后面的歌曲；
    self.currentIndex = -1;
    
    //注册cell
    
    [self.LyricTable registerClass:[UITableViewCell class] forCellReuseIdentifier:identifi];
    
    
}

//60

- (void)viewWillAppear:(BOOL)animated{
    //判断要播放的歌曲和正在比播放的歌曲是否为同一首
    if (self.index == self.currentIndex) {
        return;
    }
    
    //63接收index
    self.currentIndex = self.index;
    //55切换歌曲
    [self exchangeMusic];
    
    
}


#pragma mark 切歌
//52
- (void)exchangeMusic{
    
    //49（1）根据下标获取模型
//    ListModel *model = [[ListRequestManager shareInstance] modelWithIndex:self.index];
    
    //64
    ListModel *model = [[ListRequestManager shareInstance] modelWithIndex:self.currentIndex];
    
    
    //50（2）设置唱片
    [[MusicPlayManager shareInstance] prePareTopPlayWithModel:model];
    
    
    //67
    [[MusicPlayManager shareInstance] play];
    
    //71设置歌曲图片
    [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    //72 设置图片填充模式
    self.singerImageView.contentMode = 0;
    //73设置图片起始角度
    self.singerImageView.transform = CGAffineTransformMakeRotation(0);
    
    [self.startOrStopButton setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
    
    
    //97
    //获取歌曲时长 duration是以毫秒为单位 需要转换成秒
   CGFloat dutation = [model.duration floatValue] / 1000;
    //98设置时间滑竿的最大值
    self.timeSlider.maximumValue = dutation;
    
    //150设置歌词
    [[LyricManager shareInstance] initLyricWithModel:model];
    
    [self.LyricTable reloadData];
   
}

#pragma mark 模式按钮点击方法
//120
#pragma mark 单曲
- (void)singleMOdel{
    //设置播放模式为单曲循环
    self.playModel = PlayTypeSingle;
    //设置时间为0;
    [[MusicPlayManager shareInstance] seekTimeToPlay:0];

}
//121
#pragma mark 随机
- (void)randomMode{
    //设置播放模式为随机
    self.playModel = PlayTypeRandom;
    //获取随机下标
    self.currentIndex = arc4random() / [[ListRequestManager shareInstance] countOfArray];
    //切换歌曲
//    [self exchangeMusic];
    
}
//122
#pragma mark 顺序
- (void)shunUxModel{
    self.playModel = PlayTypeShunXun;
    if (self.currentIndex == [[ListRequestManager shareInstance] countOfArray] - 1) {
        self.currentIndex = 0;
    } else{
        
        self.currentIndex++;

    }
    
//    [self exchangeMusic];
}



#pragma mark  上一曲

- (IBAction)beforeSongAction:(UIButton *)sender {
     //68
    if (self.currentIndex == 0) {
        //如果是第一首歌曲，点击上一首 切换为最后一首
        self.currentIndex = [[ListRequestManager shareInstance] countOfArray] - 1;
        [self exchangeMusic];
       return;
    }
    
    
    //65
    self.currentIndex--;
    //53
//    self.index -= 1;
    
    [self exchangeMusic];
//    [[MusicPlayManager shareInstance] play];

}
#pragma mark  播放或暂停


- (IBAction)playAction:(UIButton *)sender {
    
    //80 获取当前音乐播放器的状态
    BOOL state = [MusicPlayManager shareInstance].state;
    
    if (state == YES) {
        //81
        //处于播放状态 切换到暂停
        [[MusicPlayManager shareInstance] pause];
        [self.startOrStopButton setBackgroundImage:[UIImage imageNamed:@"8"] forState:UIControlStateNormal];
        
    }else {
        //82
        //处于暂停状态 切换到播放
        [[MusicPlayManager shareInstance] play];
        [self.startOrStopButton setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
        

    
    }
    
    
    //51
//    [[MusicPlayManager shareInstance] play];
    

}
#pragma mark  下一曲
//54
- (IBAction)NextSongAction:(UIButton *)sender {
    //69
    if (self.currentIndex == [[ListRequestManager shareInstance] countOfArray] - 1) {
       //如果是最后一曲，点击下一曲， 切换为第一首
        self.currentIndex = 0;
        [self exchangeMusic];
        return;
    }
    
    //66
    self.currentIndex++;
    //    self.index += 1;
    [self exchangeMusic];
//    [[MusicPlayManager shareInstance] play];

}
#pragma mark  改变播放进度

- (IBAction)changeTimeAction:(UISlider *)sender {
//111
    [self.startOrStopButton setBackgroundImage:[UIImage imageNamed:@"9"] forState:UIControlStateNormal];
    [[MusicPlayManager shareInstance]seekTimeToPlay:sender.value];

    

}
#pragma mark  改变音量
//107
- (IBAction)changeVolumeAction:(UISlider *)sender {
    //改变播放器的音量
    [[MusicPlayManager shareInstance] setVolumeValue:sender.value];

}

#pragma mark 切换循环模式


#pragma mark - AVPlayerDelegate

#pragma mark 播放过程中执行
//94
-(void)playerPlayingWithProgress:(float)progress{
    //95
    //设置图片旋转
    self.singerImageView.transform = CGAffineTransformRotate(self.singerImageView.transform, M_PI / 180);
    //96
    //设置进度条的Value
    //99
    self.timeSlider.value = progress;
    
    //101
    //设置播放时间
    self.beginTimeLabel.text = [self transFormTime:progress];
    
    //102
    //设置剩余时间
    
    //获取歌曲总时长 - 当前播放时间 = 剩余时间
    ListModel *model = [[ListRequestManager shareInstance] modelWithIndex:_currentIndex];
    float totalSecond =  [model.duration floatValue] /1000 - progress;
    self.endTimeLabel.text = [self transFormTime:totalSecond];
    
    //根据播放时间获取下标
      NSInteger index = [[LyricManager shareInstance]indexForProgress:progress];
    //让tableView滚动到对应的行并选中
    //组拼indexPath
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    //设置播放选中位置
    [self.LyricTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
//117
#pragma mark 播放结束
- (void)playEndToTime{
  //判定当前的播放模式
    switch (self.playModel) {
        case 0:{
            //单曲
            [self singleMOdel];
            break;
        }
        case 1:{
            //顺序
            [self shunUxModel];
            [self exchangeMusic];
            break;
        }
        case 2:{
            //随机
            [self randomMode];
            [self exchangeMusic];
            break;
        }
        default:
            break;
    }


}

#pragma mark  转换时间模式
//100
- (NSString *)transFormTime:(float)progress{
     //计算分钟 02d  设置为两列，不足的话补0;
    NSString *minitue = [NSString stringWithFormat:@"%02d", (int)(progress / 60)];
    //计算秒
    NSString *second = [NSString stringWithFormat:@"%02d", ((int)progress % 60)];

    return [NSString stringWithFormat:@"%@:%@",minitue, second];
}

- (IBAction)addVomuleAction:(UIButton *)sender {


}
- (IBAction)subVomuleAction:(UIButton *)sender {


}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return [[LyricManager shareInstance] countOfArray];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi forIndexPath:indexPath];
   
    //根据下标获取模型
    LyricModel *model = [[LyricManager shareInstance] modelAtIndex:indexPath.row];
    cell.textLabel.text = model.lyric;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //设置选中时歌的颜色
    cell.highlighted = YES;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
