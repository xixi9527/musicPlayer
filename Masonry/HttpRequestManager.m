//
//  HttpRequestManager.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/17.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "HttpRequestManager.h"

@implementation HttpRequestManager

//单例
+ (instancetype)shareManager
{
    static HttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpRequestManager alloc] init];
        
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _append = @"&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1";
    }
    return self;
}

//展示栏data
- (void)getBannersInfoWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = responseObject[@"groups"][0][@"banners"];
        success(dic);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert];
    }];
}

//点击展示栏得到的音乐
- (void)getBannersPlayerInfoWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    /* 得重新写一个重afnetwork出发的
    [self getBannersInfoWithSuccessBlock:^(id responseObj) {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *data = responseObj;
        for (NSInteger i = 0; i < data.count; i++) {
            NSString *str = data[i][@"url"];
            [dataArray addObject:[str stringByAppendingString:_append]];
           // NSLog(@"dataArray[%ld]%@",i,dataArray[i]);
           
        }
        
        NSMutableArray *dataArray2 = [[NSMutableArray alloc] init];
        
        dispatch_queue_t user =   dispatch_queue_create("user", DISPATCH_QUEUE_SERIAL);
        
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
                 dispatch_async(user, ^{
                if(i < 3) {
                   
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:dataArray[i]]];
                    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    NSString *string = dic[@"songs"][0][@"url"];
                    [dataArray2 addObject:[string stringByAppendingString:_append]];
                
                }
               else
                [dataArray2 addObject:dataArray[i]];
            });
            
        }
        dispatch_async(user, ^{
            //NSLog(@"dataArray2==%@",dataArray2);
            success(dataArray2);
        });
        
        
    } andFailureBlock:^(NSError *error) {
        
    }];
     */
}

//获得每日推荐collectionView
- (void)getRecommendModelWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject[@"groups"][2][@"recommends"]);
        
        success(responseObject[@"groups"][2][@"recommends"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

//每日推荐详细歌单
- (void)getRecommendIntoDataWithUrlStr:(NSString *)urlStr andSuccessBlock:(successBlock)success
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *string = [NSString stringWithFormat:@"%@%@",urlStr,_append];
    //NSLog(@"string==%@",string);
    
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}




//获取热门歌曲数据
- (void)getHotDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"groups"][3][@"songs"];
        success(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
}


//获得MV数据
- (void)getMVDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"groups"][4][@"mvs"];
        success(array);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert];
    }];
}

//新碟上架
- (void)getNewDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager =    [AFHTTPRequestOperationManager manager];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"groups"][5][@"firsts"];
        //NSLog(@"array==%@",array);
        success(array);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

//新碟数据
- (void)getNew1DataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:NEW1 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

//获得rank数据
- (void)getRankDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager =    [AFHTTPRequestOperationManager manager];
    [manager GET:RANKURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"groups"][0][@"ranks"];
        //NSLog(@"array==%@",array);
        success(array);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

}

- (void)getRankModelDataWithSuccessBlock:(successBlock)success withURLStr:(NSString *)urlStr
{
   NSString *string = [ NSString stringWithFormat:@"%@%@",urlStr,_append ];
    AFHTTPRequestOperationManager *manager =    [AFHTTPRequestOperationManager manager];
    [manager GET:string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error==%@",error);

    }];

}

- (void)getRadioDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:RADIOURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"responseObject==%@",responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);

    }];
}


- (void)getWomenDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:WOMEN parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getheheDataWithSuccessBlock:(successBlock)success withIndex:(NSInteger)index
{
    if (index == 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=112&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
    } else if (index == 1) {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=6587&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
        
        
    } else if (index == 2) {
    
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=529&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
    } else if (index == 3) {
    
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=22670&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
    } else if (index == 4) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=1001192455&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
    } else {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://a.vip.migu.cn/rdp2/v5.5/singer_songs.do?ua=Iphone_Sst&version=4.243&singerid=6692&pageno=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error==%@",error);
        }];
    }
}


- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的网络状态不佳( ⊙ o ⊙ )啊！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
