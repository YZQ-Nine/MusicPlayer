//
//  LyricManager.m
//  ZQ_MusicPlayer
//
//  Created by lanou3g on 16/1/15.
//  Copyright © 2016年 姚志强. All rights reserved.
//

#import "LyricManager.h"
#import "ListModel.h"
#import "LyricModel.h"

static LyricManager *manager= nil;

@interface LyricManager  ()
//用来存放数据模型
@property (nonatomic, strong) NSMutableArray *allDataArr;
@end

@implementation LyricManager

#pragma mark 单例
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LyricManager new];
        
    });
    return manager;
}


#pragma mark 懒加载
- (NSMutableArray *)allDataArr{
    if (!_allDataArr) {
        _allDataArr = [NSMutableArray array];
    }
    return _allDataArr;
}

#pragma mark 格式化歌词，创建歌词模型
- (void)initLyricWithModel:(ListModel *)model{
    //先将数组里面的歌词移除， 再添加新的歌词
    [self.allDataArr removeAllObjects];
    //获取歌词
    NSString *sourceLyric = model.lyric;
    //将歌词切割成行
    NSArray *lyricArr = [sourceLyric componentsSeparatedByString:@"\n"];
    //将时间与歌词切割分隔开
    for (NSString *item in lyricArr) {
        //根据“]” 进行切割操作
        NSArray *itemArr = [item componentsSeparatedByString:@"]"];
        //创建模型 给模型赋值
         //对时间转化处理，转化成秒
        //如果时间值为空 不执行， 如果时间值不为空， 执行
        if ([[itemArr firstObject] length] >= 2) {
        
        float seconds = [self formatTime:[itemArr firstObject]];
        NSString *lyric = [itemArr lastObject];
        //组建数组
        LyricModel *model = [[LyricModel alloc] initWithLayric:lyric time:seconds];
        //将创建好的模型装入数组
        [self.allDataArr addObject:model];
        
        }
        
    }
    
}

#pragma mark 转换时间为多少秒

- (float)formatTime:(NSString *)time{
    //[00:01  去“[”

    NSString *timeValue = [time substringFromIndex:1];
    // 00：01  分别获取分钟和秒数
    NSString *minute = [[timeValue componentsSeparatedByString:@":"] firstObject];//数组的首个元素
    NSString *seconds = [[timeValue componentsSeparatedByString:@":"] lastObject];
    return [minute floatValue] * 60 + [seconds floatValue];
}

-(NSInteger)countOfArray{
    return self.allDataArr.count;
}

-(LyricModel *)modelAtIndex:(NSInteger)index{
    LyricModel *model = self.allDataArr[index];
    return model;
}

#pragma mark 根据播放时间返回下标
-(NSInteger)indexForProgress:(float)progress{
    //遍历模型数组，取出模型对应的时间
    //将模型对应时间 与 当前播放时间进行对比
    //对比规则：前一句歌词时间 < 当前播放时间 < 后一句歌词时间
    //取 前一句歌词显示
    
    int index = 0;
    for (int i = 0; i < self.allDataArr.count - 1; i++) {
//        //判断如果是最后一行 不做对比
//        if (i == self.allDataArr.count - 1) {
//            break;
//        }
        LyricModel *model1 = self.allDataArr[i];
        LyricModel *model2 = self.allDataArr[i + 1];
        //获取时间
        float time1 = model1.time;
        float time2 = model2.time;
        if (progress >= time1 && progress < time2) {
            //记录应该显示的歌词的下标
            index = i;
        }
        
        if (progress >= time2) {
            index = i + 1;
        }
    }
    return index;
}


@end
