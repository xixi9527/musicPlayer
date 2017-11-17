//
//  OnLineVC.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/6.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "OnLineVC.h"

#import "RESideMenu.h"

#import "Masonry.h"

#import "SearchViewController.h"

#import "BannersViewController.h"

#import "ContentViewController.h"
#import "RankViewController.h"
#import "MusicPlayViewController.h"

#define URL @"http://a.vip.migu.cn/rdp2/v5.5/index.do?ua=Iphone_Sst&version=4.243&pageno=1"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ConcertViewController.h"
#import "RadioViewController.h"
#import "PlayerViewController.h"
#import "SingerViewController.h"



@interface OnLineVC ()<UIScrollViewDelegate>
{
    SearchViewController *_searchVC;
    NSArray *_dataArray;
    UIScrollView *_TJScrollView;
    UITableView *_rankTable;
    RankViewController *_rankVC;
    ConcertViewController *_concertVC;//不用了.
    SingerViewController *_singerVC;
    ContentViewController *_contentVC;// 推荐总控制
    UILabel *_titleLabel;
    
    RadioViewController *_radioVC;
    PlayerViewController *_player;

    
}


@property (nonatomic,strong) UIScrollView *myScroll;

@property (nonatomic,strong) UIScrollView *myScroll2;//下面的大的滑块 //添加推荐排行榜之类的视图直接放上去
//底图对应的tag 200+i

@property(nonatomic,assign) NSInteger count;

@property (nonatomic,strong) UIPageControl *myPage;

@property (nonatomic,strong) NSArray *pageArray;

@end

@implementation OnLineVC

////单例
//- (instancetype)init
//{
//    static OnLineVC * vc = nil;
//    static dispatch_once_t oncehehe;
//    dispatch_once(&oncehehe, ^{
//        vc = [super init];
//        NSLog(@"1234");
//    });
//    
//  
//    return vc;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    //_myPage.userInteractionEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    [self createUI]; //
    [self createRecommend];
    [self createRank];
    
    [self createConcert];
    [self createRadio];
    
    
    
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netless" object:nil];
        
    }];
    
    
    
}



//推荐
- (void)createRecommend
{
    _contentVC = [[ContentViewController alloc] init];
    _contentVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, _myScroll2.frame.size.height-50);
    [_myScroll2 addSubview:_contentVC.view];

    [self addChildViewController:_contentVC];
}

//排行
- (void)createRank
{
    
    _rankVC = [[RankViewController alloc] initWithNibName:@"RankViewController" bundle:nil];
    
    
    
    _rankVC.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, _myScroll2.frame.size.height-50);
    
    [self addChildViewController: _rankVC];
    [_myScroll2 addSubview:_rankVC.view];
}

//演唱会 (变成歌手了)
- (void)createConcert
{
    _singerVC = [[SingerViewController alloc] initWithNibName:@"SingerViewController" bundle:nil];

    _singerVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
                            [self addChildViewController:_singerVC];
    [_myScroll2 addSubview:_singerVC.view];

}

- (void)createRadio
{
    _radioVC = [[RadioViewController alloc] initWithNibName:@"RadioViewController" bundle:nil];
    _radioVC.view.frame = CGRectMake(self.view.frame.size.width * 3, 0, self.view.frame.size.width, _myScroll2.frame.size.height-50);
    

    [self addChildViewController:_radioVC];
    [_myScroll2 addSubview:_radioVC.view];
}



//跳回左菜单
- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}



//数据处理
- (void)getData
{
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    //[self removeFromParentViewController];
}




- (void)rightPush
{
    MusicPlayViewController *vc = [MusicPlayViewController shareManager];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)createUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _titleLabel.text = @"推荐";
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = _titleLabel;
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setImage:[UIImage imageNamed:@"img_player_entrance_disk"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightPush) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = item;
    
    
    
    _myScroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    
    _myScroll2.contentSize = CGSizeMake(self.view.bounds.size.width * 4, 0 );
    _myScroll2.pagingEnabled = YES;
    
    [self.view addSubview:_myScroll2];
    
    
    //scroll 上的底图
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        if (i==2) {
            UIImageView *imageView= [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            imageView.image = [UIImage imageNamed:@"20140628141000_dMYvZ.jpeg"];
            [view addSubview:imageView];
            imageView.userInteractionEnabled = YES;
        }
                        
        view.tag = 200+i;
        [_myScroll2 addSubview:view];
    }
    
    _myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];
    //_myScroll.backgroundColor = [UIColor blackColor];
    _myScroll.contentSize = CGSizeMake(self.view.bounds.size.width * 1.5, 0);
    _myScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_myScroll];
    _myScroll.backgroundColor = [UIColor blackColor];
    _myScroll2.delegate = self;
    _myScroll2.showsHorizontalScrollIndicator = NO;
    
    _pageArray = @[@"推荐歌单",@"排行榜",@"热门歌手",@"电台"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(1.5*self.view.bounds.size.width / 4 * i, 0, 80, 30);
        
        [button setTitle:_pageArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        [_myScroll addSubview:button];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
    }
    
    _myPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 20, self.view.bounds.size.width, 20)];
    _myPage.numberOfPages = 4;

    [_myPage addTarget:self action:@selector(pageBtn) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_myPage];

    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"188"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
   // UIView *view = [_myScroll2 viewWithTag:999];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 600, self.view.frame.size.width, self.view.frame.size.height)];
    [_TJScrollView addSubview:view];
    
    //_TJScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height * 2);
    //view.userInteractionEnabled = YES;
   // [view addSubview:_TJScrollView];
   // [_TJScrollView addSubview:banners.view];
    
    
   
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _myPage.currentPage = (NSInteger)(scrollView.contentOffset.x / self.view.bounds.size.width);
    [self pageBtn];
    

    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_myScroll2.contentOffset.x < 0) {
        [self.sideMenuViewController presentLeftMenuViewController];
        
    }
    
}


- (void)btnClick:(UIButton *)button
{
    self.myPage.currentPage = button.tag - 100;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.myScroll setContentOffset:CGPointMake(60 * (button.tag - 100) , 0) animated:YES];
    
    
    for (NSInteger i = 0; i < self.pageArray.count; i++) {
        button = [self.view viewWithTag:i + 100];

        if (i != self.myPage.currentPage) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
    }
    
    [_myScroll2 setContentOffset:CGPointMake(self.view.frame.size.width * _myPage.currentPage, 0) animated:YES];
    _myScroll2.bounces = YES;
    
    
}


- (void)pageBtn
{
    UIButton *button = [self.view viewWithTag:self.myPage.currentPage + 100];
    [self btnClick:button];
    
    [_myScroll2 setContentOffset:CGPointMake(self.view.frame.size.width * _myPage.currentPage, 0) animated:YES];
    
    _titleLabel.text = _pageArray[_myPage.currentPage];
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
