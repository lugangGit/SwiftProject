//
//  BaseCellDelegate.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/11.
//

import UIKit

/// 播放视频、关注、举报、删除
enum BaseCellEvent: Int {
    case playVideo
    case follow
    case discuss
    case report
    case delete
    case reportInner
    case deleteInner
    case reload
    case next
    case orginal
    case none
}

protocol BaseCellDelegate: AnyObject {
    func baseCell(cellForRowAt indexPath: IndexPath, event eventType: BaseCellEvent)
}
