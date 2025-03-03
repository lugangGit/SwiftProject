//
//  AppJson.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/27.
//

import Foundation

var appMap: Dictionary<String, Any> = [
    "appName": "科技日报",
    //"isRelease": true,
    "isRelease": false,
    //"baseUrl": "https://appif-app.kjrb.com.cn/app_if/",
    //"baseUrl": "http://csappif.stdaily.com:8090/app_if/",
    "baseUrl": "https://api.rmdbw.cn/app_if/",
    /// 引导页
    "showGuide": true,
    /// 版本更新检测 用于开发阶段 默认应该是yes
    "detectVersionUpdates": true,
    /// 积分商城
    "scoreMall": true,
    /// 隐藏非本栏目tags
    "showColumnNameTags": false,
    /// 小视频轮播
    "smallVideoLoopPlay" : false,
    "appId": "1",
    "bigDataEnable": true,
    "registerPushTag": true,
    "getuiSn": "sn1",
    "bigData": [
        "test":[
            "baseUrl": "http://mbduser.newaircloud.com:8088/fzuba?project=26873&token=8efdd7f994c04dc182844aa4fed4fd37",
            "appId": "26873",
            "bid": "62449016-9612-4307-a410-dace7bf38bc3"
        ],
        "release":[
            "baseUrl": "http://mbduser.newaircloud.com/fzuba?project=26872&token=d57e9a54b8044ddb8c758c653e103e59",
            "appId": "26872",
            "bid": "eaeb530d-d440-4851-a8f8-7654bef46fdc"
        ]
    ],
    "appShare": [
        "appKey": "34fc3ef53d59d",
        "appSecret": "5a4bc7e437fcf9bddf009ca13c5f54f7",
        "universalLink": "https://b62e7d48eec989d9a3c18f66c7809e90.share2dlink.com/",
        "qq": [
          "appId": "1112091549",
          "appKey": "V63T9YGUJS0gp5Yk",
        ],
        "weibo": [
          "appKey": "488508977",
          "appSecret": "a06375f0b26a882dd1f27a7e2c43b4f9",
          "callbackUri": "http://stdaily.com/",
          "redirectUrl": "http://stdaily.com/",
          "universalLink": "https://b62e7d48eec989d9a3c18f66c7809e90.share2dlink.com/"
        ],
        "wechat": [
          "appId": "wx35ce774cd27eae84",
          "appSecret": "81ebb75359dca16a440778132b748ecf",
          "path": "https://b62e7d48eec989d9a3c18f66c7809e90.share2dlink.com/",
          "miniProgramId": ""
        ]
    ] as [String : Any],
    // 0是网站，1是触屏，2移动App，3分享页(只限稿件点赞)
    "channel": 2,
    // 进入详情页获取积分停留时间
    "articleDetailScoreTime": 5,
    // 限制字数
    "limitWords": 300,
    // 图片压缩比例
    "compressionQuality": 0.2,
    "downloadUrl": "https://a.app.qq.com/o/simple.jsp?pkgname=com.stdaily.app.kjrb",
    "ttsAppId": "3646fd06",
    "geTui": [
        "release":[
            "appId": "kSrPkfjM8x9tMHMepADO07",
            "appKey": "DOKMjeONTx8ZF3s6Oomni2",
            "appSecret": "AyVGDgMECD9ondRFF3opP5"
        ],
        "test":[
            "appId": "LNgZlQ8zEc9SZ5HNF21DT3",
            "appKey": "JLr06L4PEF73TN2uZWs6P3",
            "appSecret": "BNLluSOxIP9PESanNvH90A"
        ],
    ],
    "umeng":[
        "iosAppKey": "61c03b10e0f9bb492ba0e3da",
        "channel": "App Store",
    ],
    "jmlink":[
        "appKey": "923a8dbef603be39d1b154a9",
        "universalLink1": "bnw7cz.jgshare.cn",
        "universalLink2": "bnw7cz.jmlk.co",
    ],
]
