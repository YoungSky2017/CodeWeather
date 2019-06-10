//
//  DetailTableViewCell.h
//  CodeWeather
//
//  Created by 杨奇 on 2019/5/26.
//  Copyright © 2019 杨奇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailTableViewCell : UITableViewCell<CLLocationManagerDelegate>
@property (nonatomic, strong, readwrite) UILabel *CityLabel;
@property (nonatomic, strong, readwrite) UILabel *WeatherCaseLabel;
@property (nonatomic, strong, readwrite) UILabel *TemptureLabel;
@property (nonatomic, strong, readwrite) UILabel *DateLabel;
@property (nonatomic, strong, readwrite) UILabel *weekLabel;
@property (nonatomic, strong, readwrite) UILabel *TemptureDuLabel;
@property (nonatomic, strong, readwrite) UILabel *noticeLabel;

@property (nonatomic, strong, readwrite) UIImageView *WeatherImage;

@property (nonatomic, strong, readwrite) CLLocationManager *mgr;

@property (weak, nonatomic) NSString *cityNetAdress;
@property (retain, nonatomic) NSString *CityCode;

@end
