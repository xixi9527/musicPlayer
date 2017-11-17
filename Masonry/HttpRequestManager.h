//
//  HttpRequestManager.h
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/17.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//


//http://a.vip.migu.cn/rdp2/v5.5/index.do?ua=Iphone_Sst&version=4.243&pageno=1

// 接参&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1 
//
//
////排行榜   http://218.200.160.29/rdp2/v5.5/rankinfo.do?groupcode=365905/365918/469202/469231&pageno=1&ua=Iphone_Sst&version=4.243


//演唱会
//http://218.200.160.29/rdp2/v5.4/template/concert/index.do?groupcode=365905/10648733&ua=Iphone_Sst&version=4.243%20HTTP/1.1


//http://218.200.160.29/rdp2/v5.5/related_songs.do?groupcode\u003d365905/365911/365942/430570"
//
//
//ua=Iphone_Sst&version=4.243&pageno=1

//电台
//http://a.vip.migu.cn/rdp2/v5.5/radiolist.do?ua=IOS_sst&version=4.2&pageno=1&pageno=1

//http://218.200.160.29/rdp2/v5.5/musicListInfo.do?groupcode=365905/365925&id=55302&ua=Iphone_Sst&version=4.243&pageno=1


#import <Foundation/Foundation.h>

typedef void(^successBlock)(id responseObj);
typedef void(^failureBlock)(NSError *error);

#import "AFNetworking.h"
#define URL @"http://a.vip.migu.cn/rdp2/v5.5/index.do?ua=Iphone_Sst&version=4.243&pageno=1"
//&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1 拼接参数  append

#define RANKURL @"http://218.200.160.29/rdp2/v5.5/ranklist.do?groupcode=365905/365956&ua=Iphone_Sst&version=4.243&netType=1&toneFlag=1"

#define RADIOURL @"http://a.vip.migu.cn/rdp2/v5.5/radiolist.do?ua=IOS_sst&version=4.2&pageno=1&pageno=1"


#define NEW1 @"http://a.vip.migu.cn/rdp2/v5.5/rankinfo.do?ua=Iphone_Sst&version=4.243&groupcode=365905/365911/365949/423819&pageno=1"
//http://a.vip.migu.cn/rdp2/v5.5/rankinfo.do?ua=Iphone_Sst&version=4.243&groupcode=365905/365911/365949/423819&pageno=1

#define WOMEN @"http://218.200.160.29/rdp2/v5.5/musicListInfo.do?groupcode=365905/365925&id=55302&ua=Iphone_Sst&version=4.243&pageno=1"


@interface HttpRequestManager : NSObject

+ (instancetype)shareManager;
@property (nonatomic,copy)NSString *append;


- (void)getBannersInfoWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

//
- (void)getBannersPlayerInfoWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

//每日推荐数据
- (void)getRecommendModelWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

//每日推荐跳入数据

- (void)getRecommendIntoDataWithUrlStr:(NSString *)urlStr andSuccessBlock:(successBlock)success;

//热门歌曲数据
- (void)getHotDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;




//MV推荐数据
- (void)getMVDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

//新碟上架数据
- (void)getNewDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

- (void)getNew1DataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;


//排行榜数据
- (void)getRankDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

- (void)getRankModelDataWithSuccessBlock:(successBlock)success withURLStr:(NSString *)urlStr;


//电台数据
- (void)getRadioDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;


- (void)getWomenDataWithSuccessBlock:(successBlock)success andFailureBlock:(failureBlock)failure;

- (void)getheheDataWithSuccessBlock:(successBlock)success withIndex:(NSInteger)index;


@end
