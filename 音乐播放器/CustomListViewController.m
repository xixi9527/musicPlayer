//
//  CustomListViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/27.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "CustomListViewController.h"

#import "RESideMenu.h"

#import "ListViewController.h"

#import "MysMusic.h"

#import "NameSingerModel.h"

#import "NameSingerModel.h"

#import "DBManager.h"

@interface CustomListViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation CustomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"188"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.title = @"我的歌单";
    
}

- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}



#pragma mark -tableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = @"喜欢";
    cell.backgroundColor = [UIColor brownColor];
    



    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
        
    ListViewController *vc = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from music"];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    while ([set next]) {
        NameSingerModel *model = [[NameSingerModel alloc] init];
        model.name = [set stringForColumn:@"name"];
        model.singer = [set stringForColumn:@"singer"];
        [mutArray addObject:model];
        
    }
    [vc reloadCell:mutArray];
//
    
    
    [self.navigationController pushViewController:vc animated:YES];
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
