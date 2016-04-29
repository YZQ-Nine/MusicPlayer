//
//  ListTableViewCell.h
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//


#import <UIKit/UIKit.h>

@class ListModel;
@interface ListTableViewCell : UITableViewCell
//歌曲模型
@property (nonatomic,strong) ListModel *model;
@end
