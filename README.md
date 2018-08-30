
## Start
```
$ react-native init bridgeDemo --verbose --version 0.52.3
```

## iOS Calendar Module Example

### Step 1

- 先使用Xcode打开,新建一个CalendarManager类,集成自NSObject即可.先在CalendarManager.h中导入相关类和实现协议RCTBridgeModule

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

- CalendarManager.m配置,为了实现该协议,需要含有一个宏:RCT_EXPORT_MODULE()

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

- react-native 通过NativeModules来实现传输和接受消息:

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

## Android Toast Module Example

### Step 1

- create a new Java Class named `ToastModule.java` inside `android/app/src/main/java/com/your-app-name/` folder with the content below:

```java
// ToastModule.java

package com.bridgedemo; // package com.your-app-name;

import android.widget.Toast;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.Map;
import java.util.HashMap;

public class ToastModule extends ReactContextBaseJavaModule {

    private static final String DURATION_SHORT_KEY = "SHORT";
    private static final String DURATION_LONG_KEY = "LONG";

    public ToastModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ToastExample";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DURATION_SHORT_KEY, Toast.LENGTH_SHORT);
        constants.put(DURATION_LONG_KEY, Toast.LENGTH_LONG);
        return constants;
    }

    @ReactMethod
    public void show(String message, int duration) {
        Toast.makeText(getReactApplicationContext(), message, duration).show();
    }
}
```

### Step 2

- create a new Java Class named `CustomToastPackage.java` inside `android/app/src/main/java/com/your-app-name/` folder with the content below:

```java
// CustomToastPackage.java

package com.bridgedemo; // package com.your-app-name;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CustomToastPackage implements ReactPackage {

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new ToastModule(reactContext));

        return modules;
    }

}
```

- 修改文件  android/app/src/main/java/com/your-app-name/MainApplication.java

```java
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new CustomToastPackage()); // <-- Add this line with your package name.
}
```

### Step3

- react-native 通过NativeModules来实现传输和接受消息

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
  NativeModules,
  TouchableOpacity
} from "react-native";

let CalendarManager = NativeModules.CalendarManager;
let ToastExample = NativeModules.ToastExample; // <-- Add this line

export default class App extends Component<{}> {
  // <-- Add this start
  componentDidMount(){
    if (Platform.OS==='android'){
      ToastExample.show("Awesome", ToastExample.SHORT);
    }
  }
  // <-- Add this end
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.passValueToNativeOne()}>点击往原生传字符串</Text>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.passValueToNativeTwo()}>点击往原生传字符串+字典</Text>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.passValueToNativeThree()}>点击往原生传字符串+日期</Text>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.callBackOne()}>点击调原生+回调</Text>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.callBackTwo()}>Promises</Text>
        <Text style={styles.welcome} onPress={() => Platform.OS==='ios' && this.useNativeValue()}>使用原生定义的常量</Text>
      </View>
    );
  }
}
```

## Android百度定位SDK 桥接 RN

### 申请认证成为百度开发者 
 
参考地址
`http://lbsyun.baidu.com/apiconsole/key`

### 下载基础开发包并导入android Studio 

参考地址
`http://lbsyun.baidu.com/index.php?title=sdk/download&action#selected=mapsdk_basicmap,mapsdk_searchfunction,mapsdk_lbscloudsearch,mapsdk_calculationtool,mapsdk_radar`

- 下载后的解压包里有一个叫libs的文件夹，将文件中的libs复制到项目中的App文件夹下，

- 打开APP文件夹下的build.Gradle,在加入如下代码.

```
android {
    .... 这是其他的代码,你别动它.这一行不需要,不要复制进来了.
    sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }
    }
}
```

- 打开AndroidManifest文件,在application标签中添加服务和ak秘钥.

```xml
<service
            android:name="com.baidu.location.f"
            android:enabled="true"
            android:process=":remote"></service>
        <meta-data
            android:name="com.baidu.lbsapi.API_KEY"
            android:value="xr*************q0Q1" />
```

- 添加权限

```xml
    <!-- 这个权限用于进行网络定位-->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"></uses-permission>
    <!-- 这个权限用于访问GPS定位-->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"></uses-permission>
    <!-- 用于访问wifi网络信息，wifi信息会用于进行网络定位--> 
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"></uses-permission>
    <!-- 获取运营商信息，用于支持提供运营商信息相关的接口-->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"></uses-permission>
    <!-- 这个权限用于获取wifi的获取权限，wifi信息会用来进行网络定位-->
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"></uses-permission>
    <!-- 用于读取手机当前的状态-->
    <uses-permission android:name="android.permission.READ_PHONE_STATE"></uses-permission>
    <!-- 写入扩展存储，向扩展卡写入数据，用于写入离线定位数据-->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"></uses-permission>
    <!-- 访问网络，网络定位需要上网-->
    <!-- SD卡读取权限，用户写入离线定位数据-->
    <uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"></uses-permission>
```

### 编写Native模块*

#### 创建原生模块

- 建一个中间访问对象 --- 新建一个BaiduLBS类继承ReactContextBaseJavaModule. 声明一个startLocation()的方法.供给RN调用,参数Callback是用于回调js的对象.我们再定位成功后要调用它.注意方法的上面必须加上 @ReactMethod注解.具体的调用定位请参考代码吧.然后重写GetName方法.return的值就是rn中调用的组件.

```java
// BaiduLBS.java

package com.bridgedemo;

import android.util.Log;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.Poi;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.List;

/**
 * author：Liujinmeng on 2018/8/29 13:14
 */
public class BaiduLBS  extends ReactContextBaseJavaModule {
    public LocationClient mLocationClient = null;
    private Callback locationCallback;
    
    @Override
    public String getName() {
        return "MyLBS";
    }
    
    public BaiduLBS(ReactApplicationContext reactContext) {
        super(reactContext);
    }
    @ReactMethod
    public void startLocation( Callback locationCallback) {
       this.locationCallback = locationCallback;
        mLocationClient = new LocationClient(getReactApplicationContext());     //声明LocationClient类
        mLocationClient.registerLocationListener(myListener);    //注册监听函数
        LocationClientOption option = new LocationClientOption();
        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy
        );//可选，默认高精度，设置定位模式，高精度，低功耗，仅设备
        option.setCoorType("bd09ll");//可选，默认gcj02，设置返回的定位结果坐标系
        int span = 0;
        option.setScanSpan(span);//可选，默认0，即仅定位一次，设置发起定位请求的间隔需要大于等于1000ms才是有效的
        option.setIsNeedAddress(true);//可选，设置是否需要地址信息，默认不需要
        option.setOpenGps(true);//可选，默认false,设置是否使用gps
        option.setLocationNotify(true);//可选，默认false，设置是否当gps有效时按照1S1次频率输出GPS结果
        option.setIsNeedLocationDescribe(true);//可选，默认false，设置是否需要位置语义化结果，可以在BDLocation.getLocationDescribe里得到，结果类似于“在北京天安门附近”
        option.setIsNeedLocationPoiList(true);//可选，默认false，设置是否需要POI结果，可以在BDLocation.getPoiList里得到
        option.setIgnoreKillProcess(false);//可选，默认true，定位SDK内部是一个SERVICE，并放到了独立进程，设置是否在stop的时候杀死这个进程，默认不杀死
        option.SetIgnoreCacheException(false);//可选，默认false，设置是否收集CRASH信息，默认收集
        option.setEnableSimulateGps(false);//可选，默认false，设置是否需要过滤gps仿真结果，默认需要
        mLocationClient.setLocOption(option);
        mLocationClient.start();
        Log.e("tag","ok");
    }

    /**
     * 定位回掉
     */
    public BDLocationListener myListener = new BDLocationListener() {
        @Override
        public void onReceiveLocation(final BDLocation bdLocation) {
            Log.e("TGA", "回掉+1");
            //Receive Location
            final StringBuffer sb = new StringBuffer(256);
            sb.append("time : ");
            sb.append(bdLocation.getTime());
            sb.append("\nerror code : ");
            sb.append(bdLocation.getLocType());
            sb.append("\nlatitude : ");
            sb.append(bdLocation.getLatitude());
            sb.append("\nlontitude : ");
            sb.append(bdLocation.getLongitude());
            sb.append("\nradius : ");
            sb.append(bdLocation.getRadius());
            if (bdLocation.getLocType() == BDLocation.TypeGpsLocation) {// GPS定位结果
                sb.append("\nspeed : ");
                sb.append(bdLocation.getSpeed());// 单位：公里每小时
                sb.append("\nsatellite : ");
                sb.append(bdLocation.getSatelliteNumber());
                sb.append("\nheight : ");
                sb.append(bdLocation.getAltitude());// 单位：米
                sb.append("\ndirection : ");
                sb.append(bdLocation.getDirection());// 单位度
                sb.append("\naddr : ");
                sb.append(bdLocation.getAddrStr());
                sb.append("\ndescribe : ");
                sb.append("gps定位成功");

            } else if (bdLocation.getLocType() == BDLocation.TypeNetWorkLocation) {// 网络定位结果
                sb.append("\naddr : ");
                sb.append(bdLocation.getAddrStr());
                //运营商信息
                sb.append("\noperationers : ");
                sb.append(bdLocation.getOperators());
                sb.append("\ndescribe : ");
                sb.append("网络定位成功");
            } else if (bdLocation.getLocType() == BDLocation.TypeOffLineLocation) {// 离线定位结果
                sb.append("\ndescribe : ");
                sb.append("离线定位成功，离线定位结果也是有效的");
            } else if (bdLocation.getLocType() == BDLocation.TypeServerError) {
                sb.append("\ndescribe : ");
                sb.append("服务端网络定位失败，可以反馈IMEI号和大体定位时间到loc-bugs@baidu.com，会有人追查原因");
            } else if (bdLocation.getLocType() == BDLocation.TypeNetWorkException) {
                sb.append("\ndescribe : ");
                sb.append("网络不同导致定位失败，请检查网络是否通畅");
            } else if (bdLocation.getLocType() == BDLocation.TypeCriteriaException) {
                sb.append("\ndescribe : ");
                sb.append("无法获取有效定位依据导致定位失败，一般是由于手机的原因，处于飞行模式下一般会造成这种结果，可以试着重启手机");
            }
            sb.append("\nlocationdescribe : ");
            sb.append(bdLocation.getLocationDescribe());// 位置语义化信息
            List<Poi> list = bdLocation.getPoiList();// POI数据
            if (list != null) {
                sb.append("\npoilist size = : ");
                sb.append(list.size());
                for (Poi p : list) {
                    sb.append("\npoi= : ");
                    sb.append(p.getId() + " " + p.getName() + " " + p.getRank());
                }
            }
            locationCallback.invoke(sb.toString());
        }
    };
}
```

- 建一个ReactPackage对象 --- 新建一个AnExampleReactPackage类实现ReactPackage接口.并在createNativeModules方法中加载BaiduLBS类.

```java
// AnExampleReactPackage.java

package com.bridgedemo;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class AnExampleReactPackage implements ReactPackage {

    // @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new BaiduLBS(reactContext));

        return modules;
    }
}
```

#### 注册模块

- 将ReactPackage对象加载到MainApplication中 --- 在MainApplication中的getPackages方法中添加AnExampleReactPackage.代码如下

```java
package com.bridgedemo;

import android.app.Application;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.facebook.soloader.SoLoader;

import java.util.Arrays;
import java.util.List;

public class MainApplication extends Application implements ReactApplication {

  private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
    @Override
    public boolean getUseDeveloperSupport() {
      return BuildConfig.DEBUG;
    }

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new CustomToastPackage(),
          new AnExampleReactPackage() // Add this line
      );
    }

    @Override
    protected String getJSMainModuleName() {
      return "index";
    }
  };

  @Override
  public ReactNativeHost getReactNativeHost() {
    return mReactNativeHost;
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SoLoader.init(this, /* native exopackage */ false);
  }
}
```

### React-Native调用Native模块*

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
  NativeModules,
  TouchableOpacity
} from "react-native";

let MyLBS = NativeModules.MyLBS;

export default class App extends Component<{}> {
  state = {
    location: null,
  }
  componentDidMount(){
    if (Platform.OS==='android'){
      MyLBS.startLocation((location) => {
        this.setState({ location: location })
      });
    }
  }
  render() {
    const { location } = this.state
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          {
            location ? location : 'ios location or cancel'
          }
        </Text>
      </View>
    );
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

### Run起来

- 执行命令

```
$ react-native run-android
```

- result

```
time : 2018-08-29 14:42:39
error code : 161
latitude : 39.118968
lontitude : 117.223268
radius : 40.0
addr : 中国天津市河西区曲阜道85号
operationers : 0
describe : 网络定位成功
locationdescribe : 在富力中心附近
poilist size = : 5
poi= : 15699082498546487215 富力中心 0.99
poi= : 17993935520052281343 亚太大厦 0.99
poi= : 11610384699328539360 富力中心-A座 0.99
poi= : 9890996776878967245 天津G公寓 0.99
poi= : 6858514465372782229 天津国际贸易中心-B座 0.99
```


参考地址：
- https://www.jianshu.com/p/aeaf6951a0b8
- https://www.jianshu.com/p/670bbad853f6

