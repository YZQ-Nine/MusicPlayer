//
//  ListModel.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//



/**
 *  音乐列表模型
 */

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
//MP3的地址
@property(nonatomic, copy) NSString *mp3Url;
//歌曲ID
@property(nonatomic, copy) NSString *ID;
//歌名
@property(nonatomic, copy) NSString *name;
//图片地址
@property(nonatomic, copy) NSString *picUrl;
//缩略图地址
@property(nonatomic, copy) NSString *blurPicUrl;
//专辑
@property(nonatomic, copy) NSString *album;
//歌手
@property(nonatomic, copy) NSString *singer;
//时长
@property(nonatomic, copy) NSString *duration;
//作家名字
@property(nonatomic, copy) NSString *artists_name;
//歌词
@property(nonatomic, copy) NSString *lyric;

@end
