//
//  BeeThreeDiceContentView.h
//  6个六斋
//
//  Created by Ji_YuFeng on 2018/2/6.
//  Copyright © 2018年 GD_Bee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HideActionBlock)();

@interface BeeThreeDiceContentView : UIView

@property (nonatomic,copy)HideActionBlock hideBlock;

- (void)shakingAction;

@end
