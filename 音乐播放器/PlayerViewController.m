//

//热门歌曲什么的没有加到播放列表之中,估计是没刷新


//  PlayerViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/24.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#define APPEND @"&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1"

#import "PlayerViewController.h"
#import "UIImageView+AFNetworking.h"

#import "PlayerCell.h"
#import "PlayCellModel.h"
#import "CustomHeadView.h"
#import "CustomHeadView2.h"
#import "MusicPlayViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    NSArray *_playArray;
    CustomHeadView *_headView;
    CustomHeadView2 *_view;
    AVPlayer *_player;
}

@end

@implementation PlayerViewController

+ (instancetype)sharePlayerManager
{
    static PlayerViewController *manager = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        manager = [[PlayerViewController alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
    // Do any additional setup after loading the view.
    
    
    
 
    
    [self createUI];
    

}


- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PlayerCell" bundle:nil] forCellReuseIdentifier:@"PlayerCell"];
    
    self.navigationController.navigationBar.alpha = 0.4;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setImage:[UIImage imageNamed:@"img_player_entrance_disk"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = item;
}


- (void)rightPush
{
    MusicPlayViewController *vc = [MusicPlayViewController shareManager];
    [self.navigationController pushViewController:vc animated:YES];
}




-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.alpha = scrollView.contentOffset.y / 20 + 0.4;
    if (scrollView.contentOffset.y< 0) {
        self.navigationController.navigationBar.alpha = 0.4;
    }
}


- (void)freshWithModel:(PlayerModel *)model andBig:(BOOL)isBig
{
    //NSLog(@"dataArray ==%@",_dataArray);
    
    _playArray = model.playModel;
   // NSLog(@"_playArray==%@",_playArray);
    _dataModel = model;
    [_tableView reloadData];
    //NSLog(@"_dataModel.imgStr==%@",_dataModel.imgStr);
    
    
    if (isBig) {
        
        _view = [[NSBundle mainBundle] loadNibNamed:@"View2" owner:self options:nil][0];
        
        
        //NSLog(@"%@",_dataModel.imgStr);
        [_view.bigImgView setImageWithURL:[NSURL URLWithString:_dataModel.imgStr]];
        
        
        

        _view.timeLabel.text = _dataModel.timeStr;
        _tableView.tableHeaderView = _view;
        
        
        
    } else {
        _headView = [[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil][0];
        
        
        
        [_headView.bigImgView setImageWithURL:[NSURL URLWithString:_dataModel.imgStr]];
        
        [_headView.smallImgView setImageWithURL:[NSURL URLWithString:_dataModel.headImgStr]];
        if (isBig) {
            _headView.bigImgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
            
        }
        _headView.nameLabel.text = _dataModel.nameStr;
        _headView.timeLabel.text = _dataModel.timeStr;
        _tableView.tableHeaderView = _headView;
    
    }
    
}

- (void)freshWithMusic:(PlayCellModel *)model
{
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithObjects:model, nil];

    [mutArray addObjectsFromArray:_playArray];
    _playArray = mutArray;
    [_tableView reloadData];
    //NSLog(@"%ld",_playArray.count);
}

#pragma mark -tableView



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _playArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    PlayCellModel *model = _playArray[indexPath.row];
    cell.nameLabel.text = model.nameStr;
    cell.singerLabel.text = model.singerStr;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activities_bg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_player pause];
    _player=nil;
    
    PlayCellModel *model = _playArray[indexPath.row];
   // NSLog(@"url==%@",model.urlStr);
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];

//    NSLog(@"name==%@,singer==%@,img==%@",model.nameStr,model.singerStr,model.imgStr);
    MusicPlayViewController *vc = [MusicPlayViewController shareManager];
    [vc createPlayerWithUrlStr:urlString];
    [vc.dataArray addObject:model];
    [vc.imgView setImageWithURL:[NSURL URLWithString:model.imgStr]];
    
    [vc fresh];
    vc.title = model.nameStr;
    
    [self rightPush];
    static dispatch_once_t kaka;
    dispatch_once(&kaka, ^{
    vc.string = @"暂停";    
    });
    
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
