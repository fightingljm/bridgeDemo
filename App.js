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
