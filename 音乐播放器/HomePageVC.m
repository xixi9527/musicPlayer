//
//  HomePageVC.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/6.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "HomePageVC.h"
#import "RESideMenu.h"
#import "OnLineVC.h"
#import "MysMusic.h"
#import "DownManagerVC.h"
#import "CustomListViewController.h"
#import "SettingViewController.h"

@interface HomePageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bgimag;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view sendSubviewToBack:self.bgimag];
    [self.onLine addTarget:self action:@selector(turnToOnLine) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)turnToMys:(id)sender {
    MysMusic *myMusic = [[MysMusic alloc] initWithNibName:@"MysMusic" bundle:nil];
    
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:myMusic];
    [self.sideMenuViewController setContentViewController:nvc  animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)turnToOnLine
{

    OnLineVC *vc = [[OnLineVC alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.sideMenuViewController setContentViewController:nvc  animated:YES];
    [self.sideMenuViewController hideMenuViewController];

    
}
- (IBAction)turnToCustomList:(UIButton *)sender {
    
    CustomListViewController *DownVC = [[CustomListViewController alloc] init];
    
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:DownVC
                                   ];
    [self.sideMenuViewController setContentViewController:nvc  animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (IBAction)turnToDownManage:(id)sender {
    DownManagerVC *DownVC = [[DownManagerVC alloc] init];
    
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:DownVC
                                   ];
    [self.sideMenuViewController setContentViewController:nvc  animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}
- (IBAction)turnToSetting:(id)sender {
    
    SettingViewController *DownVC = [[SettingViewController alloc] init];
    
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:DownVC
                                   ];
    [self.sideMenuViewController setContentViewController:nvc  animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
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
