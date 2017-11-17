//
//  DBManager.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/26.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "DBManager.h"


@implementation DBManager

+ (instancetype)shareManager
{
    static DBManager *manager = nil;
    static dispatch_once_t onceManager;
    dispatch_once(&onceManager, ^{
        manager = [[DBManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/musicList.db"];
        NSLog(@"DBpath==%@",path);
        
        self.dataBase = [FMDatabase databaseWithPath:path];
        if (![self.dataBase open]) {
            
            NSLog(@"数据库打开失败");
        }
        
        
        if (![self.dataBase executeUpdate:@"create table if not exists music (id integer primary key autoincrement,name text,singer text,contentid text)"]) {
         //   NSLog(@"创建失败");
        }
        
        if (![self.dataBase executeUpdate:@"create table if not exists recommendDB (id integer primary key autoincrement,name text,singer text)"])
        {
            NSLog(@"创建失败");
        }
        
        if (![self.dataBase executeUpdate:@"create table if not exists hotDB (id integer primary key autoincrement,name text,singer text)"])
        {
            NSLog(@"创建失败");
        }
        if (![self.dataBase executeUpdate:@"create table if not exists newDB (id integer primary key autoincrement,name text,singer text)"])
        {
            NSLog(@"创建失败");
        }
        if (![self.dataBase executeUpdate:@"create table if not exists englishDB (id integer primary key autoincrement,name text,singer text)"])
        {
            NSLog(@"创建失败");
        }
        if (![self.dataBase executeUpdate:@"create table if not exists rankDB(id integer primary key autoincrement,name text,one text,tow text,three text)"]){
            NSLog(@"创建失败");
        }
        if (![self.dataBase executeUpdate:@"create table if not exists radioDB(id integer primary key autoincrement,name text)"]) {
            NSLog(@"创建失败");
        }

        
        
    }
    return self;
}

@end
