//
//  AVFoundationViewController.m
//  PhotoAndVideoDemo
//
//  Created by jiechen on 15/11/30.
//  Copyright © 2015年 jiechen. All rights reserved.
//

#import "AVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AVFoundationViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (IBAction)onStart:(UIButton *)sender;

@end

@implementation AVFoundationViewController

+ (instancetype)getInstance
{
    AVFoundationViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"AVFoundation";
    self.photoImageView.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)onStart:(UIButton *)sender {
    if ([self.captureSession isRunning]) {
        [self.captureSession stopRunning];
        NSLog(@"stop capture...");
        [sender setTitle:@"start" forState:UIControlStateNormal];
    } else {
        [self.captureSession startRunning];
        NSLog(@"start capture...");
        [sender setTitle:@"stop" forState:UIControlStateNormal];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"video frame was written");
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.photoImageView.image = image;
//    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"video frame is droped");
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace) {
        return nil;
    }
    
    void *baseAddr = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddr, bufferSize, NULL);
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

#pragma mark - getter
- (AVCaptureSession *)captureSession
{
    if (_captureSession) {
        return _captureSession;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    __block AVCaptureDevice *backDevice = nil;
    [devices enumerateObjectsUsingBlock:^(AVCaptureDevice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.position == AVCaptureDevicePositionBack) {
            backDevice = obj;
            *stop = YES;
        }
    }];
    if (backDevice == nil) {
        return nil;
    }
//    backDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:backDevice error:&error];
    if ([_captureSession canAddInput:cameraInput]) {
        [_captureSession addInput:cameraInput];
    } else {
        return nil;
    }
    
    // display method 1
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previewLayer.frame = self.photoImageView.frame;
    [self.view.layer addSublayer:previewLayer];
    
    // display method 2
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    [videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("com.jc.video.buffer.delegate", DISPATCH_QUEUE_SERIAL)];
    if ([_captureSession canAddOutput:videoOutput]) {
        [_captureSession addOutput:videoOutput];
    } else {
        return nil;
    }
    
    videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    
    return _captureSession;
}

@end
