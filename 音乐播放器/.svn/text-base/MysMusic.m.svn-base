 //
//  MysMusic.m
//  音乐播放器
//
//  Created by 喻佳珞 on 16/3/7.
//  Copyright © 2016年 喻佳珞. All rights reserved.
//

#import "MysMusic.h"

#import <AVFoundation/AVFoundation.h>

#import "SearchViewController.h"

#import "ListViewController.h"

#import "MusicPlayViewController.h"

#import "DownManagerVC.h"

#import "RESideMenu.h"

#import "NameSingerModel.h"

#import "FMDatabase.h"
#import "DBManager.h"


@interface MysMusic ()<AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    
    NSTimer *_myTimer;
    NSInteger _count;
    UIImageView *_imgView;
    BOOL _stop;
    ListViewController *_rightList;
    NSArray *_geciArray;
    CGFloat _float;
    NSInteger _secd;
    
    
    CGRect _source1;    //记录两个视图控制器拖动刚开始的位置,
    CGRect _source2;
    
    
    
   // UISearchController *_mySearchControl;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@end

@implementation MysMusic

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [[self navigationController] setHidesBottomBarWhenPushed:YES];
    //self.automaticallyAdjustsScrollViewInsets = YES;
    static MysMusic *music = nil;
    @synchronized(music) {
        if (!music) {
            music = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
            
        }
    }
    return music;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_MP3DataArr removeAllObjects];
    FMResultSet *set = [[DBManager shareManager].dataBase executeQuery:@"select * from music"];
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    while ([set next]) {
        NameSingerModel *model = [[NameSingerModel alloc] init];
        model.name = [set stringForColumn:@"name"];
        model.singer = [set stringForColumn:@"singer"];
        [mutArray addObject:model];
        [_MP3DataArr addObject:model.name];
    }
    [_rightList reloadCell:mutArray];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _MP3DataArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    
    //[_MP3DataArr addObjectsFromArray:@[@"年轮",@"我可以抱你吗",@"喜欢你",@"小苹果"]];
    
    //[self creatMP3Play:_MP3DataArr[_count]];
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(currenTimeChange) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_myTimer forMode:NSRunLoopCommonModes];
    
    
    [_slider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    [_upBtn addTarget:self action:@selector(upMP3) forControlEvents:UIControlEventTouchUpInside];
    
    [_downBtn addTarget:self action:@selector(downMP3) forControlEvents:UIControlEventTouchUpInside];
    
    
//    SearchViewController *searchVC = [[SearchViewController alloc] init];
//    _mySearchControl = [[UISearchController alloc] initWithSearchResultsController:searchVC];
//    
//    _mySearchControl.hidesNavigationBarDuringPresentation = NO;
//    _mySearchControl.dimsBackgroundDuringPresentation = NO;
//    
//    
//    self.navigationItem.titleView = _mySearchControl.searchBar;
    
    [self createAnima];
    
    
    
    [self createRightController];
    
    
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction)];

    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pangr:)];
    
    [self.view addGestureRecognizer:pan];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"188"] style:UIBarButtonItemStyleDone target:self action:@selector(presentLeftMenuViewController:)];
    
    
    [self createTap];
    
    
    
    
    _tableView.delegate = self;
    _tableView.dataSource =self ;

    UIImageView *imageView= [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"20140628141000_dMYvZ.jpeg"];
    
    _tableView.backgroundView = imageView;
    
}



- (void)createTap
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgr)];
//    [self.view addGestureRecognizer:tap];
//    
    
    //覆盖tap
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
//    [_rightList.view addGestureRecognizer:tap2];
    
}

- (void)tapgr
{
    _rightList.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width-64, self.view.frame.size.height);
}


- (void)createRightController
{
    _rightList = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    _rightList.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_rightList];
    [self.view addSubview:_rightList.view];
    

    
    
    
    
}

- (void)addPlayerWithUrlString:(id)obj
{
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:@""] error:nil];
    
    //    [self performSelectorInBackground:@selector(PrepareLoad:) withObject:fileName];
    [_player prepareToPlay]; //因为下面的设置需要真的开始播放音乐,所有会卡断点
    float timeLeng = _player.duration;
    _slider.maximumValue = timeLeng;
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)timeLeng/60,(NSInteger)timeLeng %60];

    _currentTimeLabel.text = @"00:00";
    
    _player.delegate = self;

}

- (IBAction)presentLeftMenuViewController:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)pangr:(UIPanGestureRecognizer *)pan
{
    
    CGPoint point = [pan translationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        

        _source2 = _rightList.view.frame;
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        _rightList.view.frame = CGRectMake(_rightList.view.frame.size.width+point.x, 64, self.view.frame.size.width, self.view.frame.size.height);
    } else if (pan.state == UIGestureRecognizerStateEnded){
        if (point.x < -60) {
            
            _rightList.view.frame = CGRectMake(self.view.frame.size.width - 260, 64, self.view.frame.size.width, self.view.frame.size.height);
        } else {
            _rightList.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height);
        }
    
        if (point.x >150) {
            [self presentLeftMenuViewController:nil];

        }
    }
    
    
    /*
     evaluating touch events. this is the default state
     
     UIGestureRecognizerStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
     UIGestureRecognizerStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
     UIGestureRecognizerStateEnded,
     */

    
    
    
}



- (void)rightAction
{
    if (_rightList.view.frame.origin.x == self.view.frame.size.width) {
        _rightList.view.frame = CGRectMake(self.view.frame.size.width - 260, 64, self.view.frame.size.width, self.view.frame.size.height);

        
    } else {
        _rightList.view.frame = CGRectMake(self.view.frame.size.width, 64, self.view.frame.size.width, self.view.frame.size.height);

    }
    
}

- (void)createAnima
{
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 50, 50)];
    _imgView.image = [UIImage imageNamed:@"DOVE 1"];
    [self.view addSubview:_imgView];
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 19; i++) {
        [mutArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"DOVE %ld",i]]];
    }
    
    _imgView.animationImages = mutArr;
    _imgView.animationDuration = 0.2;
    [self.view addSubview:_imgView];
    [_imgView startAnimating];
    _imgView.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(myTimer:) userInfo:_imgView repeats:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"动画" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 80, 0);
    
    [button addTarget:self action:@selector(animationChange) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
    
    
}


//动画隐藏与否
- (void)animationChange
{
     _stop = !_stop;
    _imgView.hidden = _stop;
   
    
}

- (void)myTimer:(NSTimer *)timer
{
   
    UIImageView *imageView =  timer.userInfo;
    [UIView animateWithDuration:1.2 animations:^{
        imageView.frame = CGRectMake(arc4random() % (int)(self.view.frame.size.width-64), arc4random()%(int)(self.view.frame.size.height-200) + 64, 60, 60);
    }];
    
    NSInteger i = 0;
    for (NSString *string in _geciArray) {
        i++;
        if  ([string rangeOfString:_currentTimeLabel.text].location != NSNotFound) {
            [_tableView setContentOffset:CGPointMake(0, i*30) animated:YES];
            return;
           //  NSLog(@"string==%@",string);
        }
       
    }
    
    
    
    
    
    
    
}

- (void)downMP3
{
    if ([MusicPlayViewController shareManager].item){
        if ([MusicPlayViewController shareManager].player) {
            //            [[MusicPlayViewController shareManager].item removeObserver:[MusicPlayViewController shareManager] forKeyPath:@"status"];
            //            [MusicPlayViewController shareManager].item = nil;
            MusicPlayViewController *playOnline = [MusicPlayViewController shareManager];
            [playOnline.player pause];
            [playOnline.playBtn setTitle:@"播放" forState:UIControlStateNormal];
            [playOnline.playBtn setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
            
            //NSLog(@"12435367");
            
            // [MusicPlayViewController shareManager].player = nil;
        }
    }
    if (_MP3DataArr.count != 0)
    {_count++;
    if (_count >= _MP3DataArr.count) {
        _count = 0;
    }
    [self creatMP3Play:_MP3DataArr[_count]];
    _slider.value = 0;
    [_playButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_player play];
    [_playButton setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
    [_player play];
    }
}

- (void)upMP3
{if ([MusicPlayViewController shareManager].item){
    if ([MusicPlayViewController shareManager].player) {
        //            [[MusicPlayViewController shareManager].item removeObserver:[MusicPlayViewController shareManager] forKeyPath:@"status"];
        //            [MusicPlayViewController shareManager].item = nil;
        MusicPlayViewController *playOnline = [MusicPlayViewController shareManager];
        [playOnline.player pause];
        [playOnline.playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [playOnline.playBtn setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
        
        //NSLog(@"12435367");
        
        // [MusicPlayViewController shareManager].player = nil;
    }
}
    if (_MP3DataArr.count != 0) {
    _count--;
    if (_count < 0) {
        _count = _MP3DataArr.count - 1;
    }
    [self creatMP3Play:_MP3DataArr[_count]];
    _slider.value = 0;
    
        
    [_playButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_player play];
    [_playButton setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
    [_player play];
    }
}

- (void)sliderChange
{
    _player.currentTime = _slider.value;
}

- (void)currenTimeChange
{
    _currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)_player.currentTime/60,(NSInteger)_player.currentTime%60];
    _slider.value = _player.currentTime;
    
}

//播放按钮
- (IBAction)playBtn:(UIButton *)sender {
    
    //随便打个补丁😄
    if (![_fileName.text isEqualToString: @"  "]) {
        

    if ([MusicPlayViewController shareManager].item){
        if ([MusicPlayViewController shareManager].player) {
//            [[MusicPlayViewController shareManager].item removeObserver:[MusicPlayViewController shareManager] forKeyPath:@"status"];
//            [MusicPlayViewController shareManager].item = nil;
            MusicPlayViewController *playOnline = [MusicPlayViewController shareManager];
            [playOnline.player pause];
            [playOnline.playBtn setTitle:@"播放" forState:UIControlStateNormal];
            [playOnline.playBtn setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
            if ([playOnline.myTimer isValid]) {
                [playOnline.myTimer invalidate];
            }
            //NSLog(@"12435367");
            
           // [MusicPlayViewController shareManager].player = nil;
        }
    }
    

        if ([sender.currentTitle isEqualToString:@"暂停"]) {
            [sender setTitle:@"播放" forState:UIControlStateNormal];
            [sender setImage:[UIImage imageNamed:@"tone_play.png"] forState:UIControlStateNormal];
            [_player pause];
        } else {
            [sender setImage:[UIImage imageNamed:@"tone_pause.png"] forState:UIControlStateNormal];
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
            [_player play];
            //_imgView.hidden = YES; //先隐藏动画吧
        }
        
    }
}

//播放完毕
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _count++;
    if (_count >= _MP3DataArr.count) {
        _count = 0;
    }
    [self creatMP3Play:_MP3DataArr[_count]];
    _slider.value = 0;
    [_player play];
}

- (void)creatMP3Play:(NSString *)fileName
{
//    NSLog(@"创建");

   // NSLog(@"%@",[[NSBundle mainBundle] pathForResource:@"小苹果" ofType:@"mp3"]);
    _secd = 0;
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.mp3",fileName]];
    NSLog(@"path == %@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    
//    [self performSelectorInBackground:@selector(PrepareLoad:) withObject:fileName];
    [_player prepareToPlay];
    float timeLeng = _player.duration;
    _slider.maximumValue = timeLeng;
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)timeLeng/60,(NSInteger)timeLeng %60];
    _fileName.text = fileName;
    _currentTimeLabel.text = @"00:00";
    
    _player.delegate = self;
    [_playButton setTitle:@"播放" forState:UIControlStateNormal];
    

#warning 更改歌词 从数据库中得到歌词
    
    FMResultSet *result = [[DBManager shareManager].dataBase executeQuery:@"select * from music where name like ?",fileName];
    NSString *stringgeci = nil;
    while ([result next]) {

        stringgeci = [result stringForColumn:@"contentid"];
    }
    
    _geciArray = [stringgeci componentsSeparatedByString:@"\n"];
    
    [_tableView reloadData];
    
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _float = _tableView.contentSize.height;
    
}

- (void)PrepareLoad:(NSString *)fileName
{
    [_player prepareToPlay];
    float timeLeng = _player.duration;
    _slider.maximumValue = timeLeng;
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(NSInteger)timeLeng/60,(NSInteger)timeLeng %60];
    _fileName.text = fileName;
    _currentTimeLabel.text = @"00:00";
    
    _player.delegate = self;
}


#pragma mark -tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _geciArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gecicell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gecicell"];
    }
    
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:_geciArray[indexPath.row]];
    NSArray *arr = [string componentsSeparatedByString:@"]"];
    
    
    
    cell.textLabel.text = [arr lastObject];
    
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activities_bg"]];
    return cell;
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
