//
//  MusicListViewController.m
//  ZQ_MusicPlayer
//
//  Created by Apple on 16/1/13.
//  Copyright © 2016年 YZQ. All rights reserved.
//

#import "MusicListViewController.h"
#import "ListTableViewCell.h"
#import "ListHeader.h"
#import "ListRequestManager.h"
#import "MusicPlayViewController.h"
//创建一个全局变量 的重用标示符
static NSString *reuseIdenti = @"list";
@interface MusicListViewController ()<UITableViewDataSource, UITableViewDelegate>
//歌单列表
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) MusicPlayViewController *playVC;

@end
@implementation MusicListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //自动为滚动视图添加属性关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏为不透明
    self.navigationController.navigationBar.translucent = NO;
    //初始化tableView
    self.listTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.listTableView];
    //设置代理
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    //注册cell
    [self.listTableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdenti];
    //请求列表页面数据
//    [[ListRequestManager shareInstance] requestWithUrl:kMusicUrl didFinsh:^{
//       //数据请求成功 刷新
//        [self.listTableView reloadData];
//    }];
    
    [[ListRequestManager shareInstance] requestWithFile:kMusicFile didFinsh:^{
        //数据请求成功 刷新
        [self.listTableView reloadData];
    }];
    
     self.playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playVC"];
}
#pragma mark - TableViewDelegate dataSource
//加横岗相当于分区
#pragma maek 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[ListRequestManager shareInstance] countOfArray];
}
#pragma mark 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdenti forIndexPath:indexPath];
    //设置cell的模型
    cell.model = [[ListRequestManager shareInstance] modelWithIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取播放控制器
//    MusicPlayViewController *playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playVC"];
    
    
//  playVC.index = indexPath.row;
 
    self.playVC.index = indexPath.row;
    
//    [self.navigationController pushViewController:playVC animated:YES];
 
    [self.navigationController pushViewController:self.playVC animated:YES];

}

@end
