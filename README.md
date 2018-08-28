
### Start
```
$ react-native init bridgeDemo --verbose --version 0.52.3
```

### Step 1
先使用Xcode打开,新建一个CalendarManager类,集成自NSObject即可.先在CalendarManager.h中导入相关类和实现协议RCTBridgeModule

```c
//
//  CalendarManager.h
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>

@interface CalendarManager : NSObject <RCTBridgeModule>
@end
```

### Step 2
CalendarManager.m配置,为了实现该协议,需要含有一个宏:RCT_EXPORT_MODULE()

```java
//
//  CalendarManager.m
//  bridgeDemo
//
//  Created by wolf_liu on 2018/8/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "CalendarManager.h"

@implementation CalendarManager

RCT_EXPORT_MODULE();

// 接收传过来的 NSString
RCT_EXPORT_METHOD(addEventOne:(NSString *)name){
  // NSLog(@"接收传过来的NSString+NSString: %@", name);
  RCTLogInfo(@"接收传过来的NSString+NSString: %@", name);
}
// 接收传过来的 NSString + NSDictionary
RCT_EXPORT_METHOD(addEventTwo:(NSString *)name details:(NSDictionary *)details)
{
  RCTLogInfo(@"接收传过来的NSString+NSDictionary: %@ %@", name, details);
}

// 接收传过来的 NSString + date日期
RCT_EXPORT_METHOD(addEventThree:(NSString *)name date:(NSDate *)date)
{
   NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
   [formatter setDateFormat:@"yyyy-MM-dd"];
  RCTLogInfo(@"接收传过来的NSString+NSDictionary: %@ %@", name, [formatter stringFromDate:date]);
}

//  对外提供调用方法,演示Callback
RCT_EXPORT_METHOD(testCallbackEventOne:(NSString *)name callback:(RCTResponseSenderBlock)callback)
{
  NSLog(@"%@",name);
  NSArray *events=@[@"1", @"2", @"3",@"4"]; //准备回调回去的数据
  callback(@[[NSNull null],events]);
}

//Promises
//  对外提供调用方法,演示Promise使用
RCT_REMAP_METHOD(testCallbackEventTwo,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  NSArray *events =@[@"one ",@"two ",@"three"];//准备回调回去的数据
  if (events) {
    resolve(events);
  } else {
    NSError *error=[NSError errorWithDomain:@"我是Promise回调错误信息..." code:101 userInfo:nil];
    reject(@"no_events", @"There were no events", error);
  }
}

- (NSDictionary *)constantsToExport
{
  return @{ @"ValueOne": @"我是从原生定义的~" };
}

@end
```

### Step 3
CalendarManager.m配置,为了实现该协议,需要含有一个宏:RCT_EXPORT_MODULE()

```js
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  NativeModules
} from 'react-native';

let CalendarManager = NativeModules.CalendarManager;

export default class App extends Component<{}> {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome} onPress={() => this.passValueToNativeOne()}>点击往原生传字符串</Text>
        <Text style={styles.welcome} onPress={() => this.passValueToNativeTwo()}>点击往原生传字符串+字典</Text>
        <Text style={styles.welcome} onPress={() => this.passValueToNativeThree()}>点击往原生传字符串+日期</Text>
        <Text style={styles.welcome} onPress={() => this.callBackOne()}>点击调原生+回调</Text>
        <Text style={styles.welcome} onPress={() => this.callBackTwo()}>Promises</Text>
        <Text style={styles.welcome} onPress={() => this.useNativeValue()}>使用原生定义的常量</Text>
      </View>
    );
  }
  // 传原生一个字符串
  passValueToNativeOne = () => {
    CalendarManager.addEventOne('一个字符串');
  }
  // 传原生一个字符串 + 字典
  passValueToNativeTwo = () => {
    CalendarManager.addEventTwo('一个字符串 + 字典', { name: 'wolf_liu' });
  }
  // 传原生一个字符串 + 日期
  passValueToNativeThree = () => {
    CalendarManager.addEventThree("一个字符串 + 日期", 19950704);
  }
  // 传原生一个字符串 + 回调
  callBackOne = () => {
    CalendarManager.testCallbackEventOne(('我是RN给原生的'), (error, events) => {
      if (error) {
        console.error(error);
      } else {
        alert(events)
      }
    })
  }
  //Promise回调
  async callBackTwo() {
    try {
      var events = await CalendarManager.testCallbackEventTwo();
      alert(events)
    } catch (e) {
      console.error(e);
    }
  }
  //使用原生定义的常量
  useNativeValue = () => {
    alert(CalendarManager.ValueOne)
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  }
});
```