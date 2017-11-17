//
//  MusicVediViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/22.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "MusicVediViewController.h"
#import "MVCell.h"
#import "MusicVedioModel.h"
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"


@interface MusicVediViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MusicVediViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MVCell" bundle:nil] forCellWithReuseIdentifier:@"MVCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    label.backgroundColor = [UIColor grayColor];
    label.text = @"MV推荐(展示)";
    label.textColor = [UIColor whiteColor];
    [_collectionView addSubview:label];
    
    [self getData];
    
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断是head ,还是foot
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        //这里是头部
        UICollectionReusableView *head =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
//        head.backgroundColor = [UIColor blackColor];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//        label.backgroundColor = [UIColor grayColor];
//        label.text = @"每日推荐";
//        label.textColor = [UIColor whiteColor];
//        [head addSubview:label];
        
        return head;
    }
    
    return nil;
}

//段头
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 30);
}


- (void)getData
{
    [[HttpRequestManager shareManager] getMVDataWithSuccessBlock:^(id responseObj) {
        
        NSArray *array = responseObj;
        for (NSInteger i = 0; i < array.count; i++) {
            MusicVedioModel *model = [[MusicVedioModel alloc] init];
            model.imgUrl = array[i][@"img"];
            
            [_dataArray addObject:model];
        }
        [_collectionView reloadData];
        
    } andFailureBlock:^(NSError *error) {
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MVCell" forIndexPath:indexPath];
    
    MusicVedioModel *model = _dataArray[indexPath.item];
    [cell.imgView setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.frame.size.width-30)/2;
    return CGSizeMake(width, 130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
