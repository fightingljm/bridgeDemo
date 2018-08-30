//
//  TTSpecialValueUtil.h
//  TTLockDemo
//
//  Created by TTLock on 17/4/20.
//  Copyright © 2017年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSpecialValueUtil : NSObject


/**
 Whether to support the password

 @param specialValue  characteristic value
 @return YES is supported, NO is unsupported
 */
+(BOOL)isSupportPwd:(long long)specialValue;
/**
 Whether the IC card is supported
 */
+(BOOL)isSupportIC:(long long)specialValue;
/**
 Whether the fingerPrints is supported
 */
+ (BOOL)isSupportFingerPrint:(long long)specialValue;
/**
 Whether the wristbands is supported
 */
+ (BOOL)isSupportWristband:(long long)specialValue;
/**
 Whether automatic locking is supported
 是否支持自动闭锁
 */
+ (BOOL)isSupportAutoLock:(long long)specialValue;
/**
 Whether or not to support a delete function password
 是否支持密码带删除功能
 */
+ (BOOL)isSupportPasswordDeleteFunction:(long long)specialValue;
/**
 Whether to support firmware upgrades
 是否支持固件升级
 */
+ (BOOL)isSupportUpgradeFirmware:(long long)specialValue;
/**
 Whether the password management function is supported
 是否支持密码管理功能
 */
+ (BOOL)isSupportPasswordManagement:(long long)specialValue;
/**
 Whether or not to support locking instructions
 是否支持闭锁指令
 */
+ (BOOL)isSupportLocking:(long long)specialValue;
/**
 Whether to support password display or hidden control
 是否支持密码显示或者隐藏的控制
 */
+ (BOOL)isSupportPasswordDisplayOrHideControl:(long long)specialValue;
/**
 Whether to support gateway unlocking instructions
 是否支持网关开锁指令
 */
+ (BOOL)isSupportGatewayUnlock:(long long)specialValue;
/**
 Whether to support the freezing and thawing of the gateway
 是否支持网关冻结、解冻
 */
+ (BOOL)isSupportGatewayFreezeAndUnfreeze:(long long)specialValue;
/**
 Whether the Cycle password is supported
 是否支持循环密码
 */
+ (BOOL)isSupportCyclePassword:(long long)specialValue;
/**
 Whether to support the door sensor
 是否支持门磁
 */
+ (BOOL)isSupportDoorSensor:(long long)specialValue;
/**
 Whether to support remote unlock switch control
 是否支持远程开锁开关控制
 */
+ (BOOL)isSupportRemoteUnlockSwicth:(long long)specialValue;
@end
