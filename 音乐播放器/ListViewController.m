//
//  ListViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/21.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "ListViewController.h"

#import "NameSingerModel.h"

#import "HotCell.h"

#import "MysMusic.h"


#import "RESideMenu.h"


#import <AVFoundation/AVFoundation.h>
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.delegate = self;
    _tableView.dataSource =self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    imageView.image = [UIImage imageNamed:@"328552-130P323230567.jpg"];
    
    _tableView.tableHeaderView = imageView;
    _tableView.backgroundColor = [UIColor grayColor];
}

#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameSingerModel *model = _dataArray[indexPath.row];
    
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell"];
    
    cell.nameLabel.text = model.name;
    
    cell.singerLabel.text = model.singer;
    
    
    
    cell.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView.superview.backgroundColor = [UIColor redColor];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    MysMusic *fatherVC = (MysMusic *)self.parentViewController;
    
    if (![fatherVC isKindOfClass:[UINavigationController class]]  ){
    [fatherVC creatMP3Play:fatherVC.MP3DataArr[indexPath.row]];
    //[fatherVC.player play];
    } else {
        MysMusic *mys = [[MysMusic alloc] initWithNibName:@"MysMusic" bundle:nil];\
        
        
        
        
        [mys creatMP3Play:mys.MP3DataArr[indexPath.row]];
        [mys.playButton setImage:[UIImage imageNamed:@"tone_play.png"]   forState:UIControlStateNormal];
        [mys.playButton setTitle:@"播放" forState:UIControlStateNormal];
        
        
        
        
        //[self presentViewController:mys animated:YES completion:nil];
        //[self.sideMenuViewController presentLeftMenuViewController];
       // [mys.player play];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (void)reloadCell:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [_tableView reloadData];
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
