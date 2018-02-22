//
//  BeeOneDiceViewController.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/2/6.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeOneDiceViewController.h"
#import "BeeDiceView.h"
#import <AVFoundation/AVFoundation.h>
#import "BeeOneExplainViewController.h"

@interface BeeOneDiceViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) BeeDiceView *diceView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *timer2;
@property (nonatomic,assign)float theNum;
@property (nonatomic,assign)float Num1;
@property (nonatomic,assign)int thetag;
@property (nonatomic,assign)int roundPoint;
@property (nonatomic,assign)int onPoint;
@property (nonatomic,strong)UIImageView *yaoImg;
@property (nonatomic,strong)UIImageView *canShakeImg;
@property (nonatomic,strong)UISwitch *shakeSwitch;
@property (nonatomic , strong) AVAudioPlayer *player;

@end

@implementation BeeOneDiceViewController

- (AVAudioPlayer *)player
{
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"yaoshaizi" withExtension:@"mp3"];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
    }
    return _player;
}

- (UISwitch *)shakeSwitch
{
    if (!_shakeSwitch) {
        _shakeSwitch = [[UISwitch alloc]init];
        if ([[USER_DEFAULT objectForKey:OneOfShake]intValue] == 0) {
            [_shakeSwitch setOn:YES];
        }else{
            [_shakeSwitch setOn:NO];
        }
        [_shakeSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    }
    return _shakeSwitch;
}

- (UIImageView *)canShakeImg
{
    if (!_canShakeImg) {
        _canShakeImg = [[UIImageView alloc]init];
        [_canShakeImg setImage:[UIImage imageNamed:@"yaoyiyao"]];
    }
    return _canShakeImg;
}

- (UIImageView *)yaoImg
{
    if (!_yaoImg) {
        _yaoImg = [[UIImageView alloc]init];
        [_yaoImg setImage:[UIImage imageNamed:@"yao"]];
        WS(weakSelf);
        [_yaoImg whenTapped:^{
            [weakSelf shakingAction];
            
        }];
    }
    return _yaoImg;
}

- (BeeDiceView *)diceView
{
    if (!_diceView) {
        _diceView = [[BeeDiceView alloc]init];
    }
    return _diceView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftbtn.frame = CGRectMake(0, 0, 35, 35);
    [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(10, -5, 5, 20)];
    leftbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0, 0, 70, 64);
    rightBtn.titleLabel.font = SYSTEMFONT(15);
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitleColor:[UIColor blackColor] forState:0];
    [rightBtn setTitle:@"操作说明" forState:0];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)leftButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction
{
    BeeOneExplainViewController *vc = [[BeeOneExplainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"单骰摇晃";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.diceView];
    [self.diceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.width.mas_equalTo(50);
        
    }];
    
    [self.view addSubview:self.yaoImg];
    [self.yaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.canShakeImg];
    [self.canShakeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(60);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(BeeNavigationHeight + 10);
    }];
    
    [self.view addSubview:self.shakeSwitch];
    [self.shakeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.canShakeImg.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.canShakeImg);
    }];
    
    
    CATransform3D perspective1 = CATransform3DIdentity;
    perspective1.m34 = -1/500;
    perspective1 = CATransform3DRotate(perspective1, -M_PI_4 + M_PI_2, 1, 0, 0);
    perspective1 = CATransform3DRotate(perspective1, -M_PI_4, 0, 0, 1);
    perspective1 = CATransform3DTranslate(perspective1, 0, 0, 25);
    self.diceView.layer.sublayerTransform = perspective1;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer2Action) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer2 forMode:NSDefaultRunLoopMode];
    [self.timer2 setFireDate:[NSDate distantFuture]];
    
    
}

- (void)shakingAction
{
    if (self.thetag == 0) {
        [self.player stop];
        [self.player play];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.thetag = 1;
        self.Num1 = M_PI_4; // 控制之后timer2的时间动画长短
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer setFireDate:[NSDate distantPast]];
        [self performSelector:@selector(toEndTheShaking) withObject:nil afterDelay:2];
    }
}

- (void)timerAction
{
    
    self.theNum += 0.35;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    
    perspective = CATransform3DRotate(perspective, self.theNum, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 1, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 0, 1);
    
    perspective = CATransform3DTranslate(perspective, 0, 0, 25);
    self.diceView.layer.sublayerTransform = perspective;
    
}

- (void)toEndTheShaking
{
    self.theNum = 0;
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer2 setFireDate:[NSDate distantPast]];
    self.roundPoint = (arc4random() % 4);
    self.onPoint = (arc4random() % 6);
}

- (void)timer2Action
{
    self.Num1 = self.Num1 - 0.025;
    if (self.Num1 > 0) {
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/500.0;
        switch (self.onPoint) {
            case 0:
            {
                // 1 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * self.roundPoint -self.Num1, 0, 0, 1);
            }
                break;
            case 1:
            {
                // 2 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * self.roundPoint - self.Num1, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_2 - self.Num1, 0, 0, 1);
                
            }
                break;
            case 2:
            {
                // 3 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * 2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * self.roundPoint, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                
            }
                break;
            case 3:
            {
                // 4 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * self.roundPoint, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                
            }
                break;
            case 4:
            {
                // 5 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * self.roundPoint - self.Num1, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_2 - self.Num1, 0, 0, 1);
                
            }
                break;
            case 5:
            {
                // 6 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - M_PI_2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * self.roundPoint -self.Num1, 0, 0, 1);
            }
                break;
                
            default:
                break;
        }
        
        perspective = CATransform3DTranslate(perspective, 0, 0, 25 );
        self.diceView.layer.sublayerTransform = perspective;

    }else{
        [self.timer2 setFireDate:[NSDate distantFuture]];
        self.thetag = 0;
    }
    

}

#pragma mark - 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (!(motion == UIEventSubtypeMotionShake)) {
        return;
    }
    if (self.thetag == 0 && [self.shakeSwitch isOn] == YES) {
        [self shakingAction];
    }
    
    return;
}

- (void)switchAction
{
    if ([self.shakeSwitch isOn]) {
        [USER_DEFAULT setObject:[NSNumber numberWithInt:0] forKey:OneOfShake];
    }else{
        [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:OneOfShake];
    }
}



@end
