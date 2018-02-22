//
//  BeeBragContentView.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/1/31.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeBragContentView.h"
#import "BeeDiceView.h"
#import <AVFoundation/AVFoundation.h>

@interface BeeBragContentView ()<AVAudioPlayerDelegate>

@property (nonatomic,strong) BeeDiceView *diceView;
@property (nonatomic,strong) BeeDiceView *diceView1;
@property (nonatomic,strong) BeeDiceView *diceView2;
@property (nonatomic,strong) BeeDiceView *diceView3;
@property (nonatomic,strong) BeeDiceView *diceView4;

@property (nonatomic,assign)float theNum;
@property (nonatomic,assign)float Num1;

@property (nonatomic,assign)int thetag;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *timer2;
@property (nonatomic,strong)NSTimer *timer3;
@property (nonatomic,strong)NSTimer *timer4;

//@property (nonatomic,assign)int roundPoint;
//@property (nonatomic,assign)int onPoint;
@property (nonatomic,strong)NSMutableArray *roundArr;
@property (nonatomic,strong)NSMutableArray *onArr;

@property (nonatomic,assign)float zTrans;

// zuobi
@property (nonatomic,assign)int chooseNum;
@property (nonatomic,assign)int chooseValue;
@property (nonatomic,assign)int sjFour;

@property (nonatomic , strong) AVAudioPlayer *player;


@end

@implementation BeeBragContentView

- (AVAudioPlayer *)player
{
    if (!_player) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"yaoshaizi" withExtension:@"mp3"];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
    }
    return _player;
}





- (BeeDiceView *)diceView
{
    if (!_diceView) {
        _diceView = [[BeeDiceView alloc]init];
    }
    return _diceView;
}

- (BeeDiceView *)diceView1
{
    if (!_diceView1) {
        _diceView1 = [[BeeDiceView alloc]init];
        
    }
    return _diceView1;
}

- (BeeDiceView *)diceView2
{
    if (!_diceView2) {
        _diceView2 = [[BeeDiceView alloc]init];
        
    }
    return _diceView2;
}

- (BeeDiceView *)diceView3
{
    if (!_diceView3) {
        _diceView3 = [[BeeDiceView alloc]init];
        
    }
    return _diceView3;
}

- (BeeDiceView *)diceView4
{
    if (!_diceView4) {
        _diceView4 = [[BeeDiceView alloc]init];
        
    }
    return _diceView4;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        float s72 = sin(M_PI_2*72/90) * 80;
        float c72 = cos(M_PI_2*72/90) * 80;
        float s36 = sin(M_PI_2*36/90) * 80;
        float c36 = cos(M_PI_2*36/90) * 80;
        
        [self addSubview:self.diceView];
        [self.diceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-80);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.diceView1];
        [self.diceView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-s72);
            make.centerY.mas_equalTo(-c72);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.diceView2];
        [self.diceView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(s72);
            make.centerY.mas_equalTo(-c72);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.diceView3];
        [self.diceView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-s36);
            make.centerY.mas_equalTo(c36);
            make.width.height.mas_equalTo(50);
        }];
        
        [self addSubview:self.diceView4];
        [self.diceView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(s36);
            make.centerY.mas_equalTo(c36);
            make.width.height.mas_equalTo(50);
        }];
        
        [self creatThe3DPerspective:self.diceView andZPointWithX:0 Y:0 Z:25];
        [self creatThe3DPerspective:self.diceView1 andZPointWithX:0 Y:0 Z:25];
        [self creatThe3DPerspective:self.diceView2 andZPointWithX:0 Y:0 Z:25];
        [self creatThe3DPerspective:self.diceView3 andZPointWithX:0 Y:0 Z:25];
        [self creatThe3DPerspective:self.diceView4 andZPointWithX:0 Y:0 Z:25];
        
     
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [self.timer setFireDate:[NSDate distantFuture]];
        
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer2Action:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer2 forMode:NSDefaultRunLoopMode];
        [self.timer2 setFireDate:[NSDate distantFuture]];
        
        self.timer3 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer3Action) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer3 forMode:NSDefaultRunLoopMode];
        [self.timer3 setFireDate:[NSDate distantFuture]];
        
        self.timer4 = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer4Action) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer4 forMode:NSDefaultRunLoopMode];
        [self.timer4 setFireDate:[NSDate distantFuture]];
        
        
    }
    return self;
}


- (void)creatThe3DPerspective:(BeeDiceView *)diceView andZPointWithX:(int)the_x Y:(int)the_y Z:(int)the_z
{
    CATransform3D perspective1 = CATransform3DIdentity;
    perspective1.m34 = -1/500;
    perspective1 = CATransform3DRotate(perspective1, -M_PI_4 + M_PI_2, 1, 0, 0);
    perspective1 = CATransform3DRotate(perspective1, -M_PI_4, 0, 0, 1);
    perspective1 = CATransform3DTranslate(perspective1, the_x, the_y, the_z);
    diceView.layer.sublayerTransform = perspective1;
}

- (void)shakingAction
{
    if (self.thetag == 0) {
        [self.player stop];
        [self.player play];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.roundArr = [[NSMutableArray alloc]init];
        self.onArr = [[NSMutableArray alloc]init];
        self.thetag = 1;
        self.Num1 = M_PI_4; // 控制之后timer2的时间动画长短
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer setFireDate:[NSDate distantPast]];
        [self performSelector:@selector(toEndTheShaking) withObject:nil afterDelay:2.5];
    
    // 进行位移
        [UIView animateWithDuration:1.25 animations:^{
            [self.diceView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
            [self.diceView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
            [self.diceView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
            [self.diceView3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
            [self.diceView4 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
            
            [self layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            float s72 = sin(M_PI_2*72/90) * 80;
            float c72 = cos(M_PI_2*72/90) * 80;
            float s36 = sin(M_PI_2*36/90) * 80;
            float c36 = cos(M_PI_2*36/90) * 80;
            
            [UIView animateWithDuration:1.25 animations:^{
                
                [self.diceView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(0);
                    make.centerY.mas_equalTo(-80);
                }];
                
                [self.diceView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(-s72);
                    make.centerY.mas_equalTo(-c72);
                }];
                
                [self.diceView2 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(s72);
                    make.centerY.mas_equalTo(-c72);
                }];
                
                [self.diceView3 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(-s36);
                    make.centerY.mas_equalTo(c36);
                }];
                
                [self.diceView4 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(s36);
                    make.centerY.mas_equalTo(c36);
                }];
                
                [self layoutIfNeeded];
            }];
            
        }];
    }
    
}

- (void)timerAction
{
    self.zTrans += M_PI_2*8/125;
    
    self.theNum += 0.35;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    
    perspective = CATransform3DRotate(perspective, self.theNum, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 1, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 0, 1);
    
    perspective = CATransform3DTranslate(perspective, 0, 0, 25);
    self.diceView.layer.sublayerTransform = perspective;
    self.diceView1.layer.sublayerTransform = perspective;
    self.diceView2.layer.sublayerTransform = perspective;
    self.diceView3.layer.sublayerTransform = perspective;
    self.diceView4.layer.sublayerTransform = perspective;
    
    CATransform3D perspective1 = CATransform3DIdentity;
    perspective1 = CATransform3DRotate(perspective1, self.zTrans, 0, 0, 1);
    self.layer.sublayerTransform = perspective1;
    
}

- (void)toEndTheShaking
{
    self.zTrans = 0;
    self.theNum = 0;
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer2 setFireDate:[NSDate distantFuture]];
    
    for (int i = 0; i < 5; i ++) {
        int roundPoint = (arc4random() % 4);
        int onPoint = (arc4random() % 6);
        
        [self.roundArr addObject:[NSNumber numberWithInt:roundPoint]];
        [self.onArr addObject:[NSNumber numberWithInt:onPoint]];
    }
    
    [self.timer2 setFireDate:[NSDate distantPast]];
    
    CATransform3D perspective1 = CATransform3DIdentity;
    perspective1 = CATransform3DRotate(perspective1, 0, 0, 0, 1);
    self.layer.sublayerTransform = perspective1;
    
}

- (void)timer2Action:(NSTimer *)timer
{
    
    self.Num1 = self.Num1 - 0.025;
    
    if (self.Num1 > 0) {
        
        
        for (int i = 0; i < 5; i ++) {
            
            CATransform3D perspective = CATransform3DIdentity;
            perspective.m34 = -1.0/500.0;
            
            switch ([self.onArr[i] intValue]) {
                case 0:
                {
                    // 1 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * [self.roundArr[i] intValue] -self.Num1, 0, 0, 1);
                }
                    break;
                case 1:
                {
                    // 2 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * [self.roundArr[i] intValue] - self.Num1, 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, M_PI_2 - self.Num1, 0, 0, 1);
                    
                }
                    break;
                case 2:
                {
                    // 3 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * 2 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * [self.roundArr[i] intValue], 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                    
                }
                    break;
                case 3:
                {
                    // 4 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * [self.roundArr[i] intValue], 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                    
                }
                    break;
                case 4:
                {
                    // 5 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * [self.roundArr[i] intValue] - self.Num1, 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, -M_PI_2 - self.Num1, 0, 0, 1);
                    
                }
                    break;
                case 5:
                {
                    // 6 的情况
                    perspective = CATransform3DRotate(perspective, -M_PI_4 - M_PI_2 - self.Num1, 1, 0, 0);
                    perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                    perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * [self.roundArr[i] intValue] -self.Num1, 0, 0, 1);
                }
                    break;
                    
                default:
                    break;
            }
            
            perspective = CATransform3DTranslate(perspective, 0, 0, 25 );
            
            switch (i) {
                case 0:
                    self.diceView.layer.sublayerTransform = perspective;
                    break;
                case 1:
                    self.diceView1.layer.sublayerTransform = perspective;
                    break;
                case 2:
                    self.diceView2.layer.sublayerTransform = perspective;
                    break;
                case 3:
                    self.diceView3.layer.sublayerTransform = perspective;
                    break;
                case 4:
                    self.diceView4.layer.sublayerTransform = perspective;
                    break;
                    
                default:
                    break;
            }
        }
        
    }else{
        [self.timer2 setFireDate:[NSDate distantFuture]];
        self.thetag = 0;
    }
}


#pragma mark - 作弊操作
- (void)zuobi:(int)point
{
    [self.player stop];
    [self.player play];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    int num = (arc4random() % 5);
    int thesj = (arc4random() % 4);
    self.sjFour = thesj;
    self.chooseNum = num;
    self.chooseValue = point;
    self.thetag = 1;
    self.theNum = 0.1;

    [self performSelector:@selector(endTimer3Action) withObject:nil afterDelay:1.5];

    [self.timer3 setFireDate:[NSDate distantFuture]];
    [self.timer3 setFireDate:[NSDate distantPast]];

    
}

- (void)timer3Action
{
    self.theNum += 0.25;
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0/500.0;
    
    perspective = CATransform3DRotate(perspective, self.theNum, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 1, 0);
    perspective = CATransform3DRotate(perspective, self.theNum, 0, 0, 1);
    
    perspective = CATransform3DTranslate(perspective, 0, 0, 25);
    
    switch (self.chooseNum) {
        case 0:
            self.diceView.layer.sublayerTransform = perspective;
            break;
        case 1:
            self.diceView1.layer.sublayerTransform = perspective;
            break;
        case 2:
            self.diceView2.layer.sublayerTransform = perspective;
            break;
        case 3:
            self.diceView3.layer.sublayerTransform = perspective;
            break;
        case 4:
            self.diceView4.layer.sublayerTransform = perspective;
            break;
            
        default:
            break;
    }
    
    
}

- (void)endTimer3Action
{
    self.theNum = 0;
    self.Num1 = M_PI_4;

    [self.timer3 setFireDate:[NSDate distantFuture]];
    [self.timer4 setFireDate:[NSDate distantFuture]];
    [self.timer4 setFireDate:[NSDate distantPast]];

}


- (void)timer4Action
{
    self.Num1 = self.Num1 - 0.025;
    
    if (self.Num1 > 0) {
        
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/500.0;
        switch (self.chooseValue) {
            case 0:
            {
                // 1 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * self.sjFour -self.Num1, 0, 0, 1);
            }
                break;
            case 1:
            {
                // 2 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * self.sjFour - self.Num1, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_2 - self.Num1, 0, 0, 1);
                
            }
                break;
            case 2:
            {
                // 3 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * 2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * self.sjFour , 0, 1, 0);
                perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                
            }
                break;
            case 3:
            {
                // 4 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1 + M_PI_2 * self.sjFour, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, - self.Num1, 0, 0, 1);
                
            }
                break;
            case 4:
            {
                // 5 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_4 + M_PI_2 * self.sjFour - self.Num1, 0, 1, 0);
                perspective = CATransform3DRotate(perspective, -M_PI_2 - self.Num1, 0, 0, 1);
                
            }
                break;
            case 5:
            {
                // 6 的情况
                perspective = CATransform3DRotate(perspective, -M_PI_4 - M_PI_2 - self.Num1, 1, 0, 0);
                perspective = CATransform3DRotate(perspective, -self.Num1 , 0, 1, 0);
                perspective = CATransform3DRotate(perspective, M_PI_4 + M_PI_2 * self.sjFour -self.Num1, 0, 0, 1);
            }
                break;
                
            default:
                break;
        }
        
        perspective = CATransform3DTranslate(perspective, 0, 0, 25 );
        switch (self.chooseNum) {
            case 0:
                self.diceView.layer.sublayerTransform = perspective;
                break;
            case 1:
                self.diceView1.layer.sublayerTransform = perspective;
                break;
            case 2:
                self.diceView2.layer.sublayerTransform = perspective;
                break;
            case 3:
                self.diceView3.layer.sublayerTransform = perspective;
                break;
            case 4:
                self.diceView4.layer.sublayerTransform = perspective;
                break;
                
            default:
                break;
        }
    }else{
        [self.timer4 setFireDate:[NSDate distantFuture]];
        self.thetag = 0;
    }
}

@end
