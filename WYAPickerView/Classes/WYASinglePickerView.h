//
//  WYASinglePickerView.h
//  WYAPickerView_Example
//
//  Created by 李世航 on 2018/7/20.
//  Copyright © 2018年 1228506851@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleDelegate <NSObject>

- (void)singleWithResultString:(NSString *)result;

@end

@interface WYASinglePickerView : UIView

@property (nonatomic, weak)   id <SingleDelegate> delegate;

@property (nonatomic, strong) NSArray * dataSource;

- (void)show;

@end
