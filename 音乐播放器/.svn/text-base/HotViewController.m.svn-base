//
//  HotViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/22.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "HotViewController.h"
#import "HotCell.h"
#import "HotModel.h"
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"
#import "PlayerViewController.h"
#import "PlayCellModel.h"
#import "MusicPlayViewController.h"
#import "MysMusic.h"
#import "FMDatabase.h"
#import "DBManager.h"




@interface HotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    PlayerViewController *_player;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [PlayerViewController sharePlayerManager];
    _dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    
    [self getData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
    
}


- (void)getDataFromDB
{
    [_dataArray removeAllObjects];
    [_dataArray removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from hotDB"];
    
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
    

    
  
    [[HttpRequestManager shareManager] getHotDataWithSuccessBlock:^(id responseObj) {
         [[DBManager shareManager].dataBase executeUpdate:@"delete from hotDB"];
        NSArray *array = responseObj;
        for (NSInteger i = 0; i < array.count; i++) {
            HotModel *model = [[HotModel alloc] init];
            model.imgUrlStr = array[i][@"albumImg"];
            model.titleStr = array[i][@"title"];
            model.urlStr = array[i][@"url"];
            NSString *string = [array[i][@"singer"] stringByAppendingString:@"-"];
            NSString *string2 = array[i][@"album"];
            model.singerStr = [string stringByAppendingString:string2];
            model.contentidStr = array[i][@"contentid"];
            
            if (![[DBManager shareManager].dataBase executeUpdate:@"insert into hotDB(name,singer) values(?,?)",model.titleStr,model.singerStr]) {
                NSLog(@"插入数据失败");
            }


            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        
    } andFailureBlock:^(NSError *error) {
       
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
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr]];
    cell.nameLabel.text = model.titleStr;
    cell.singerLabel.text = model.singerStr;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activities_bg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 999, 30)];
    label.text = @"热门歌曲";
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
