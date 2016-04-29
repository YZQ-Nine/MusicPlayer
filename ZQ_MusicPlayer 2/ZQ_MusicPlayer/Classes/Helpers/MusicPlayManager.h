//
//  MusicPlayManager.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 YZQ. All rights reserved.
//

/**
 *  用于管理音乐播放的相关操作
 */
#import <Foundation/Foundation.h>
@class ListModel;
// 播放器协议
@protocol AVplayerDelegate <NSObject>

/**
 *播放过程中一直执行
 *@param 播放进度
 *
 **/
- (void)playerPlayingWithProgress:(float)progress;

/**
 *播放结束的时候执行
 *
 **/
- (void)playEndToTime;
@end
@interface MusicPlayManager : NSObject
//记录播放状态
@property (nonatomic, assign) BOOL state;
//播放器声音
@property (nonatomic, assign) float volume;

@property (nonatomic, assign)id<AVplayerDelegate>playDelegate;

/**
 *  单例
 */
+ (instancetype)shareInstance;

/**
 @program model 音乐模型
 *  设置唱片
 */
- (void)prePareTopPlayWithModel:(ListModel *)model;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
停止
 */
- (void)stop;

/**
 *@param 声音的值 float
 **/
- (void)setVolumeValue:(float)value;

/**
 * 从指定时间进行播放
 *  value float 指定时间
 */
- (void)seekTimeToPlay:(float)value;

@end
