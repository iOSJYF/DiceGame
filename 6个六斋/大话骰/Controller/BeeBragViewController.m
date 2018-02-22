//
//  BeeBragViewController.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/1/31.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeBragViewController.h"
#import "BeeBragContentView.h"
#import <AVFoundation/AVFoundation.h>
#import "BeeFiveExplainViewController.h"

@interface BeeBragViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,strong)BeeBragContentView *bragContentView;
@property (nonatomic,strong)UIImageView *yaoImg;
@property (nonatomic,strong)UIImageView *suoImg;
@property (nonatomic,strong)UIImageView *biImg;
@property (nonatomic,strong)UIVisualEffectView *maoboli;
@property (nonatomic,assign)BOOL canShake;
@property (nonatomic,retain)UIAlertController *alert;
@property (nonatomic,retain)UIAlertController *alert2;
@property (nonatomic,strong)UIImageView *canShakeImg;
@property (nonatomic,strong)UISwitch *shakeSwitch;
@property (nonatomic , strong)AVAudioPlayer *player;

@end

@implementation BeeBragViewController

- (AVAudioPlayer *)player
{
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"zuobisound" withExtension:@"m4a"];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
    }
    return _player;
}

- (UISwitch *)shakeSwitch
{
    if (!_shakeSwitch) {
        _shakeSwitch = [[UISwitch alloc]init];
        if ([[USER_DEFAULT objectForKey:FiveOfShake]intValue] == 0) {
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

- (UIAlertController *)alert2
{
    if (!_alert2) {
        WS(weakSelf);
        _alert2 = [UIAlertController alertControllerWithTitle:nil message:@"请选择你想要的点数" preferredStyle:UIAlertControllerStyleActionSheet];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:0];
        }]];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:1];
        }]];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"3" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:2];
        }]];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"4" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:3];
        }]];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:4];
        }]];
        [_alert2 addAction:[UIAlertAction actionWithTitle:@"6" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf xuanzedianshu:5];
        }]];
        
        
    }
    return _alert2;
}


- (UIAlertController *)alert
{
    if (!_alert) {
        WS(weakSelf);
        _alert = [UIAlertController alertControllerWithTitle:nil message:@"自罚一杯即可随机改变一个骰子的点数" preferredStyle:UIAlertControllerStyleAlert];
        _alert.modalPresentationStyle = UIModalPresentationFullScreen;
        [_alert addAction:[UIAlertAction actionWithTitle:@"自罚一杯" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf zifayibei];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"算了" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alert;
}


- (UIVisualEffectView *)maoboli
{
    if (!_maoboli) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _maoboli = [[UIVisualEffectView alloc] initWithEffect:effect];
        
        UIImageView *yuanImg = [[UIImageView alloc]init];
        [yuanImg setImage:[UIImage imageNamed:@"yuan"]];
        [_maoboli addSubview:yuanImg];
        [yuanImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.width.mas_equalTo(150);
            make.top.mas_equalTo(ScreenHeight/2-75);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"開";
        label.textColor = [UIColor whiteColor];
        label.font = SYSTEMFONT(40);
        [_maoboli addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(yuanImg);
        }];
        
        WS(weakSelf);
        [_maoboli whenTapped:^{
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf.maoboli mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(ScreenHeight);
                }];
                [BeeAppWindow layoutIfNeeded];
                weakSelf.canShake = YES;
            }];
        }];
        
    }
    return _maoboli;
}


- (UIImageView *)yaoImg
{
    if (!_yaoImg) {
        _yaoImg = [[UIImageView alloc]init];
        [_yaoImg setImage:[UIImage imageNamed:@"yao"]];
        WS(weakSelf);
        [_yaoImg whenTapped:^{
            if (weakSelf.canShake == YES) {
                [weakSelf.bragContentView shakingAction];
            }
        }];
    }
    return _yaoImg;
}

- (UIImageView *)suoImg
{
    if (!_suoImg) {
        _suoImg = [[UIImageView alloc]init];
        [_suoImg setImage:[UIImage imageNamed:@"suo"]];
        WS(weakSelf);
        [_suoImg whenTapped:^{
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf.maoboli mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                }];
                [BeeAppWindow layoutIfNeeded];
                weakSelf.canShake = NO;
            }];
        }];
    }
    return _suoImg;
}

- (UIImageView *)biImg
{
    if (!_biImg) {
        _biImg = [[UIImageView alloc]init];
        [_biImg setImage:[UIImage imageNamed:@"bi"]];
        WS(weakSelf);
        [_biImg whenTapped:^{
            [weakSelf zuobi];
        }];
    }
    return _biImg;
}

- (BeeBragContentView *)bragContentView
{
    if (!_bragContentView) {
        _bragContentView = [[BeeBragContentView alloc]init];
    }
    return _bragContentView;
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
    BeeFiveExplainViewController *vc = [[BeeFiveExplainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    self.title = @"大话骰(吹牛逼)";
    self.canShake = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bragContentView];
    [self.bragContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    [self.view addSubview:self.suoImg];
    [self.suoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.yaoImg];
    [self.yaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(self.suoImg.mas_left).offset(-50);
        make.height.width.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.biImg];
    [self.biImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(self.suoImg.mas_right).offset(50);
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
    
    [BeeAppWindow addSubview:self.maoboli];
    [self.maoboli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ScreenHeight);
        make.bottom.mas_equalTo(0);
    }];
 
    
}

#pragma mark - 作弊操作
- (void)zuobi
{
    [self presentViewController:self.alert animated:YES completion:nil];
    
}

- (void)zifayibei
{
    [self.player stop];
    [self.player play];
    [self presentViewController:self.alert2 animated:YES completion:nil];
}

- (void)xuanzedianshu:(int)thePoint
{
    [self.bragContentView zuobi:thePoint];
}


#pragma mark - 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (!(motion == UIEventSubtypeMotionShake)) {
        return;
    }
    if (self.canShake == YES && [self.shakeSwitch isOn] == YES) {
        [self.bragContentView shakingAction];
    }
    
    return;
}

- (void)switchAction
{
    if ([self.shakeSwitch isOn]) {
        [USER_DEFAULT setObject:[NSNumber numberWithInt:0] forKey:FiveOfShake];
    }else{
        [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:FiveOfShake];
    }
}


@end
