//
//  TTLock.m
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/29.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "TTLock.h"
#import <TTLock/TTLock.h>

@implementation TTLock
  
  RCT_EXPORT_MODULE();
  
  RCT_EXPORT_METHOD(initTTLock){
    TTLock *TTObject = [[TTLock alloc]initWithDelegate:self];
  }
  
  @end
