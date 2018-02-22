//
//  BeeDiceView.m
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/1/24.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import "BeeDiceView.h"

@interface BeeDiceView ()

@property (nonatomic,strong)UIView *view1;
@property (nonatomic,strong)UIView *view2;
@property (nonatomic,strong)UIView *view3;
@property (nonatomic,strong)UIView *view4;
@property (nonatomic,strong)UIView *view5;
@property (nonatomic,strong)UIView *view6;

@end

@implementation BeeDiceView

- (UIView *)view1
{
    if (!_view1) {
        _view1 = [[UIView alloc]init];
//        _view1.backgroundColor = [UIColor blackColor];
        
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"one"]];
        img.layer.allowsEdgeAntialiasing = true;
        [_view1 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
        }];
    
        _view1.layer.borderWidth = 1;
        _view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view1.layer.cornerRadius = 3;
        
    }
    
    return _view1;

}

- (UIView *)view2
{
    if (!_view2) {
        _view2 = [[UIView alloc]init];
//        _view2.backgroundColor = [UIColor blackColor];
        
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"two"]];
        [_view2 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
            
        }];
        
        _view2.layer.borderWidth = 1;
        _view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view2.layer.cornerRadius = 3;

        
    }
    return _view2;
}

- (UIView *)view3
{
    if (!_view3) {
        _view3 = [[UIView alloc]init];
//        _view3.backgroundColor = [UIColor blackColor];
        
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"five"]];
        [_view3 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
        }];
        
        _view3.layer.borderWidth = 1;
        _view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view3.layer.cornerRadius = 3;

        
    }
    return _view3;
}

- (UIView *)view4
{
    if (!_view4) {
        _view4 = [[UIView alloc]init];
//        _view4.backgroundColor = [UIColor blackColor];
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"four"]];
        [_view4 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
        }];
        
        _view4.layer.borderWidth = 1;
        _view4.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view4.layer.cornerRadius = 3;

    }
    return _view4;
}

- (UIView *)view5
{
    if (!_view5) {
        _view5 = [[UIView alloc]init];
        _view5.backgroundColor = [UIColor blackColor];
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"three"]];
        [_view5 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
        }];
        
        _view5.layer.borderWidth = 1;
        _view5.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view5.layer.cornerRadius = 3;

    }
    return _view5;
}

- (UIView *)view6
{
    if (!_view6) {
        _view6 = [[UIView alloc]init];
//        _view6.backgroundColor = [UIColor blackColor];
        UIImageView *img = [[UIImageView alloc]init];
        [img setImage:[UIImage imageNamed:@"six"]];
        [_view6 addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0.3);
            make.bottom.right.mas_equalTo(-0.3);
        }];
        
        _view6.layer.borderWidth = 1;
        _view6.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _view6.layer.cornerRadius = 3;

    }
    return _view6;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = -1.0/500.0;
        self.layer.sublayerTransform = perspective;
        
        CGFloat theWidth = 50;
        
        [self addSubview:self.view1];
        [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        [self addSubview:self.view2];
        [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        CATransform3D view2Trans = CATransform3DIdentity;
        view2Trans = CATransform3DRotate(view2Trans, M_PI_2, 0, 1, 0);
        view2Trans = CATransform3DTranslate(view2Trans, theWidth/2, 0, -theWidth/2);
        self.view2.layer.transform = view2Trans;
        
        [self addSubview:self.view3];
        [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        CATransform3D view3Trans = CATransform3DIdentity;
        view3Trans = CATransform3DRotate(view3Trans, M_PI_2, 0, 1, 0);
        view3Trans = CATransform3DTranslate(view3Trans, theWidth/2, 0, theWidth/2);
        self.view3.layer.transform = view3Trans;
        
        [self addSubview:self.view4];
        [self.view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        CATransform3D view4Trans = CATransform3DIdentity;
        view4Trans = CATransform3DRotate(view4Trans, M_PI_2, 1, 0, 0);
        view4Trans = CATransform3DTranslate(view4Trans, 0, -theWidth/2, theWidth/2);
        self.view4.layer.transform = view4Trans;
        
        [self addSubview:self.view5];
        [self.view5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        CATransform3D view5Trans = CATransform3DIdentity;
        view5Trans = CATransform3DRotate(view5Trans, M_PI_2*3, 1, 0, 0);
        view5Trans = CATransform3DTranslate(view5Trans, 0, theWidth/2, theWidth/2);
        self.view5.layer.transform = view5Trans;
        
        [self addSubview:self.view6];
        [self.view6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        CATransform3D view6Trans = CATransform3DIdentity;
        view6Trans = CATransform3DRotate(view6Trans, M_PI, 0, 1, 0);
        view6Trans = CATransform3DTranslate(view6Trans, 0, 0, theWidth);
        self.view6.layer.transform = view6Trans;
        
        
        self.layer.allowsEdgeAntialiasing = YES;
        
    }
    return self;
}

- (UIImage *)antiAlias:(UIImageView *)imgView
{
    CGFloat border = 1.0f;
    CGRect rect = CGRectMake(border, border, imgView.image.size.width-2*border, imgView.image.size.height-2*border);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width,rect.size.height));
    [imgView.image drawInRect:CGRectMake(-1, -1, imgView.image.size.width, imgView.image.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(imgView.image.size);
    [img drawInRect:rect];
    UIImage* antiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return antiImage;
}




@end
