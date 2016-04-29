//
//  LyricModel.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 YZQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
//歌词属性
@property(nonatomic, copy) NSString *lyric;//用copy的原因，因为涉及到可变的，
//歌词对应时间
@property (nonatomic, assign) float time;

/**
 *  自定义初始化
 */
- (LyricModel *)initWithLayric:(NSString *)lyric time:(float)time;

@end
