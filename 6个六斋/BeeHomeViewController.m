//
//  BeeHomeViewController.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/1/24.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeHomeViewController.h"
#import "BeeBragViewController.h"
#import "BeeOneDiceViewController.h"
#import "BeeThreeDiceViewController.h"


@interface BeeHomeViewController ()

@property (nonatomic,strong)UIImageView *titleImg;
@property (nonatomic,strong)UIImageView *tzImg;
@property (nonatomic,strong)UIImageView *textImg1;
@property (nonatomic,strong)UIImageView *textImg2;
@property (nonatomic,strong)UIImageView *textImg3;

@end

@implementation BeeHomeViewController

- (UIImageView *)textImg1
{
    if (!_textImg1) {
        _textImg1 = [[UIImageView alloc]init];
        [_textImg1 setImage:[UIImage imageNamed:@"text1"]];
        WS(weakSelf);
        [_textImg1 whenTapped:^{
            BeeOneDiceViewController *vc = [[BeeOneDiceViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _textImg1;
}

- (UIImageView *)textImg2
{
    if (!_textImg2) {
        _textImg2 = [[UIImageView alloc]init];
        [_textImg2 setImage:[UIImage imageNamed:@"text2"]];
        WS(weakSelf);
        [_textImg2 whenTapped:^{
            BeeThreeDiceViewController *vc = [[BeeThreeDiceViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
       
    }
    return _textImg2;
}

- (UIImageView *)textImg3
{
    if (!_textImg3) {
        _textImg3 = [[UIImageView alloc]init];
        [_textImg3 setImage:[UIImage imageNamed:@"text3"]];
        WS(weakSelf);
        [_textImg3 whenTapped:^{
            BeeBragViewController *vc = [[BeeBragViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _textImg3;
}


- (UIImageView *)tzImg
{
    if (!_tzImg) {
        _tzImg = [[UIImageView alloc]init];
        [_tzImg setImage:[UIImage imageNamed:@"tz"]];
    }
    return _tzImg;
}

- (UIImageView *)titleImg
{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc]init];
        [_titleImg setImage:[UIImage imageNamed:@"6ge6text"]];
    }
    return _titleImg;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleImg];
    [self.titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(BeeStatusHeight+10);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(180);
    }];
    
    [self.view addSubview:self.tzImg];
    [self.tzImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(85);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-5);
    }];
    
    [self.view addSubview:self.textImg1];
    [self.textImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.titleImg.mas_bottom).offset(50);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(135);
    }];
    
    [self.view addSubview:self.textImg2];
    [self.textImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textImg1.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(250);
    }];
    
    [self.view addSubview:self.textImg3];
    [self.textImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(self.textImg2.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(231);
    }];
    
    
    
    
}





@end
