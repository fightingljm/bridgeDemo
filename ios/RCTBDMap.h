//
//  RCTBDMap.h
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h> // 引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>   // 引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationService.h>

#import <React/RCTComponent.h>
@interface RCTBDMap : BMKMapView

@property(nonatomic, assign) BOOL pitchEnabled;
@property(nonatomic, copy) NSArray<BMKPointAnnotation *> *annotations;

@end
