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
    
    UIImagePickerController *pvc = [[UIImagePickerController alloc]init];
    NSArray *availableTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    pvc.mediaTypes = availableTypes;
    pvc.sourceType = self.sourceTypeControl.selectedSegmentIndex;
    if (pvc.sourceType == UIImagePickerControllerSourceTypeCamera) {
        pvc.cameraCaptureMode = self.captureModeControl.selectedSegmentIndex;
        pvc.cameraDevice = self.cameraDeviceControl.selectedSegmentIndex;
        pvc.cameraFlashMode = self.CameraFlashControl.selectedSegmentIndex;
    }
    pvc.allowsEditing = YES;
    pvc.delegate = self;
    [self presentViewController:pvc animated:YES completion:nil];
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

@end
