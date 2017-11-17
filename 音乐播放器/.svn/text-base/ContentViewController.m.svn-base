//
//  ContentViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/17.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//


//推荐总布局
#import "ContentViewController.h"
#import "BannersViewController.h"
#import "RecommendVC.h"
#import "HotViewController.h"
#import "EnglishViewController.h"
#import "NewMusicViewConreol.h"
#import "AFNetworking.h"

//首页推荐的内容
@interface ContentViewController ()
{
    UIScrollView *_scrollView;
    RecommendVC *_recommendVC;
    HotViewController *_hotVC;
    EnglishViewController *_EnglishVC;
    NewMusicViewConreol *_newVC;
}
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    
    
}

- (void)createUI
{

    
    
    
    
    //
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.contentSize = CGSizeMake(0, 2720);
    [self.view addSubview:_scrollView];
    
    //1.添加上端滚动图
    BannersViewController *banners = [[BannersViewController alloc] init];
    banners.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 160);
    [_scrollView addSubview:banners.view];
    [self addChildViewController:banners];
    
    //2.添加一个collectionView 每日推荐 180
    _recommendVC = [[RecommendVC alloc] initWithNibName:@"RecommendVC" bundle:nil];

    _recommendVC.view.frame = CGRectMake(0, 170, self.view.frame.size.width, 515) ;
    [_scrollView addSubview:_recommendVC.view];
    [self addChildViewController:_recommendVC];
    
    
    //3.添加一个tableView 热门歌曲 640
    _hotVC = [[HotViewController alloc] initWithNibName:@"HotViewController" bundle:nil];
    _hotVC.view.frame = CGRectMake(0, 695, self.view.frame.size.width, 900);
    [_scrollView addSubview:_hotVC.view];
    [self addChildViewController:_hotVC];
    
    
    
//    //4.添加collectionView MV推荐 1100
//    _musicVC = [[MusicVediViewController alloc] initWithNibName:@"MusicVediViewController" bundle:nil];
//    _musicVC.view.frame = CGRectMake(0, 1530, self.view.frame.size.width, 370);
//    [_scrollView addSubview:_musicVC.view];
//    [self addChildViewController:_musicVC];
    
    //4.添加最近新碟
    _newVC = [[NewMusicViewConreol alloc ] initWithNibName:@"NewMusicViewConreol" bundle:nil];
    _newVC.view.frame = CGRectMake(0, 1530, self.view.frame.size.width, 580);
    [_scrollView addSubview:_newVC.view];
    [self addChildViewController:_newVC];
    
    
    //5.
    _EnglishVC = [[EnglishViewController alloc] initWithNibName:@"EnglishViewController" bundle:nil];
    _EnglishVC.view.frame = CGRectMake(0, 2120, self.view.frame.size.width, 480);
    [_scrollView addSubview:_EnglishVC.view];
    [self addChildViewController:_EnglishVC];
    
    
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
