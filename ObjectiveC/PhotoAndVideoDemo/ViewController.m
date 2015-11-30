//
//  ViewController.m
//  PhotoAndVideoDemo
//
//  Created by jiechen on 15/11/26.
//  Copyright © 2015年 jiechen. All rights reserved.
//

#import "ViewController.h"
#import "PVPickerViewController.h"
#import "AVFoundationViewController.h"

@interface ViewController ()

- (IBAction)onImagePicker:(UIButton *)sender;
- (IBAction)onAVFoundation:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"PhotoAndVideo";
}

- (IBAction)onImagePicker:(UIButton *)sender {
    PVPickerViewController *pvc = [PVPickerViewController getInstance];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)onAVFoundation:(UIButton *)sender {
    AVFoundationViewController *avc = [AVFoundationViewController getInstance];
    [self.navigationController pushViewController:avc animated:YES];
}

@end
