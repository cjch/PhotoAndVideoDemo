//
//  PVPickerViewController.m
//  PhotoAndVideoDemo
//
//  Created by jiechen on 15/11/27.
//  Copyright © 2015年 jiechen. All rights reserved.
//

#import "PVPickerViewController.h"

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
    
    pvc.delegate = self;
    [self presentViewController:pvc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = info[UIImagePickerControllerMediaType];
    
    self.photoImageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel capture");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
