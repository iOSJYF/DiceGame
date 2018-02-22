# DiceGame
项目使用了cocospod，又设置了忽略文件，所以下载的时候请自行 pod install 一下 <br>
项目主要利用CATransform3DRotate改变view的perspective来实现骰子的3D旋转功能，再进行随机数来达到摇骰子的功能<br>


实现思路
------
首先，一个骰子为一个View，分别set 6张图片，然后分别设置对应的的CATransform3D <br>
eg: <br>
```object-c
- (UIView *)view1
{
    if (!_view1) {
        _view1 = [[UIView alloc]init];        
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
```
```object-c
[self addSubview:self.view1];
[self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.top.bottom.mas_equalTo(0);
}];
CATransform3D viewTrans = CATransform3DIdentity;
viewTrans = CATransform3DRotate(view2Trans, M_PI_2, 0, 1, 0);
viewTrans = CATransform3DTranslate(view2Trans, theWidth/2, 0, -theWidth/2);
self.view1.layer.transform = viewTrans;
```
最重要的，记得吧骰子所在的view的M34属性设置一下，才能看到3D效果
```object-c
CATransform3D perspective = CATransform3DIdentity;
perspective.m34 = -1.0/500.0;
self.layer.sublayerTransform = perspective;
```
在controller初始化骰子所在的view（diceview）的时候，记得设置一下3d角度，便于观察
```object-c
CATransform3D perspective1 = CATransform3DIdentity;
perspective1.m34 = -1/500;
perspective1 = CATransform3DRotate(perspective1, -M_PI_4 + M_PI_2, 1, 0, 0);
perspective1 = CATransform3DRotate(perspective1, -M_PI_4, 0, 0, 1);
perspective1 = CATransform3DTranslate(perspective1, 0, 0, 25);
self.diceView.layer.sublayerTransform = perspective1;
```
然后点击的时候，创建了一个timer，让CATransform3DRotate改变，从而达到骰子3D翻转的效果
```object-c
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
```
再次点击的时候创建先停止之前的timer，然后做另外一个timer的Action，一开始脑子没转过来，总是想着让骰子摇到特定的角度，后来思路一通，先是用随机数随机出一个数，然后再让骰子做动画听到那个点数
```object-c
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
```
最后有多个骰子存在的情况下，加了动画改进，让5个骰子做旋转动画，一开始想到的是用贝塞尔曲线实现，后来尝试
了一下利用CATransform3DRotate只改变Z的数值，发现这种方法也可行，然后再加上一个坐标往center的动画，效果出来就很炫酷了
```object-c
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
```
参考资料
------
具体的知识点可以参考 《核心动画高级技巧》
附上网址：https://www.gitbook.com/book/zsisme/ios-/details
