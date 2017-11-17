//
//  ListViewController.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/21.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reloadCell:(NSArray *)dataArray;

@property (nonatomic,assign) void(^block)(NSInteger index);


@end
