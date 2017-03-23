//
//  NetworkAPIKeys.swift
//  DaQu
//
//  Created by 刘伟 on 9/1/16.
//  Copyright © 2016 上海凌晋信息技术有限公司. All rights reserved.
//

// http://120.26.139.127/api/Public/v1/checkApiParams.php

import Foundation

// MARK: =============== 登录 ===============
// 用户自动登录
let API_USER_AUTOSIGN = "User.AutoSign"
// 用户手机号登录
let API_USER_SIGN = "User.Sign"
// 发送验证码
let API_SMS_SENDSMSCODE = "Sms.SendSmsCode"
// 修改用户信息
let API_USER_UPDATEUSERINFO = "User.UpdateUserInfo"

// MARK: =============== 首页 ===============
// 获取附近充电站列表
//let API_CHARGINGSTATION_STATIONSAROUND = "ChargingStation.StationsAround"
// 获取某地图区域内
let API_CHARGINGSTATION_STATIONSBYREGION = "ChargingStation.StationsByRegion"
// 获取所有充电桩
let API_CHARGINGSTATION_FINDALL = "ChargingStation.FindAll"
// 获取充电桩详情
let API_CHARGINGSTATION_GETCSINFO = "ChargingStation.GetCSInfo"
// 获取充电桩过滤条件
let API_CHARGINGSTATION_GETCSFILTERKEYS = "ChargingStation.getCSFilterKeys"

// 添加收藏
let API_CHARGINGSTATION_ADDTOFAVORITE = "ChargingStation.AddToFavorite"
// 取消收藏
let API_CHARGINGSTATION_DELETEFROMFAVORITEO = "ChargingStation.DeleteFromFavorite"
// 我的收藏列表
let API_CHARGINGSTATION_MYFAVORITELIST = "ChargingStation.MyFavoriteList"

// MARK: =============== 我的 ===============
// 获取所有品牌列表
let API_CAR_CARBRANDLIST = "Car.CarBrandList"

// MARK: =============== Common ===============
// 上传文件
let API_FILE_UPLOAD = "File.Upload"
// 获取密钥
let API_SYSTEM_GETAESKEY = "System.GetAesKey"
// 版本更新
let API_SYSTEM_GETVERSION = "System.GetVersion"


