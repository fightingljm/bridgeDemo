//
//  RCTBDMap.m
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RCTBDMap.h"
#import <React/UIView+React.h>

@implementation RCTBDMap
  
- (void)setPitchEnabled:(BOOL)pitchEnabled {
  _pitchEnabled = pitchEnabled;
  NSLog(@"pitchEnable: %d", _pitchEnabled);
}
  
- (void)setAnnotations:(NSArray<BMKPointAnnotation *> *)annotations {
  for(NSArray *subArray in annotations) {
    NSLog(@"Array in myArray: %@",subArray);
  }
  [super addAnnotations:annotations];
}
  
  @end
