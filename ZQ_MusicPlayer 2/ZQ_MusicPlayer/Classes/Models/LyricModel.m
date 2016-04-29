//
//  LyricModel.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/15.
//  Copyright © 2016年 YZQ. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
#pragma mark 初始化

- (LyricModel *)initWithLayric:(NSString *)lyric time:(float)time{

    self = [super init];
    if (self) {
        self.lyric = lyric;
        self.time = time;
    }
    return self;
}
@end
