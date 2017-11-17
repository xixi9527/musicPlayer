//
//  EnglishViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/28.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "EnglishViewController.h"
#import "HotCell.h"
#import "HotModel.h"
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"
#import "PlayCellModel.h"
#import "MusicPlayViewController.h"
#import "MysMusic.h"
#import "FMDatabase.h"
#import "DBManager.h"

@interface EnglishViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation EnglishViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
}


- (void)getDataFromDB
{
    
    
    [_dataArray removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from englishDB"];
    
    while ([set next]) {
        HotModel *model = [[HotModel alloc] init];
        model.titleStr = [set stringForColumn:@"name"];
        model.singerStr = [set stringForColumn:@"singer"];
        [_dataArray addObject:model];
        // NSLog(@"model.nameStr==%@",model.nameStr);
    }
    
    [_tableView reloadData];
    
    /*
     for (NSInteger i = 0; i < array.count; i++) {
     RecommendModel *model = [[RecommendModel alloc] init];
     model.imgUrlStr = array[i][@"img"];
     model.nameStr = array[i][@"title"];
     model.contentStr = array[i][@"summary"];
     //进入里面的界面
     model.intoUrlStr = array[i][@"url"];
     
     [_dataArray addObject:model];
     // NSLog(@"-------------model.imgUrlStr==%@",model.imgUrlStr);
     }
     [_collectionView reloadData];
     */
    
    
    //FMResultSet *rs = [manager.dataBase executeQuery:@"slect*from goods"]
}



- (void)getData
{
    [_dataArray removeAllObjects];
    [[HttpRequestManager shareManager] getWomenDataWithSuccessBlock:^(id responseObj) {
       
        [[DBManager shareManager].dataBase executeUpdate:@"delete from englishDB"];
        
        NSArray *array = responseObj[@"songs"];
        //NSLog(@"array==%@",array);
        for (NSInteger i = 0; i < array.count; i++) {
            
            HotModel *model = [[HotModel alloc] init];
            model.imgUrlStr = array[i][@"singerImg"];
            model.urlStr = array[i][@"url"];
            model.titleStr = array[i][@"title"];
            model.singerStr = array[i][@"album"];
            model.contentidStr = array[i][@"contentid"];
            
            [[DBManager shareManager].dataBase executeUpdate:@"insert into englishDB (name,singer) values(?,?)",model.titleStr,model.singerStr];
            
            
            [_dataArray addObject:model];
            
        }
       // NSLog(@"_dataArray==%@",_dataArray);
        [_tableView reloadData];
        
    } andFailureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
    }];
}


#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell"];
    HotModel *model = _dataArray[indexPath.row];
    cell.nameLabel.text = model.titleStr;
    cell.singerLabel.text = model.singerStr;
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr]];
    //NSLog(@"model.urlStr==%@",model.urlStr);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 999, 30)];
    label.text = @"推荐歌曲";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor lightGrayColor];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayCellModel *playCellModel = [[PlayCellModel alloc] init];
    HotModel *model = _dataArray[indexPath.row];
    playCellModel.nameStr = model.titleStr;
    playCellModel.singerStr = model.singerStr;
    playCellModel.urlStr = model.urlStr;
    playCellModel.imgStr = model.imgUrlStr;
    playCellModel.contentidStr = model.contentidStr;
//    cellModel.contentidStr = 
    MusicPlayViewController *vc = [MusicPlayViewController shareManager];
    [vc createPlayerWithUrlStr:[NSString stringWithFormat:@"%@%@",model.urlStr,APPEND]];
    [vc.dataArray addObject:playCellModel];
    
    
    
    vc.title = playCellModel.nameStr;
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    MysMusic *mys = [[MysMusic alloc]  initWithNibName:@"MysMusic" bundle:nil];
    [mys.player pause];
    [mys.playButton setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
    [mys.playButton setTitle:@"播放" forState:UIControlStateNormal];

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
