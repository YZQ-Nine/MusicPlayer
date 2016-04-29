//
//  ListTableViewCell.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//

#import "ListTableViewCell.h"
#import "ListModel.h"
#import "UIImageView+WebCache.h"
@interface ListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@end

@implementation ListTableViewCell

- (void)setModel:(ListModel *)model{
   //控件的值
    //歌名
    self.nameLabel.text = model.name;
    //作者
    self.singerLabel.text = model.singer;
    //图片
   [self.photoView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];


}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
