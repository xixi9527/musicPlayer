//
//  MusicPlayViewController.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/25.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define APPEND @"&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1"

@interface MusicPlayViewController : UIViewController
@property (nonatomic,strong) UIImageView *imgView;

+ (instancetype)shareManager;

@property (nonatomic,strong) AVPlayer *player;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic,strong) AVPlayerItem *item;

@property (nonatomic,copy)NSString *string;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSTimer *myTimer;

- (void)createPlayerWithUrlStr:(NSString *)URLString;
- (void)fresh;

- (void)patch;

@end
