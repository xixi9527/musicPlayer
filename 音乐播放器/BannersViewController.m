//
//  BannersViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/17.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "BannersViewController.h"

#import "HttpRequestManager.h"
#import "UIImageView+AFNetworking.h"

@interface BannersViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_dataArray;
    NSTimer *_myTimer;
    NSMutableArray *_playerData;
    UIWebView *_webView;
}
@end

@implementation BannersViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        _playerData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createScroll];
    [self createData];
    
    
    [self createTimer];
    
}





- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >self.view.frame.size.width*_dataArray.count) {
        scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    } else if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(self.view.frame.size.width*_dataArray.count, 0);
    }
}

- (void)createData
{
    [[HttpRequestManager shareManager] getBannersInfoWithSuccessBlock:^(id responseObj) {
       // NSLog(@"responseObj==%@",responseObj);
        for (NSArray *array in responseObj) {
            [_dataArray addObject:array];
        }
        
        //NSLog(@"_dataArray==%@",_dataArray);
        
        
        
        [self hehe];//创建滑动的图片
        
        
        
        [[HttpRequestManager shareManager] getBannersPlayerInfoWithSuccessBlock:^(id responseObj) {
            [_playerData addObjectsFromArray:responseObj];
            
            //NSLog(@"responseObj==%@",responseObj);
        } andFailureBlock:^(NSError *error) {
            NSLog(@"error==%@",error);
        }];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"接收数据失败error==%@",error);
    }];
    
    
}

- (void)hehe
{
    for (int i = 0; i < _dataArray.count; i++) {
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        //
        //NSLog(@"imgURL==%@",_dataArray[i][@"img"]);
        
        [imageView setImageWithURL:[NSURL URLWithString:_dataArray[i][@"img"]]];
        
        imageView.userInteractionEnabled = YES;

        
        imageView.tag = 300 + i;

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgr:)];
        [imageView addGestureRecognizer:tap];
        
        
        // UILongPressGestureRecognizer *lon = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longgr)];
        //[imageView addGestureRecognizer:lon];
        [_scrollView addSubview:imageView];
        
    }
    _scrollView.pagingEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSInteger i = _dataArray.count;
    
    
    [imageView setImageWithURL:[NSURL URLWithString:_dataArray[i-1][@"img"]]];
    [_scrollView addSubview:imageView];
    
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [imageView2 setImageWithURL:[NSURL URLWithString:_dataArray[0][@"img"]]];
    [_scrollView addSubview:imageView2];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * (_dataArray.count+2), 0);
    
    
    
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        [self performSelectorOnMainThread:@selector(createTimer) withObject:nil waitUntilDone:NO];
    }
}
- (void) createTimer
{
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
    NSRunLoop *currenLoop = [NSRunLoop currentRunLoop];
    [currenLoop addTimer:_myTimer forMode:NSRunLoopCommonModes];
}
- (void)timerAction
{
    CGFloat size = _scrollView.contentOffset.x;
    [_scrollView setContentOffset:CGPointMake(size + self.view.frame.size.width, 0) animated:YES];
}

- (void)tapgr:(UITapGestureRecognizer *)tap
{

    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        [self performSelectorOnMainThread:@selector(createTimer) withObject:nil waitUntilDone:NO];
    }
    

    

   
    //先不写跳转
//    if (_webView == nil)
//    _webView = [[UIWebView alloc] init];
//
//    
//    [_webView stopLoading];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: _playerData[i]]];
//    //NSLog(@"_playerData==%@",_playerData[i]);
//    _webView.frame = self.view.frame;
//    [_webView loadRequest:request];
//
//    [self.view addSubview:_webView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!_webView)
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



- (void)longgr
{
    
   

}



- (void)createScroll
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >self.view.frame.size.width*_dataArray.count) {
        scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    } else if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(self.view.frame.size.width*_dataArray.count, 0);
    }
    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        [self performSelectorOnMainThread:@selector(createTimer) withObject:nil waitUntilDone:NO];
    }
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
