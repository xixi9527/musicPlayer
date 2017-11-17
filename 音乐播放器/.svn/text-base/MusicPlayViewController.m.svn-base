//
//  MusicPlayViewController.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/25.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "MusicPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+AFNetworking.h"
#import "HttpRequestManager.h"
#import "HotCell.h"
#import "PlayCellModel.h"
#import "MusicPlayViewController.h"
#import "FMDatabase.h"
#import "DBManager.h"
#import "FMDatabase.h"
#import "MysMusic.h"


@interface MusicPlayViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    AVPlayer *_player;

    UIView *_scrollView;
    UITableView *_tableView;
    NSInteger _count;
    NSFileManager *_manager;
    NSFileHandle *_fileHandle;
//   __weak UISlider *_weakSlider;
//   __block UISlider *_blockSlder;

}
@property (nonatomic) CMTime time;
@property (nonatomic,strong) NSMutableData *receiveData;//接收的数据;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *current;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UIButton *styleButton;


@end

@implementation MusicPlayViewController

+ (instancetype)shareManager
{
    static MusicPlayViewController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MusicPlayViewController alloc] initWithNibName:@"MusicPlayViewController" bundle:nil];
        //NSLog(@"!!!!!!!!!!!!!!!!");
    });
    return manager;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _dataArray = [[NSMutableArray alloc] init];
        _receiveData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)fresh
{
   // NSLog(@"dataArray==%@",_dataArray);
    [_tableView reloadData];
}

- (void)patch
{
    
    UIButton *button = [self.view viewWithTag:501];
    if (button.selected) {
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
        
    } else {
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;
    
    if ([button.currentTitle isEqualToString:@"播放"]) {
        [_player play];
            } else {
        [_player pause];
    }
}



//按钮
- (IBAction)btnClick:(UIButton *)sender {
    //NSLog(@"tag==%ld",sender.tag);
    UIButton *button = sender;
   // NSLog(@"%@",button.currentTitle);
    
    
    //
    if (self.title != NULL){
    if (button.tag == 501) {
        if ([button.currentTitle isEqualToString:@"播放"]) {
            [button setTitle:@"暂停" forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
            [_player play];

            
        } else if ([button.currentTitle isEqualToString:@"暂停"]){
            [button setTitle:@"播放" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
//                        CMTime time = _item.duration;
//            
//                        NSInteger length = (NSInteger)(time.value / time.timescale);
//                        self.total.text = [NSString stringWithFormat:@"%02d:%02ld",length/60,length%60];
//                        self.slider.maximumValue = length;
            [_player pause];
        }
    }
    //设置播放模式
    if (button.tag == 500 ) {
        
        if ([button.currentTitle isEqualToString:@"单曲循环"]) {
            [button setTitle:@"顺序循环" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"player_mode_sequency"] forState:UIControlStateNormal];
        } else if ([button.currentTitle isEqualToString:@"顺序循环"]) {
            [button setTitle:@"随机循环" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"player_mode_random"]     forState:UIControlStateNormal];
        } else if ([button.currentTitle isEqualToString:@"随机循环"]) {
            [button setTitle:@"单曲循环" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"player_mode_single"] forState:UIControlStateNormal];
        }
        
        
        
    }
    
    //下载操作
    if (button.tag == 503) {
        //下载操作 (fmdb)
        for (PlayCellModel *model in _dataArray) {
            if ([model.nameStr isEqualToString:self.title]) {
                
                NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.mp3",self.title]];
                NSString *name = model.nameStr;
                NSString *singer = model.singerStr;
                
                
                
                NSString *urlpath = [NSString stringWithFormat:@"http://a.vip.migu.cn/rdp2/v5.5/lrcinfo.do%%3Fcontentid=%@&ua=Iphone_Sst&version=4.243",model.contentidStr];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                __block NSString *geci = @"";
                [manager GET:urlpath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    geci = responseObject[@"lrc"];
                    //NSLog(@"responseObject==%@",responseObject);
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error==%@",error);
                }];
                
                
                
               // NSString *contentid = model.contentidStr;
               // NSLog(@"mp3path==%@",path);
                NSFileManager *manager2 = [NSFileManager defaultManager];
                //NSLog(@"mp3url==%@",[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.mp3",self.title]]);
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.urlStr,APPEND]]];
                //文件是否存在
                if ([manager2 fileExistsAtPath:path]) {
                    //断点续传
                    NSLog(@"文件已存在");
                    [self showAlert:@"音乐已存在"];
                } else {
                    //开始下载
                    [self showAlert:@"开始下载"];
                    
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                        [manager2 createFileAtPath:path contents:nil attributes:nil];
                        //发起请求
                        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
                        [_fileHandle writeData:data];
                        if ([[DBManager shareManager].dataBase executeUpdate:@"insert into music(name,singer,contentid) values(?,?,?)",name,singer,geci])
                        {
                            
                        }

                    }];
                }
                break;
            }
        }
        
        
        
    }
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择歌曲" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}


- (void)createPlayerWithUrlStr:(NSString *)URLString
{
    
    if ([_myTimer isValid]) {
        [_myTimer invalidate];
        
    }
   // _weakSlider = nil;
   // NSLog(@"weakSlider==%@",_weakSlider);
    //
//    _time = CMTimeMake(0, 0);
//    //
    MysMusic *mys = [[MysMusic alloc]  initWithNibName:@"MysMusic" bundle:nil];
    [mys.player pause];
    [mys.playButton setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
    [mys.playButton setTitle:@"播放" forState:UIControlStateNormal];
    
    
    
    if (_item != nil) {
        [self.item removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        // [[NSNotificationCenter defaultCenter] removeObserver:self];
        

    }
    
    
    
    _item = nil;
    _player = nil;
    _item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:URLString]];
    //_player = [[AVPlayer alloc] initWithPlayerItem:_item];
    
    
    _player = [AVPlayer playerWithPlayerItem:_item];
    [_player play];
//    
//   static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
   //
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
        [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
 
    

    
   // });


    
   // [_player pause];
    UIButton *button = [self.view viewWithTag:501];
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
 

    

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if([keyPath isEqualToString:@"status"])
    {
        AVPlayerItemStatus s = [change[NSKeyValueChangeNewKey] integerValue];
       // NSLog(@"---------------------------------------");

        
        if(s == AVPlayerItemStatusReadyToPlay)
        {
            
          //  _blockSlder = nil;
            //CMTime  ---->  seconds
            //value    总帧数
            //timeScale  每秒播放的帧数
            self.time = self.player.currentItem.duration;
            _slider.maximumValue = self.time.value / self.time.timescale;
            int i = _slider.maximumValue;
            _total.text = [NSString stringWithFormat:@"%02d:%02d",i /60,i%60];
            
            _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
//            __weak UISlider *slider = self.slider;
//           // _weakSlider = self.slider;
//           // _blockSlder = self.slider;
//            //addPeriodicTimeObserverForInterval  1
//            //time  当前视频播放的时间
//            
////            NSLog(@"1");
//            __weak UILabel *label = self.current;
//           __block int s = 0;
//           
//            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
//                
//               // _blockSlder.value = time.value / time.timescale;
//                slider.value = time.value / time.timescale;
//                int b = slider.value;
//                label.text = [NSString stringWithFormat: @"%02d:%02d",b/60,b%60];
//
//                
//                NSLog(@"滑轮滑动%d---and%@",s++,[NSThread currentThread]);
//            }];
        }
        
        
        
    }
}


//定时器自动调用的方法
- (void)moviePlay
{
    self.slider.value = _item.currentTime.value / _item.currentTime.timescale;
    NSInteger length = _item.currentTime.value / _item.currentTime.timescale;
    self.current.text = [NSString stringWithFormat:@"%02ld:%02ld",length/60,length%60];
    
}

//- (void)myTimerAction
//{
//    // _blockSlder.value = time.value / time.timescale;
//    //                slider.value = time.value / time.timescale;
//    //                int b = slider.value;
//    //                label.text = [NSString stringWithFormat: @"%02d:%02d",b/60,b%60];
//
//    
//}
//- (void)viewDidAppear:(BOOL)animated
//{
//    CMTime time = _item.duration;
//    
 //   NSInteger length = (NSInteger)(time.value / time.timescale);
//    self.total.text = [NSString stringWithFormat:@"%02d:%02ld",length/60,length%60];
//    self.slider.maximumValue = length;
//
//}

- (void)progressChange
{
    CMTime time = _item.currentTime;
    time.value = time.timescale * _slider.value;
    [_player seekToTime:time];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

//播放结束
- (void)playToEnd
{
    CMTime time = _item.currentTime;
    time.value = 0 * time.timescale;
    [_player seekToTime:time];
   // [_player play];
    
    
    
    if ([_styleButton.currentTitle isEqualToString:@"单曲循环"]) {
        [_player play];
    }
    
    if ([_styleButton.currentTitle isEqualToString:@"随机循环"]) {
        
        [_player pause];
        NSInteger i = _dataArray.count;
        PlayCellModel *model = _dataArray[arc4random()%i];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];
        [self createPlayerWithUrlStr:urlString];
    NSLog(@"name==%@",model.nameStr);
        self.title = model.nameStr;
//        MusicPlayViewController *vc = [MusicPlayViewController shareManager];
//        [vc createPlayerWithUrlStr:urlString];
//        [vc.dataArray addObject:model];
//        [vc.imgView setImageWithURL:[NSURL URLWithString:model.imgStr]];
//        
//        [vc fresh];
//        vc.title = model.nameStr;

    }
    
    if ([_styleButton.currentTitle isEqualToString:@"顺序循环"]) {
        [_player pause];
        
        UIButton *button = [self.view viewWithTag:501];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        button.selected = !button.selected;
        [button setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
        
        PlayCellModel *model = nil;
        for (NSInteger i = 0; i < _dataArray.count; i++) {
            model = _dataArray[i];
            if ([model.nameStr isEqualToString:self.title]) {
                NSInteger k = i+1;
                if (k >= _dataArray.count) {
                    k = 0;
                }
                
                model = _dataArray[k];
                self.title = model.nameStr;
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];
                [self createPlayerWithUrlStr:urlStr];
                self.title = model.nameStr;
                break;
            }
        }
       // [_player play];
    }
    
}


//- (void)moviePlay
//{
//    if (_item) {
//    self.slider.value = _item.currentTime.value / _item.currentTime.timescale;
//    NSInteger length = (NSInteger)(_item.currentTime.value / _item.currentTime.timescale);
//    
//    self.current.text = [NSString stringWithFormat:@"%02ld:%02ld",length/60,length%60];
//    static dispatch_once_t hehe;
//    dispatch_once(&hehe, ^{
//        _slider.maximumValue = length;
//     //   NSLog(@"2132456");
//        
//        
//    });
//    }
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  
   
        [self createScroll];
        
        [_tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    
        [self.slider addTarget:self action:@selector(progressChange) forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"加载完成");
//    for (NSInteger i = 0; i < _dataArray.count; i++) {
//        PlayCellModel *model = _dataArray[i];
//        
//        NSLog(@"name==%@,singer==%@,img==%@",model.nameStr,model.singerStr,model.imgStr);
//    }
}


    



- (void)createScroll
{
    _scroll.pagingEnabled = YES;
    CGRect rect = [UIScreen mainScreen].bounds;
    [self.scroll addSubview:_scrollView];
   // _scroll.contentSize = CGSizeMake(rect.size.width * 1, 0);
    //_scroll.contentOffset = CGPointMake(rect.size.width, 0);
  
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width, 0,rect.size.width, _scroll.frame.size.height)];
    _imgView.backgroundColor = [UIColor redColor];
    [_scroll addSubview:_imgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, _scroll.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor grayColor];
    _scroll.pagingEnabled = YES;
    [_scroll addSubview:_tableView];
}



#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayCellModel *model = _dataArray[indexPath.row];
    
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell"];
    [cell.imgView setImageWithURL:[NSURL URLWithString: model.imgStr]];
    
    cell.nameLabel.text = model.nameStr;
    cell.singerLabel.text = model.singerStr;

    cell.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activities_bg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    PlayCellModel *model = _dataArray[indexPath.row];
    if (![self.title isEqualToString:model.nameStr]){
    NSString *urlString = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];
    [_imgView setImageWithURL:[NSURL URLWithString:model.imgStr]];
    [self createPlayerWithUrlStr:urlString];
    self.title = model.nameStr;
    }
    
}


//- (void)viewDidAppear:(BOOL)animated
//{
//    
////    if (_count++ ==1) {
////        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, _scroll.frame.size.height);
////    }
////   // NSLog(@"已经出现");
////    
////    
////    [_tableView reloadData];
////    if ([_string isEqualToString:@"暂停"]) {
////        _playBtn.selected = !_playBtn.selected;
////        _string = @"";
////    }
//}
//
-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayCellModel *model = _dataArray[indexPath.row];
    
    
    if (![model.nameStr isEqualToString:self.title]){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"不能删除正在播放的歌曲" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }

}

//播放上一首
- (IBAction)preBtn:(id)sender {
    
    [_player pause];
    
    UIButton *button = [self.view viewWithTag:501];
    [button setTitle:@"暂停" forState:UIControlStateNormal];

    [button setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
    
    
    
    PlayCellModel *model = nil;
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        model = _dataArray[i];
        if ([model.nameStr isEqualToString:self.title]) {
            
           //
            
            NSInteger k = i-1;
            if (k < 0) {
                k = _dataArray.count-1;
                
            }
            model = _dataArray[k];
            self.title = model.nameStr;
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];
            [self createPlayerWithUrlStr:urlStr];
            break;
            
            
        }
    }
    
    
    
    
    //[_player play];
    
}

//播放下一首
- (IBAction)nextBtn:(id)sender {
    
    [_player pause];
    
    UIButton *button = [self.view viewWithTag:501];
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
    

    
    PlayCellModel *model = nil;
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        model = _dataArray[i];
        if ([model.nameStr isEqualToString:self.title]) {
            NSInteger k = i+1;
            if (k >= _dataArray.count) {
                k = 0;
                
            }

            model = _dataArray[k];
            self.title = model.nameStr;
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",model.urlStr,APPEND];
            [self createPlayerWithUrlStr:urlStr];
            break;
            
            
        }
    }
    
    
    
    
    //[_player play];

    
}

- (void)showAlert:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
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
