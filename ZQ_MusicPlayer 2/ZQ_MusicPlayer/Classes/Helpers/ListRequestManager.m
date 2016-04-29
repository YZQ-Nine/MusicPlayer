#import "ListRequestManager.h"
#import "ListModel.h"
static ListRequestManager *manager = nil;
//创建延展
@interface ListRequestManager ()
//用来存放所有模型
@property (nonatomic, strong) NSMutableArray *modelArray;
@end
@implementation ListRequestManager
#pragma mark - 单例
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    manager = [ListRequestManager new];
    
    });
    return manager;
}
#pragma mark 懒加载
//get方法
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;

}
#pragma mark - 数据处理
#pragma mark 根据url请求数据 并进行回调
/*
-(void)requestWithUrl:(NSString *)url didFinsh:(void (^)())finsh{
     //开辟子线程请求数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *dataArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
        
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//        path = [path stringByAppendingString:@"/MusicInfoList.plist"];
//        [data writeToFile:path atomically:YES];
//        NSLog(@"%@",path);
        
    //进行数据的解析
    if (!dataArray) {
            return ;
        }
        //遍历数组 取出字典
        for (NSDictionary *dict in dataArray) {
            //创建模型 （建Model）
            ListModel *model = [[ListModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            //将模型存储进数组
            //
            [self.modelArray addObject:model];
        }
        
        //回到主线程 处理UI（位置一定要放在子线程里面，确保数据请求完成，有了数据，再刷新）
        dispatch_async(dispatch_get_main_queue(), ^{
            //block 回调
            finsh();
        });
    });
}
 */

- (void)requestWithFile:(NSString *)file didFinsh:(void (^)())finsh{
        //开辟子线程请求数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:file];
            //进行数据的解析
            if (!dataArray) {
                return ;
            }
            //遍历数组 取出字典
            for (NSDictionary *dict in dataArray) {
                //创建模型 （建Model）
                ListModel *model = [[ListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                //将模型存储进数组
                //
                [self.modelArray addObject:model];
            }
            
            //回到主线程 处理UI（位置一定要放在子线程里面，确保数据请求完成，有了数据，再刷新）
            dispatch_async(dispatch_get_main_queue(), ^{
                //block 回调
                finsh();
            });
        });
    }

#pragma mark 返回数组个数
-(NSInteger)countOfArray{

    return self.modelArray.count;
}


#pragma mark 根据下标返回模型
-(ListModel *)modelWithIndex:(NSInteger)index{

    ListModel *model = self.modelArray[index];
    return model;
}

@end
