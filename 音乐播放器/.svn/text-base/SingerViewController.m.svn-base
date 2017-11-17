//
//  SingerViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/29.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#define APPEND @"ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1"

#import "SingerViewController.h"
#import "PlayCellModel.h"
#import "CustomViewController.h"
#import "HttpRequestManager.h"
#import "PlayerModel.h"

@interface SingerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSArray *_typeArray;
    NSArray *_nameArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _typeArray = @[@"华语男歌手",@"华语女歌手",@"华语组合",@"欧美男歌手",@"欧美女歌手",@"欧美组合"];
    _nameArray = @[@"周杰伦",@"阿兰",@"五月天",@"Ornette Coleman",@"Lindsey Stirling",@"Pantera"];
    
    [self getData];
    
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)getData
{
    for (NSInteger i = 0; i < 6; i++) {
        
        [[HttpRequestManager shareManager] getheheDataWithSuccessBlock:^(id responseObj) {
            NSDictionary *dic = responseObj;
            // NSLog(@"%@==responseObj",responseObj);
            PlayerModel *model = [[PlayerModel alloc] init];
            
            
            
            model.imgStr =  dic[@"img"];
            model.timeStr = dic[@"publishTime"];
            model.headImgStr = dic[@"owner"][@"icon"];
            model.nameStr = dic[@"singer"];

            NSArray *array = dic[@"songs"];
            
            //NSLog(@"%ld",array.count);
            
            NSMutableArray *mutArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < array.count; i++) {
                PlayCellModel *cellModel = [[PlayCellModel alloc] init];
                cellModel.nameStr = array[i][@"title"];
                cellModel.singerStr = array[i][@"singer"];
                cellModel.urlStr = array[i][@"url"];
                cellModel.imgStr = array[i][@"albumImg"];
                // NSLog(@"cellModel.imgStr==%@",cellModel.imgStr);
                
                [mutArray addObject:cellModel];
            }
            model.playModel = mutArray;
            
            // NSLog(@" model.nameStr==%@",model.nameStr);
            
            // NSLog(@"mutArray==%@",mutArray);
           // NSLog(@"%@",model.nameStr);
            [_dataArray addObject:model];

            
            
        } withIndex:i];
    }
    
}


#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cells"];
    }
    cell.textLabel.text = _typeArray[indexPath.row+indexPath.section*3];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activities_bg"]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0) {
    CustomViewController *vc = [[CustomViewController alloc] initWithNibName:@"CustomViewController" bundle:nil];
    
    vc.playerModel = _dataArray[indexPath.row+indexPath.section*3];
    vc.name = _nameArray[indexPath.row+indexPath.section*3];
    
    [self.navigationController pushViewController:vc animated:YES];
    } else {
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
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
