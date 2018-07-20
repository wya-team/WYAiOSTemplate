//
//  WYAViewController.m
//  WYAPickerView
//
//  Created by 1228506851@qq.com on 07/19/2018.
//  Copyright (c) 2018 1228506851@qq.com. All rights reserved.
//

#import "WYAViewController.h"
#import "WYAAddressPickerView.h"
@interface WYAViewController ()

@property (nonatomic, strong) WYAAddressPickerView * pickerView;

@end

@implementation WYAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)ssdad:(id)sender {
    self.pickerView = [[WYAAddressPickerView alloc]init];

    [self.pickerView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
