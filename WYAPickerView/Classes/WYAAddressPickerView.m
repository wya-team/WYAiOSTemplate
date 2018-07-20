//
//  WYAPickerView.m
//  WYAPickerView_Example
//
//  Created by 李世航 on 2018/7/19.
//  Copyright © 2018年 1228506851@qq.com. All rights reserved.
//

#import "WYAAddressPickerView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Window                  ([UIApplication sharedApplication].keyWindow)
@interface WYAAddressPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIView * titleView;

@property (nonatomic, strong) UIPickerView * pickView;

@property (nonatomic, strong) UIButton * cancelButton;

@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSDictionary * addressDic;

@property (nonatomic, strong) NSArray * provinces;
@property (nonatomic, strong) NSArray * citys;
@property (nonatomic, strong) NSArray * areas;
@property (nonatomic, copy)   NSString * p;
@property (nonatomic, copy)   NSString * c;
@property (nonatomic, copy)   NSString * a;
@end

@implementation WYAAddressPickerView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
        [self.titleView addSubview:self.cancelButton];
        [self.titleView addSubview:self.sureButton];
        [self.titleView addSubview:self.titleLabel];
        [self.contentView addSubview:self.titleView];
        [self.contentView addSubview:self.pickView];
        [self addSubview:self.contentView];
        
        CGFloat pickerHeight = 220.0;
        CGFloat titleHeight = 50.0;
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, titleHeight+pickerHeight);
        self.titleView.frame = CGRectMake(0, 0, ScreenWidth, titleHeight);
        
        self.cancelButton.frame = CGRectMake(5, (titleHeight-30)/2, 40, 30);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame)+10, (titleHeight-30)/2, ScreenWidth-CGRectGetMaxX(self.cancelButton.frame)-30-40, 30);
        self.sureButton.frame = CGRectMake(ScreenWidth-45, (titleHeight-30)/2, 40, 30);
        
        
        self.pickView.frame = CGRectMake(0, titleHeight, ScreenWidth, pickerHeight);
        
        
        
        
        [Window addSubview:self];
        [Window bringSubviewToFront:self];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Frameworks/WYAPickerView.framework/WYAPickerView.bundle/address" ofType:@"json"];
        self.addressDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic==%@",self.addressDic);
        
        
        self.provinces = self.addressDic[@"province"];
        
        NSDictionary * dic = [self.provinces firstObject];
        self.p = dic[@"name"];
        self.citys = dic[@"city"];
        NSDictionary * cityDic = [self.citys firstObject];
        self.c = cityDic[@"name"];
        self.areas = cityDic[@"district"];
        NSDictionary * areaDic = [self.areas firstObject];
        self.a = areaDic[@"name"];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.p,self.c,self.a];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.provinces.count;
    }else if (component == 1) {
        return self.citys.count;
    }else{
        return self.areas.count;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return ScreenWidth/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        NSDictionary * dic = self.provinces[row];
        self.citys = dic[@"city"];
        self.p = dic[@"name"];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        NSDictionary * cityDic = [self.citys firstObject];
        self.areas = cityDic[@"district"];
        self.c = cityDic[@"name"];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        NSDictionary * areaDic = [self.areas firstObject];
        self.a = areaDic[@"name"];
    }else if (component == 1) {
        NSDictionary * dic = self.citys[row];
        self.areas = dic[@"district"];
        self.c = dic[@"name"];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        NSDictionary * areaDic = [self.areas firstObject];
        self.a = areaDic[@"name"];
    }else{
        NSDictionary * areaDic = self.areas[row];
        self.a = areaDic[@"name"];
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.p,self.c,self.a];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.pickView.frame.size.height+self.titleView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressWithProvince:City:Area:)]) {
        [self.delegate addressWithProvince:self.p City:self.c Area:self.a];
        [self cancelClick];
    }
}

- (void)show{
    [self.pickView reloadAllComponents];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight-self.pickView.frame.size.height-self.titleView.frame.size.height, ScreenWidth, self.pickView.frame.size.height+self.titleView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}





- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSDictionary * dic = self.provinces[row];
        NSString * string = dic[@"name"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:string];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, string.length)];//设置不起作用
        return att;
    }else if (component == 1) {
        NSDictionary * dic = self.citys[row];
        NSString * string = dic[@"name"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:string];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:5] range:NSMakeRange(0, string.length)];
        return att;
    }else{
        NSDictionary * dic = self.areas[row];
        NSString * string = dic[@"name"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:string];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:5] range:NSMakeRange(0, string.length)];
        return att;
    }
}
/*
 - (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
 
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED;
*/

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

-(UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = [UIColor blackColor].CGColor;
        _cancelButton.layer.cornerRadius = 4;
        _cancelButton.layer.masksToBounds = YES;
    }
    return _cancelButton;
}

-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.layer.borderWidth = 0.5;
        _sureButton.layer.borderColor = [UIColor blackColor].CGColor;
        _sureButton.layer.cornerRadius = 4;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
