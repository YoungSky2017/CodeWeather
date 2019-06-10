//
//  DetailTableViewCell.m
//  CodeWeather
//
//  Created by 杨奇 on 2019/5/26.
//  Copyright © 2019 杨奇. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mgr = [[CLLocationManager alloc] init];
        if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.mgr requestWhenInUseAuthorization];
            self.mgr.delegate = self;
            [self.mgr startUpdatingLocation];
        } else {
            NSLog(@"请求定位失败。");
        }
        
        [self.contentView addSubview:({
            self.CityLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 150, 100)];
            self.CityLabel.font = [UIFont systemFontOfSize:40];
            self.CityLabel;
        })];
        
        [self.contentView addSubview:({
            self.WeatherCaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 150, 50)];
            self.WeatherCaseLabel.font = [UIFont systemFontOfSize:20];
            self.WeatherCaseLabel;
        })];
        
        [self.contentView addSubview:({
            self.TemptureLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 20, 160, 160)];
            self.TemptureLabel.font = [UIFont systemFontOfSize:120];
            
            [self.TemptureLabel addSubview:({
                [self Du];
                self.TemptureDuLabel;
            })];

            self.TemptureLabel;
        })];
        
        [self.contentView addSubview:({
            self.DateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 80, 50)];
            self.DateLabel;
        })];
        
        [self.contentView addSubview:({
            self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 220, 80, 50)];
            self.weekLabel;
        })];
        
        [self.contentView addSubview:({
            self.WeatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 220, 220)];
            self.WeatherImage.center = CGPointMake(190, 400);
            self.WeatherImage;
        })];
        
        [self.contentView addSubview:({
            self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 520, 350, 30)];
//            self.noticeLabel.backgroundColor = [UIColor grayColor];
            self.noticeLabel.textColor = [UIColor grayColor];
            self.noticeLabel.textAlignment = NSTextAlignmentCenter ;
            self.noticeLabel;
        })];
        
    }
    return self;
}

- (void) Du {
    self.TemptureDuLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, -30, 40, 80)];
    self.TemptureDuLabel.text = @"。";
    self.TemptureDuLabel.font = [UIFont systemFontOfSize:80];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9)) {
    CLLocation *location = locations.lastObject;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"simpleCityId" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for (CLPlacemark *placemark in placemarks)
        {
            //展示定位城市
            self.CityLabel.text = placemark.locality;
            NSDictionary *CityFromDict = [dictFromData valueForKey:placemark.locality];
            self.CityCode = [NSString stringWithFormat:@"%@",CityFromDict];
        }
        
        [self.mgr stopUpdatingLocation];
        
        
        self.cityNetAdress = [NSString stringWithFormat:@"http://t.weather.sojson.com/api/weather/city/%@",self.CityCode];;
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", self.cityNetAdress]];
//        NSLog(@"url:%@",url);
        
        NSData *dataFromURL = [NSData dataWithContentsOfURL:url];
//        NSLog(@"dataFromURL:%@",dataFromURL);
        
        NSDictionary *layer01FromData = [NSJSONSerialization JSONObjectWithData:dataFromURL options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"layer01FromData:%@",layer01FromData);
        
        NSDictionary *layer02FromData = layer01FromData[@"data"];
        
        //获取a当前日期
        NSDate  *currentDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        // NSInteger year=[components year];
        NSInteger month=[components month];
        NSInteger day=[components day];
        
        NSString *layer03FromData = layer02FromData[@"forecast"];
        
        //设置当前温度
        NSString *CurrentTempture = layer02FromData[@"wendu"];
        self.TemptureLabel.text = CurrentTempture;
        
        //设置天气提示
        NSArray *noticeStringArray = layer02FromData[@"forecast"];
        NSDictionary *noticeStringArray0 = noticeStringArray[0];
        NSString *noticeString = noticeStringArray0[@"notice"];
//        NSLog(@"noticeStr%@",noticeString);
        self.noticeLabel.text = noticeString;

        NSMutableArray *layer04FromDataToArray = [NSMutableArray new];
        [layer04FromDataToArray addObject:layer03FromData];
        NSDictionary *detailWeatherDict = layer04FromDataToArray[0][0];

        //设置日期
        self.DateLabel.text = [NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
        //设置天气状况
        self.WeatherCaseLabel.text = detailWeatherDict[@"type"];
        //设置星期几
        self.weekLabel.text = detailWeatherDict[@"week"];
        //设置天气图片
        NSString *imageNameKey = detailWeatherDict[@"type"];
        NSString *jsonWeatherCodePath = [[NSBundle mainBundle] pathForResource:@"weatherCodeList" ofType:@"json"];
        NSData *dataPic = [NSData dataWithContentsOfFile:jsonWeatherCodePath];
        NSDictionary *dictImageNAmeFromData = [NSJSONSerialization JSONObjectWithData:dataPic options:NSJSONReadingAllowFragments error:nil];
        NSString *imageNameValue = [dictImageNAmeFromData valueForKey: imageNameKey];
        self.WeatherImage.image = [UIImage imageNamed:imageNameValue];
         
    }];
    
}



@end
