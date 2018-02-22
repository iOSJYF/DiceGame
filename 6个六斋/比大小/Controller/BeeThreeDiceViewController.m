//
//  BeeThreeDiceViewController.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/2/6.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeThreeDiceViewController.h"
#import "BeeThreeDiceContentView.h"
#import "BeeThreeExplainViewController.h"

@interface BeeThreeDiceViewController ()

@property (nonatomic,strong)BeeThreeDiceContentView *contentView;
@property (nonatomic,strong)UIImageView *yaoImg;
@property (nonatomic,strong)UIImageView *suoImg;
@property (nonatomic,strong)UIVisualEffectView *maoboli;
@property (nonatomic,assign)BOOL canShake;
@property (nonatomic,strong)UIImageView *canShakeImg;
@property (nonatomic,strong)UISwitch *shakeSwitch;
@end

@implementation BeeThreeDiceViewController

- (UISwitch *)shakeSwitch
{
    if (!_shakeSwitch) {
        _shakeSwitch = [[UISwitch alloc]init];
        if ([[USER_DEFAULT objectForKey:ThreeOfShake]intValue] == 0) {
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

- (BeeThreeDiceContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[BeeThreeDiceContentView alloc]init];
        WS(weakSelf);
        _contentView.hideBlock = ^{
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf.maoboli mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                }];
                [BeeAppWindow layoutIfNeeded];
                weakSelf.canShake = NO;
            }];
        };
    }
    return _contentView;
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
                [weakSelf.contentView shakingAction];
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
    BeeThreeExplainViewController *vc = [[BeeThreeExplainViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"比大小";
    self.canShake = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    [self.view addSubview:self.yaoImg];
    [self.yaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(-50);
        make.height.width.mas_equalTo(70);
    }];
    
    [self.view addSubview:self.suoImg];
    [self.suoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-60);
        make.centerX.mas_equalTo(50);
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


#pragma mark - 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (!(motion == UIEventSubtypeMotionShake)) {
        return;
    }
    if (self.canShake == YES && [self.shakeSwitch isOn] == YES) {
        [self.contentView shakingAction];
    }
    
    return;
}

- (void)switchAction
{
    if ([self.shakeSwitch isOn]) {
        [USER_DEFAULT setObject:[NSNumber numberWithInt:0] forKey:ThreeOfShake];
    }else{
        [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:ThreeOfShake];
    }
}

@end
