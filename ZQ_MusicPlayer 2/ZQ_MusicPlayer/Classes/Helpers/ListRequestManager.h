//
//  ListRequestManager.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//

/**
 *  用于管理音乐列表页面的数据请求和数据处理
 */

#import <Foundation/Foundation.h>

//声明类
@class ListModel;

@interface ListRequestManager : NSObject

/**
 *  shareInstance 单例
 */

+ (instancetype)shareInstance;

/**
 *@param NSString url 数据接口 didFinsh 成功回调
 *@return Void
 **/

//- (void)requestWithUrl:(NSString *)url didFinsh:(void(^)())finsh;
- (void)requestWithFile:(NSString *)file didFinsh:(void(^)())finsh;

/**
 *@param NSInterger count 数组个数
 **/
- (NSInteger)countOfArray;


/**
 *@param index 下标
 *@return model 歌曲模型
 **/

- (ListModel *)modelWithIndex:(NSInteger)index;
@end
