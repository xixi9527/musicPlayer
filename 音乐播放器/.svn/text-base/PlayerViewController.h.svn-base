//
//  PlayerViewController.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/24.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayerModel.h"
#import "PlayCellModel.h"

@interface PlayerViewController : UIViewController


+ (instancetype)sharePlayerManager;

@property (nonatomic,strong)PlayerModel *dataModel;

@property (nonatomic,strong) UITableView *tableView;

- (void)freshWithModel:(PlayerModel *)model andBig:(BOOL)isBig;//重新刷新

- (void)freshWithMusic:(PlayCellModel *)model;//热门 单曲添加

@end
