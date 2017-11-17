//
//  HomePageVC.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/6.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UIButton *loadDown;
@property (weak, nonatomic) IBOutlet UIButton *find;

@property (weak, nonatomic) IBOutlet UIButton *onLine;
@property (weak, nonatomic) IBOutlet UIButton *mys;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *mys1;

@property (nonatomic,weak) UINavigationController *nav;

@end
