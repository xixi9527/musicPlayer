//
//  CustomViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/29.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "CustomViewController.h"
#import "PlayerViewController.h"
#import "NewModel.h"

@interface CustomViewController ()
{
     PlayerViewController *_player;
}
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CustomViewController
- (IBAction)pushPlayer:(id)sender {
    
   // NSLog(@"array==%@",_playArray);
    NSLog(@"%@",_playerModel.nameStr);
     [_player freshWithModel:_playerModel andBig:NO];
    
    _player.title = _playerModel.nameStr;
    [self.navigationController pushViewController:_player animated:YES];
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_button setTitle:_name forState:UIControlStateNormal];
    _player = [PlayerViewController sharePlayerManager];
  
    
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
