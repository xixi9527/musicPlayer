//
//  DownManagerVC.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/26.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "DownManagerVC.h"

#import "NameSingerModel.h"
#import "DBManager.h"
#import "RESideMenu.h"
#import "FMDatabase.h"
#import "HotCell.h"

@interface DownManagerVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation DownManagerVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"188"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    self.title = @"下载管理";
    
    _tableView.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    [_tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    
}


- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)viewDidAppear:(BOOL)animated
{
    //数据库获得数据
    [_dataArray removeAllObjects];
    
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from music"];
    
    while ([set next]) {
       // NSLog(@"name==%@",[set stringForColumn:@"name"]);
        NameSingerModel *model = [[NameSingerModel alloc] init];
        model.name = [set stringForColumn:@"name"];
        model.singer = [set stringForColumn:@"singer"];
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
    
}


#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NameSingerModel *model = _dataArray[indexPath.row];
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
    cell.nameLabel.text = model.name;
    cell.singerLabel.text = model.singer;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        //删除下载的文件
        NameSingerModel *model =  _dataArray[indexPath.row];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        [fm removeItemAtPath:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.mp3",model.name]] error:&error];
        if (error) {
            NSLog(@"删除失败error==%@",error);
        }
        //删除数据库里面的内容
        NSLog(@"name==%@",model.name);
        if ([[DBManager shareManager].dataBase executeUpdate:@"delete from music where name=?",model.name])
        {
            //NSLog(@"数据库删除成功");
        }
        
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
