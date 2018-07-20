//
//  WYAPickerView.h
//  WYAPickerView_Example
//
//  Created by 李世航 on 2018/7/19.
//  Copyright © 2018年 1228506851@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressDelegate <NSObject>

-(void)addressWithProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area;

@end

@interface WYAAddressPickerView : UIView

@property (nonatomic, weak)   id <AddressDelegate> delegate;

- (void)show;

@end
