//
//  MusicPlayManager.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 YZQ. All rights reserved.
//


#import "MusicPlayManager.h"
#import "ListModel.h"
#import <AVFoundation/AVFoundation.h>
static MusicPlayManager *manager = nil;

@interface MusicPlayManager ()
//播放器
@property (nonatomic, strong)AVPlayer *musicPlayer;

@property (nonatomic, strong) NSTimer *timer;

@end
@implementation MusicPlayManager

//类方法内不能用 self
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MusicPlayManager new];
        
    });
    return manager;
}
#pragma mark  初始化方法
- (instancetype)init{
    self.musicPlayer = [AVPlayer new];
    //设置起始状态为暂停
    self.state = 0;
    
    
    //起始值给一个默认的音量
    //系统播放器的音量
    self.musicPlayer.volume = 0.5;
    //定义的音量
    self.volume = 0.5;
    
    //注册播放状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:@"status"options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //注册播放结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    return self;
}


- (void)playEnd{

    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(playEndToTime)]) {
        //让代理去执行协议方法
        [self.playDelegate playEndToTime];
    }
}

#pragma mark 设置唱片 准备播放
-(void)prePareTopPlayWithModel:(ListModel *)model{

    //获取音乐播放地址，创建唱片
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.mp3Url]];
    //给播放器配置唱片
    [self.musicPlayer replaceCurrentItemWithPlayerItem:item];
}

#pragma mark 播放
-(void)play{
  
    if (self.state == YES) {
        return;
    }
    
    //创建计时器
   self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    
    [self.musicPlayer play];
    //设置为播放状态
    self.state = YES;
}

#pragma mark 播放过程中持续执行
- (void)playing{
   //让代理操作UI  等数据
   //当前播放时间 以秒为单位
     CGFloat seconds = self.musicPlayer.currentTime.value / self.musicPlayer.currentTime.timescale;
    //让代理去执行协议方法
    if (self.playDelegate && [self.playDelegate respondsToSelector:@selector(playerPlayingWithProgress:)]) {
        [self.playDelegate playerPlayingWithProgress:seconds];
    }
}

#pragma mark 暂停
- (void)pause{
    
    //废除计时器
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.state == NO) {
        return;
    }
    
    [self.musicPlayer pause];
       
    //设置为暂停状态
    self.state = NO;
}
#pragma mark 停止
-(void)stop{

}

#pragma mark 调整播放器音量
-(void)setVolumeValue:(float)value{
    self.musicPlayer.volume = value;

}

#pragma mark 从指定时间进行播放
- (void)seekTimeToPlay:(float)value{
    [self pause];
    
    //单位是秒 第一个参数是当前时间
    CMTime time = CMTimeMakeWithSeconds((int)value, self.musicPlayer.currentTime.timescale);
    [self.musicPlayer seekToTime:time completionHandler:^(BOOL finished) {
        //再播放
        if (finished == YES) {
            [self play];
        }
        
    }];
}

@end
