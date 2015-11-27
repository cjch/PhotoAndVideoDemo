//
//  ViewController.m
//  PhotoAndVideoDemo
//
//  Created by jiechen on 15/11/26.
//  Copyright © 2015年 jiechen. All rights reserved.
//

#import "ViewController.h"
#import "PVPickerViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pickerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"PhotoAndVideo";
    
    [self.pickerButton addTarget:self action:@selector(onPickerButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onPickerButton
{
    PVPickerViewController *pvc = [PVPickerViewController getInstance];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
