//
//  RankViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/19.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "RankViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RankModel.h"
#import "HttpRequestManager.h"
#import "PlayerViewController.h"
#import "FMDatabase.h"
#import "DBManager.h"

#import "RankCell.h"

@interface RankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_rankTypeArray;
    NSArray *_rankImg;
    PlayerViewController *_player;
}
@property (weak, nonatomic) IBOutlet UITableView *rankTable;

@end

@implementation RankViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [PlayerViewController sharePlayerManager];
    
    _rankImg = @[@"RankCell_MiguMusic",@"RankCell_Migu24HotSell",@"RankCell_MiguKTV",@"RankCell_MiguNet",@"RankCell_MiguTelevision",@"RankCell_MiguOriginal"];
    _dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    _rankTable.delegate = self;
    _rankTable.dataSource = self;
    [_rankTable registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:@"RankCell"];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
    
}

- (void)getDataFromDB
{
    
    
    [_dataArray removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from rankDB"];
    
    while ([set next]) {
        RankModel *model = [[RankModel alloc] init];
        model.rankName = [set stringForColumn:@"name"];
        model.first = [set stringForColumn:@"one"];
        model.second = [set stringForColumn:@"tow"];
        model.Third = [set stringForColumn:@"three"];
        [_dataArray addObject:model];
        // NSLog(@"model.nameStr==%@",model.nameStr);
    }
    
    [_rankTable reloadData];
    
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
    [[HttpRequestManager shareManager] getRankDataWithSuccessBlock:^(id responseObj) {
        NSArray *array = responseObj;
        //NSLog(@"responseObj==%@",responseObj);
        
        [[DBManager shareManager].dataBase executeUpdate:@"delete from rankDB"];
        
        for (NSInteger i = 0; i < array.count; i++) {
           
            RankModel *model = [[RankModel alloc] init];
            model.rankName = array[i][@"title"];
            
            
            NSString *string1 = array[i][@"rankSongs"][0][@"title"];
            NSString *string2 = array[i][@"rankSongs"][0][@"singer"];
            model.first = [NSString stringWithFormat:@"1.%@-%@",string1,string2];
            
            string1 = array[i][@"rankSongs"][1][@"title"];
            string2 = array[i][@"rankSongs"][1][@"singer"];
            model.second = [NSString stringWithFormat:@"1.%@-%@",string1,string2];
            
            string1 = array[i][@"rankSongs"][2][@"title"];
            string2 = array[i][@"rankSongs"][2][@"singer"];
            model.Third = [NSString stringWithFormat:@"1.%@-%@",string1,string2];
            model.urlStr = array[i][@"url"];
            
            [[DBManager shareManager].dataBase executeUpdate:@"insert into rankDB(name,one,tow,three) values(?,?,?,?)",model.rankName,model.first,model.second,model.Third];
            
            
            [_dataArray addObject:model];
        }
        
        [_rankTable reloadData];
        
        
        
        
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
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankCell" forIndexPath:indexPath];
    
    RankModel *model = _dataArray[indexPath.row];
    
    cell.imgView.image = [UIImage imageNamed:_rankImg[indexPath.row]];
    cell.titleLabel.text = model.rankName;
    cell.firstLabel.text = model.first;
    cell.secondLabel.text = model.second;
    cell.lastLabel.text = model.Third;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.backgroundColor = [UIColor blackColor];
    label.text = @"排行榜";
    label.textColor = [UIColor whiteColor];
    return label;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 144.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RankModel *model = _dataArray[indexPath.row];
    _player.title = model.rankName;
    [[HttpRequestManager shareManager] getRankModelDataWithSuccessBlock:^(id responseObj) {
        
        NSDictionary *dic = responseObj;
      //  NSLog(@"responseObj==%@",responseObj);
        PlayerModel *model = [[PlayerModel alloc] init];
        
        
        
        model.imgStr =  dic[@"img"];
        model.timeStr = dic[@"publishTime"];
        model.headImgStr = dic[@"owner"][@"icon"];
        model.nameStr = dic[@"owner"][@"nickname"];
        
        NSArray *array = dic[@"songs"];
        
        //NSLog(@"%ld",array.count);
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            PlayCellModel *cellModel = [[PlayCellModel alloc] init];
            cellModel.nameStr = array[i][@"title"];
            cellModel.singerStr = array[i][@"singer"];
            cellModel.urlStr = array[i][@"url"];
            cellModel.imgStr = array[i][@"albumImg"];
            cellModel.contentidStr = array[i][@"contentid"];
            //NSLog(@"cellModel.imgStr==%@",cellModel.imgStr);
            [mutArray addObject:cellModel];
        }
        model.playModel = mutArray;
        
        // NSLog(@" model.nameStr==%@",model.nameStr);
        
        // NSLog(@"mutArray==%@",mutArray);
        
        [_player freshWithModel:model andBig:YES];
        
        
    } withURLStr:model.urlStr];
    

    
    
    [self.navigationController pushViewController:_player animated:YES];
    
    
    
    
    
    
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
