//
//  QRCodeViewController.m
//  CodeWeather
//
//  Created by 杨奇 on 2019/5/28.
//  Copyright © 2019 杨奇. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureDevice *device;            //捕获设备，默认后置摄像头
@property (nonatomic, strong) AVCaptureDeviceInput *input;        //输入设备
@property (nonatomic, strong) AVCaptureMetadataOutput *output;    //输出设备，需要指定他的输出类型及扫描范围
@property (nonatomic, strong) AVCaptureSession *session;          //AVFoundation框架捕获类的中心枢纽，协调输入输出设备以获得数据
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;  //展示捕获图像的图层，是CALayer的子类
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, retain) UIImageView *line;             //扫描动画线

@property (nonatomic, strong) UIButton *ScanButton;

@property(assign, nonatomic) BOOL                       isUp;
@property(strong, nonatomic) NSTimer                    *timer;

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define scanWidth           (SCREEN_WIDTH  - 120)
#define scanHeight          scanWidth
#define scanX               (SCREEN_WIDTH - scanWidth)/2
#define scanY               (SCREEN_HEIGHT - scanHeight)/2
@end

@implementation QRCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:({
        self.ScanButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 100, 30)];
        [self.ScanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
        self.ScanButton.backgroundColor = [UIColor blackColor];
        self.ScanButton;
    })];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self.ScanButton initView];
    [self.ScanButton addTarget:self action:@selector(initView) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setshapeLayer];
    [self.ScanButton addTarget:self action:@selector(setshapeLayer) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setupCamera];
    [self.ScanButton addTarget:self action:@selector(setupCamera) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initView{
    
    _isUp = NO;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(scanX, scanY, scanWidth, scanHeight)];
    imageView.image = [UIImage imageNamed:@"watch_sao_kuang"];
    [self.view addSubview:imageView];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(scanX, scanY+5, scanWidth, 2)];
    _line.image = [UIImage imageNamed:@"watch_sao_line"];
    [self.view addSubview:_line];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(repeatTime) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_timer setFireDate:[NSDate date]];
    [_session startRunning];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_session stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupCamera {
    AVCaptureDevice *device = [AVCaptureDevice   defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"摄像头未开启" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // Device （获取手机设备的硬件 —— 摄像头）
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input （获取手机摄像头的输入流设置）
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    // Output （获取手机摄像头的输出流设置）
    _output = [[AVCaptureMetadataOutput alloc]init];
    // 设置输出流协议 AVCaptureMetadataOutputObjectsDelegate
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session 硬件配置设置
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 加入硬件配置的输入输出流
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code];
    }
    
    // Preview
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新界面
        self.layer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.layer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self.view.layer insertSublayer:self.layer atIndex:0];
        // Start 开启摄像头运行
        [self.session startRunning];
    });
    
    //设置扫描区域
    CGFloat x = scanX/SCREEN_WIDTH;
    CGFloat y = scanY/SCREEN_HEIGHT;
    CGFloat width = scanWidth/SCREEN_WIDTH;
    CGFloat height = scanHeight/SCREEN_HEIGHT;
    //y 与 x 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(y,x, height, width)];
}

-(void)repeatTime
{
    
    CGRect rect = _line.frame;
    if (_isUp == NO) {
        
        rect.origin.y += 1;
        
        if (rect.origin.y >= scanY + scanHeight - 5 - rect.size.height)
        {
            _isUp = YES;
        }
    } else {
        rect.origin.y -= 1;
        
        if (rect.origin.y <= scanY + 5)
        {
            _isUp = NO;
        }
    }
    _line.frame = rect;
}

- (void)setshapeLayer{
    
    _shapeLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    //添加蒙版
    CGPathAddRect(path, nil, self.view.bounds);
    
    CGPathAddRect(path, nil, CGRectMake(scanX, scanY, scanWidth, scanHeight));
    
    //填充规则
    _shapeLayer.fillRule = kCAFillRuleEvenOdd;
    //绘制的路径
    _shapeLayer.path = path;
    //路径中的填充颜色
    _shapeLayer.fillColor = [UIColor blackColor].CGColor;
    //设置透明度
    _shapeLayer.opacity = 0.5;
    
    
    [_shapeLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:_shapeLayer];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    // 元数据对象
    if ([metadataObjects count] >0)
    {
        // 可读码对象
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        // 扫描成功后调用，解析二维码
        [_timer setFireDate:[NSDate distantFuture]];
        [_session stopRunning];
        
        NSLog(@"扫一扫结果:%@",stringValue);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.session != nil && self.timer != nil) {
                [self.session startRunning];
                [self.timer setFireDate:[NSDate date]];
            }
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
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
