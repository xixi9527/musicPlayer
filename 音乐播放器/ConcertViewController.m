//
//  ConcertViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/26.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "ConcertViewController.h"


@interface ConcertViewController ()
{
    NSMutableArray *_dataArray;
    UIWebView *_webView;
}
@end

@implementation ConcertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://218.200.160.29/rdp2/v5.4/template/concert/index.do?groupcode=365905/10648733&ua=Iphone_Sst&version=4.243%20"]];
    
    
    [_webView loadRequest:requset];
    [self.view addSubview:_webView];
    
    
    
    
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
