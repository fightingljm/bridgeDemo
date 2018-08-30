//
//  RCTBDMapManager.m
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RCTBDMapManager.h"
#import "RCTBDMap.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/UIView+React.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h> // 引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h> // 引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h> // 引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h> // 引入检索功能所有的头文件


@interface RCTBDMapManager()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
  BMKLocationService *_locService;
  BMKGeoCodeSearch *_searcher;
}
@property (strong, nonatomic) RCTBDMap *mapView;
@end

@implementation RCTBDMapManager

RCT_EXPORT_MODULE()


- (UIView *)view {
  //初始化BMKLocationService
  if (_locService == nil) {
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    // 距离筛选器
    _locService.distanceFilter = 10;
    
    // 定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
  }
  
  if (_mapView == nil) {
    _mapView = [RCTBDMap new];
    _mapView.delegate = self;
    // 设置地图类型
    [_mapView setMapType:BMKMapTypeStandard];
    // 普通定位模式
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    // 设置缩放比例 3-20
    _mapView.zoomLevel = 15;  
  }
  return _mapView;
}

RCT_EXPORT_VIEW_PROPERTY(pitchEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(annotations, NSArray<BMKPointAnnotation *>)

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
  // 普通态
  // 以下_mapView为BMKMapView对象
  _mapView.showsUserLocation = YES;//显示定位图层
  [_mapView updateLocationData:userLocation];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
  NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
  
  // 普通态
  // 以下_mapView为BMKMapView对象
  _mapView.showsUserLocation = YES;//显示定位图层
  [_mapView updateLocationData:userLocation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
  if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    return newAnnotationView;
  }
  return nil;
}

@end
