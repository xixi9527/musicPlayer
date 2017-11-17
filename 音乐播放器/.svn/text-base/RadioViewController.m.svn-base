//
//  RadioViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/23.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "RadioViewController.h"

#import "RadioModel.h"
#import "RadioCell.h"
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"
#import "PlayerViewController.h"
#import "DBManager.h"
#import "FMDatabase.h"

@interface RadioViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_modelArray;
    BOOL _popIsHide;
    UIView *_popView;
    UILabel *_typeLabel;
    NSArray *_typeArray;
    PlayerViewController *_player;
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [PlayerViewController sharePlayerManager];
    _dataArray = [[NSMutableArray alloc] init];
    _modelArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    [_collectionView registerNib:[UINib nibWithNibName:@"RadioCell" bundle:nil] forCellWithReuseIdentifier:@"RadioCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:@"netless" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_count++ == 0) {
        [self createTopView];
        [self createPopView];
    }
}

- (void)createPopView
{
    _popView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 70)];
    _popView.backgroundColor = [UIColor blackColor];
    _popView.hidden = YES;
    
    _typeArray = @[@"推荐",@"热门",@"风格",@"情感"];
    
    for (NSInteger i = 0; i < _typeArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (self.view.frame.size.width - 40) / 3;
        button.frame = CGRectMake( ( i % 3) * (10+width), 10+30 * (i / 3), width, 25);
        //button.backgroundColor = [UIColor whiteColor];
        [button setTitle:_typeArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = 400 + i;
        [button setBackgroundImage:[UIImage imageNamed:@"btn_bg_login_normal"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_popView addSubview:button];
        if (i==0) {
            button.backgroundColor = [UIColor grayColor];
        }

        
    }
    
    
    [self.view addSubview:_popView];
}

- (void)createTopView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"public_nav_leftDrawer"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(self.view.frame.size.width - 50, 5, 40, 30);
    
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 150, 20)];
    
    _typeLabel.text = @"推荐 (分类)";
    _typeLabel.font = [UIFont systemFontOfSize:15];
    _typeLabel.textColor = [UIColor whiteColor];
    [view addSubview:_typeLabel];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

- (void)getDataFromDB
{
    
    [_dataArray removeAllObjects];
    [_modelArray removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from radioDB"];


    while ([set next]) {
        
        RadioModel *model = [[RadioModel alloc] init];
        model.typeName = [set stringForColumn:@"name"];
        [_modelArray addObject:model];
    }

    
    [_collectionView reloadData];
    
}


- (void)getData
{
    [[HttpRequestManager shareManager] getRadioDataWithSuccessBlock:^(id responseObj) {
        
        
        [[DBManager shareManager].dataBase executeUpdate:@"delete from radioDB"];
        
        
        
        [_modelArray removeAllObjects];
        [_dataArray addObjectsFromArray:responseObj[@"groups"]];
        
        

 
            
          NSArray *array = _dataArray[0][@"radios"];
        for (NSInteger i = 0; i < array.count; i++) {
            RadioModel *model = [[RadioModel alloc] init];
            model.imgUrlStr = array[i][@"img"];
            model.typeName = array[i][@"title"];
            model.urlStr = array[i][@"url"];
            //NSLog(@"model.urlStr==%@",model.urlStr);
            

            [[DBManager shareManager].dataBase executeUpdate:@"insert into radioDB (name) values(?)",model.typeName];

            [_modelArray addObject:model];
        }
        [_collectionView reloadData];
       // NSLog(@"_modelArray==%@",_modelArray);
    } andFailureBlock:^(NSError *error) {
        NSLog(@"error==%@",error);
    }];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        return head;
    }
    return nil;
}

- (void)btnClick:(UIButton *)button
{
    
    if (_dataArray.count > 0) {
   
    _popView.hidden = _popIsHide;
    _popIsHide = !_popIsHide;
    
    
    for (NSInteger i = 0; i < 4; i++) {
        
        UIButton *button1 = [self.view viewWithTag:400 + i];
        if (button1.tag != button.tag && button.tag > 200)
        button1.backgroundColor = [UIColor blackColor];
    }
    if (button.tag > 200)  {
        button.backgroundColor = [UIColor grayColor];
        
        NSArray *array = _dataArray[button.tag-400][@"radios"];
        [_modelArray removeAllObjects];
        for (NSInteger i = 0; i < array.count; i++) {
            RadioModel *model = [[RadioModel alloc] init];
            model.imgUrlStr = array[i][@"img"];
            model.typeName = array[i][@"title"];
            model.urlStr = array[i][@"url"];
            [_modelArray addObject:model];
        }


        //NSLog(@"_modelArray==%@",_modelArray);
        [_collectionView reloadData];
        _typeLabel.text = [NSString stringWithFormat:@"%@ (分类)",_typeArray[button.tag-400]];
        
    }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 30);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RadioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RadioCell" forIndexPath:indexPath];
    RadioModel *model = _modelArray[indexPath.item];
    
#warning 从这里改起,加底图;
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrlStr]];
    cell.typeLabel.text = model.typeName;

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [[UIScreen   mainScreen] bounds].size.width;
    
    return CGSizeMake((width-30)/2, 170);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RadioModel *model = _modelArray[indexPath.row];
    
    //数据请求没有优化,, 得到详细的数据都可以用这个
    [[HttpRequestManager shareManager] getRankModelDataWithSuccessBlock:^(id responseObj) {
        
        //NSLog(@"%@",responseObj);
        PlayerModel *model2 = [[PlayerModel alloc] init];
        
        
        
        model2.imgStr =  model.imgUrlStr;
        
        
        NSArray *array = responseObj[@"songs"];
        
        NSLog(@"%ld",array.count);
        
        NSMutableArray *mutArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            PlayCellModel *cellModel = [[PlayCellModel alloc] init];
            cellModel.nameStr = array[i][@"title"];
            cellModel.singerStr = array[i][@"singer"];
            cellModel.urlStr = array[i][@"url"];
            cellModel.imgStr = array[i][@"albumImg"];
            cellModel.contentidStr = array[i][@"contentid"];
           // NSLog(@"cellModel.contentidStr,==%@",cellModel.contentidStr);
            [mutArray addObject:cellModel];
        }
        model2.playModel = mutArray;
        
        
        // NSLog(@" model.nameStr==%@",model.nameStr);
        
        // NSLog(@"mutArray==%@",mutArray);
        
        [_player freshWithModel:model2 andBig:YES];
        
        
        
    } withURLStr:model.urlStr];

    _player.title = model.typeName;
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
