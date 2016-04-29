//
//  ListModel.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//


#import "ListModel.h"

@implementation ListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //如果是id, 将value赋值给ID
    if ([key isEqualToString:@"id"]) {
        self.ID =value;
    }

}

@end
