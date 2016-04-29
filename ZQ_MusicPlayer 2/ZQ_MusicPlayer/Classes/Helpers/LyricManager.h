//
//  LyricManager.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 YZQ. All rights reserved.
//

/**
 *  处理歌词
 */

#import <Foundation/Foundation.h>

@class ListModel;
@class LyricModel;
@interface LyricManager : NSObject

//单例的实现
+ (instancetype)shareInstance;

/**
 *解析歌词
 *@param model 歌曲模型
 *@return Void
 **/
- (void)initLyricWithModel:(ListModel *)model;

/**
 *  返回数组个数
 */
- (NSInteger)countOfArray;

- (LyricModel *)modelAtIndex:(NSInteger)index;


/**
 *@param float 播放时间
 *@return NSInteger 应该显示的歌词下标
 **/
- (NSInteger)indexForProgress:(float)progress;

@end
