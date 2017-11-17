//
//  SearchViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/8.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "SearchViewController.h"



@interface SearchViewController ()
{
    UIWebView *_webView;
}
@end

@implementation SearchViewController

+ (instancetype)shareManager
{
    static SearchViewController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SearchViewController alloc] init];

    });

    return manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSearch)];
//    [self.view addGestureRecognizer:tap];
    //self.view.backgroundColor = [UIColor redColor];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    
}

- (void)search
{

   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
