//
//  DeviceType.swift
//  LQDNews
//
//  Created by Mohanraj on 17/03/26.
//


import SwiftUI



var deviceType: DeviceType {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return .phone
    case .pad:
        return .pad
    case .mac:
        return .mac
    default:
        return .unknown
    }
}


enum DeviceType {
    case phone
    case pad
    case mac
    case unknown
}
