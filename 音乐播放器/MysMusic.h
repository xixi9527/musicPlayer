//
//  MysMusic.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/7.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAudioPlayer;

@interface MysMusic : UIViewController

- (void)addPlayerWithUrlString:(NSString *)string
;
- (void)creatMP3Play:(NSString *)fileName;
@property (nonatomic,strong) NSMutableArray *MP3DataArr;

@property (nonatomic,strong) AVAudioPlayer *player;


@property (weak, nonatomic) IBOutlet UIButton *playButton;


@property (nonatomic,copy)NSString *geci;

@end
