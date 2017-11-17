//
//  NewMusicViewConreol.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/23.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "NewMusicViewConreol.h"
#import "NewModel.h"
#import "NewCell.h"
#import "HttpRequestManager.h"
#import "UIImageView+AFNetworking.h"
#import "PlayerViewController.h"
#import "FMDatabase.h"
#import "DBManager.h"

@interface NewMusicViewConreol ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArry;
    PlayerViewController *_player;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation NewMusicViewConreol

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [PlayerViewController sharePlayerManager];
    _dataArry = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    //两个注册
    [_collectionView registerNib:[UINib nibWithNibName:@"NewCell" bundle:nil] forCellWithReuseIdentifier:@"NewCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    
    [self getData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
}

- (void)getDataFromDB
{


    [_dataArry removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from newDB"];
    
    while ([set next]) {
        NewModel *model = [[NewModel alloc] init];
        model.nameStr = [set stringForColumn:@"name"];
        model.singerStr = [set stringForColumn:@"singer"];
        [_dataArry addObject:model];
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
    
    
    
    [_dataArry removeAllObjects];
    [[HttpRequestManager shareManager] getNewDataWithSuccessBlock:^(id responseObj) {
        NSArray *array = responseObj;
        [[DBManager shareManager].dataBase executeUpdate:@"delete from newDB"];
        for (NSInteger i = 0; i < array.count; i++) {
            NewModel *model = [[NewModel alloc] init];
            model.imgUrlStr = array[i][@"img"];
            model.nameStr = array[i][@"title"];
            if (i==0)
                model.singerStr = array[i][@"summary"];
            else
                model.singerStr = array[i][@"singer"];
            
            
            [[DBManager shareManager].dataBase executeUpdate:@"insert into newDB (name,singer) values(?,?)",model.nameStr,model.singerStr];
            
            
            [_dataArry addObject:model];
        }
        [_collectionView reloadData];
        
    } andFailureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewCell" forIndexPath:indexPath];
    NewModel *model = _dataArry[indexPath.item];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr]];
    cell.nameLabel.text = model.nameStr;
    cell.singerLabel.text = model.singerStr;
    
    
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.frame.size.width-30)/2;
    return CGSizeMake(width, 250);
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
        label.text = @"新碟上架";
        label.textColor = [UIColor whiteColor];
        [head addSubview:label];
        
        return head;
    }
    
    return nil;
}

//段头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 35);
}



//选中cell触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[HttpRequestManager shareManager] getNew1DataWithSuccessBlock:^(id responseObj) {
        
       // NSLog(@"responseObj==%@",responseObj);
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
        for (NSInteger i = 0; i < array.count; i++) {
            PlayCellModel *cellModel = [[PlayCellModel alloc] init];
            cellModel.nameStr = array[i][@"title"];
            cellModel.singerStr = array[i][@"singer"];
            cellModel.urlStr = array[i][@"url"];
            cellModel.imgStr = array[i][@"albumImg"];
            cellModel.contentidStr = array[i][@"contentid"];
           // NSLog(@"cellModel.imgStr==%@",cellModel.imgStr);
            [mutArray addObject:cellModel];
        }
        model.playModel = mutArray;
        
        // NSLog(@" model.nameStr==%@",model.nameStr);
        
        // NSLog(@"mutArray==%@",mutArray);
        
        [_player freshWithModel:model andBig:YES];
        
        
        
    } andFailureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
    }];
    
    NewModel *model = _dataArry[indexPath.row];
    _player.title = model.nameStr;
    [self.navigationController pushViewController:_player animated:YES];
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
