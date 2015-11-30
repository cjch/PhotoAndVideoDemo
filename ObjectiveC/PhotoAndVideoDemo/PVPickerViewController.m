//
//  PVPickerViewController.m
//  PhotoAndVideoDemo
//
//  Created by jiechen on 15/11/27.
//  Copyright © 2015年 jiechen. All rights reserved.
//

#import "PVPickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PVPickerViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *captureModeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraDeviceControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *CameraFlashControl;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation PVPickerViewController

+ (instancetype)getInstance
{
    PVPickerViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ImagePicker";
    [self.startButton addTarget:self action:@selector(showSystemPicker) forControlEvents:UIControlEventTouchUpInside];
    self.photoImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)showSystemPicker
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    self.picker.sourceType = self.sourceTypeControl.selectedSegmentIndex;
    if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.picker.cameraCaptureMode = self.captureModeControl.selectedSegmentIndex;
        self.picker.cameraDevice = self.cameraDeviceControl.selectedSegmentIndex;
        self.picker.cameraFlashMode = self.CameraFlashControl.selectedSegmentIndex;
    }
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)onSave
{
    [self.picker takePicture];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *originImage = info[UIImagePickerControllerOriginalImage];
        UIImage *cropedImage = info[UIImagePickerControllerEditedImage];
        self.photoImageView.image = cropedImage ?: originImage;
        UIImageWriteToSavedPhotosAlbum(cropedImage ?: originImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else {
        NSURL *videoPath = info[UIImagePickerControllerMediaURL];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath.path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel capture");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"save image error: %@", error.description);
    } else {
        NSLog(@"save image successfully");
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"save video error: %@", error.description);
    } else {
        NSLog(@"save video successfully");
    }
}

#pragma mark - getter
- (UIImagePickerController *)picker
{
    if (_picker) {
        return _picker;
    }
    
    _picker = [[UIImagePickerController alloc]init];
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //    pvc.mediaTypes =@[(NSString *)kUTTypeImage];
    _picker.mediaTypes = availableTypes;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    _picker.allowsEditing = YES;

    _picker.showsCameraControls = NO;
    _picker.cameraOverlayView = self.customView;
    
    _picker.delegate = self;
    
    return _picker;
}

- (UIView *)customView
{
    CGFloat height = 80;
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height)];
    cView.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 20, 40, 40);
    button.backgroundColor = [UIColor redColor];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    [cView addSubview:button];
    return cView;
}

@end
