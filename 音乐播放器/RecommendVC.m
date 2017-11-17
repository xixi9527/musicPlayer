//
//  RecommendVC.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/22.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "RecommendVC.h"
#import "RecommendCell.h"
#import "HttpRequestManager.h"
#import "RecommendModel.h"
#import "UIImageView+AFNetworking.h"
#import "PlayerViewController.h"
#import "PlayerModel.h"
#import "PlayCellModel.h"
#import "DBManager.h"



@interface RecommendVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
     PlayerViewController *_player;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RecommendVC



- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [PlayerViewController sharePlayerManager];
    _dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellWithReuseIdentifier:@"RecommendCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    
    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
    [self getData];
    
    
}



- (void)getDataFromDB
{
    [_dataArray removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from recommendDB"];
    
    while ([set next]) {
        RecommendModel *model = [[RecommendModel alloc] init];
        model.nameStr = [set stringForColumn:@"name"];
        model.contentStr = [set stringForColumn:@"singer"];
        [_dataArray addObject:model];
       // NSLog(@"model.nameStr==%@",model.nameStr);
    }

    [_collectionView reloadData];
    
    /*
     for (NSInteger i = 0; i < array.count; i++) {
     RecommendModel *model = [[RecommendModel alloc] init];
     model.imgUrlStr = array[i][@"img"];
     model.nameStr = array[i][@"title"];
     model.contentStr = array[i][@"summary"];
     //进入里面的界面
     model.intoUrlStr = array[i][@"url"];
     
     [_dataArray addObject:model];
     // NSLog(@"-------------model.imgUrlStr==%@",model.imgUrlStr);
     }
     [_collectionView reloadData];
     */

    
 //FMResultSet *rs = [manager.dataBase executeQuery:@"slect*from goods"]
}


- (void)getData
{
    
    
    [[HttpRequestManager shareManager] getRecommendModelWithSuccessBlock:^(id responseObj) {
        
        [[DBManager shareManager].dataBase executeUpdate:@"delete from recommendDB"];
        
        
        
        NSArray *array = responseObj;
        for (NSInteger i = 0; i < array.count; i++) {
            RecommendModel *model = [[RecommendModel alloc] init];
            model.imgUrlStr = array[i][@"img"];
            model.nameStr = array[i][@"title"];
            model.contentStr = array[i][@"summary"];
            //进入里面的界面
            model.intoUrlStr = array[i][@"url"];
            
            [_dataArray addObject:model];
           // NSLog(@"-------------model.imgUrlStr==%@",model.imgUrlStr);
            
            if (![[DBManager shareManager].dataBase executeUpdate:@"insert into recommendDB(name,singer) values(?,?)",model.nameStr,model.contentStr]) {
                NSLog(@"插入数据失败");
            }  
        }
        [_collectionView reloadData];
        
    } andFailureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCell" forIndexPath:indexPath];
    RecommendModel *model = _dataArray[indexPath.item];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr]];
    cell.nameLabel.text = model.nameStr;
    cell.contentLabel.text = model.contentStr;
    //NSLog(@"model.imgUrlStr==%@",model.imgUrlStr);
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [[UIScreen   mainScreen] bounds].size.width;
    
    return CGSizeMake((width-30)/2, (width-30)/2+50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断是head ,还是foot
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //这里是头部
        UICollectionReusableView *head =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        head.backgroundColor = [UIColor blackColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        label.backgroundColor = [UIColor grayColor];
        label.text = @"每日推荐";
        label.textColor = [UIColor whiteColor];
        [head addSubview:label];
        
        return head;
    }
    
    return nil;
}

//段头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

   
    RecommendModel *model = _dataArray[indexPath.item];
    
    [[HttpRequestManager shareManager] getRecommendIntoDataWithUrlStr:model.intoUrlStr andSuccessBlock:^(id responseObj) {
        NSDictionary *dic = responseObj;
       // NSLog(@"%@==responseObj",responseObj);
        PlayerModel *model = [[PlayerModel alloc] init];
        
        model.imgStr =  dic[@"img"];
        model.timeStr = dic[@"publishTime"];
        model.headImgStr = dic[@"owner"][@"icon"];
        model.nameStr = dic[@"owner"][@"nickname"];

        
        NSArray *array = dic[@"songs"];
        
        //NSLog(@"%ld",array.count);
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        //NSLog(@"%@",array);
        for (NSInteger i = 0; i < array.count; i++) {
            PlayCellModel *cellModel = [[PlayCellModel alloc] init];
            cellModel.nameStr = array[i][@"title"];
            cellModel.singerStr = array[i][@"singer"];
            cellModel.urlStr = array[i][@"url"];
            cellModel.imgStr = array[i][@"albumImg"];
            cellModel.contentidStr = array[i][@"contentid"];
            [mutArray addObject:cellModel];
        }
        model.playModel = mutArray;
        
        
       // NSLog(@" model.nameStr==%@",model.nameStr);
        
       // NSLog(@"mutArray==%@",mutArray);
        
        [_player freshWithModel:model andBig:NO];
    }];
    
    _player.title = model.nameStr;
    [self.navigationController pushViewController:_player animated:YES];
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
