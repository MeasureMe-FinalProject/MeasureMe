//
//  BodyLandmark.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 16/02/24.
//

import UIKit

// MARK: - Model
struct BodyLandmark: Identifiable {
    let id = UUID()
    let landmark: BodyLandmarkType
    var coordinate: CGPoint
}

enum BodyLandmarkType {
    case top
    case bot
    case shoulderLeft
    case shoulderRight
    case sleeveTop
    case sleeveBot
    case waistStart
    case waistEnd
    case bustLeft
    case bustRight
    case hipLeft
    case hipRight
    case pantsTop
    case pantsBot
    case elbow
    case knee
    
    var name: String {
        switch self {
        case .top:
            "Top"
        case .bot:
            "Bottom"
        default:
            ""
        }
    }
}

// MARK: - JSON Decoder
struct BodyLandmarkResponse: Decodable {
    let front: Front
    let side: Side
    let frontPath: String
    let sidePath: String
    
    enum CodingKeys: String, CodingKey {
        case front      = "front"
        case side       = "side"
        case frontPath  = "front_path"
        case sidePath   = "side_path"
    }
}

struct Front: Decodable {
    let top             : Coordinate
    let bot             : Coordinate
    let shoulderLeft    : Coordinate
    let shoulderRight   : Coordinate
    let sleeveTop       : Coordinate
    let sleeveBot       : Coordinate
    let waistStart      : Coordinate
    let waistEnd        : Coordinate
    let bustLeft        : Coordinate
    let bustRight       : Coordinate
    let hipLeft         : Coordinate
    let hipRight        : Coordinate
    let pantsTop        : Coordinate
    let pantsBot        : Coordinate
    let elbow           : Coordinate
    let knee            : Coordinate
    
    enum CodingKeys: String, CodingKey {
        case top            = "top_coords"
        case bot            = "bot_coords"
        case shoulderLeft   = "shoulder_left_coords"
        case shoulderRight  = "shoulder_right_coords"
        case sleeveTop      = "sleeve_top_coords"
        case sleeveBot      = "sleeve_bot_coords"
        case waistStart     = "waist_start_coords"
        case waistEnd       = "waist_end_coords"
        case bustLeft       = "bust_left_coords"
        case bustRight      = "bust_right_coords"
        case hipLeft        = "hip_left_coords"
        case hipRight       = "hip_right_coords"
        case pantsTop       = "pants_top_coords"
        case pantsBot       = "pants_bot_coords"
        case elbow          = "elbow_coords"
        case knee           = "knee_coords"
    }
}

// For retrieving all front body landmarks
extension Front {
    var allBodyLandmarks: [BodyLandmark] {
        [
            BodyLandmark(landmark: .top, coordinate: top.cgPoint),
            BodyLandmark(landmark: .bot, coordinate: bot.cgPoint),
            BodyLandmark(landmark: .shoulderLeft, coordinate: shoulderLeft.cgPoint),
            BodyLandmark(landmark: .shoulderRight, coordinate: shoulderRight.cgPoint),
            BodyLandmark(landmark: .sleeveTop, coordinate: sleeveTop.cgPoint),
            BodyLandmark(landmark: .sleeveBot, coordinate: sleeveBot.cgPoint),
            BodyLandmark(landmark: .waistStart, coordinate: waistStart.cgPoint),
            BodyLandmark(landmark: .waistEnd, coordinate: waistEnd.cgPoint),
            BodyLandmark(landmark: .bustLeft, coordinate: bustLeft.cgPoint),
            BodyLandmark(landmark: .bustRight, coordinate: bustRight.cgPoint),
            BodyLandmark(landmark: .hipLeft, coordinate: hipLeft.cgPoint),
            BodyLandmark(landmark: .hipRight, coordinate: hipRight.cgPoint),
            BodyLandmark(landmark: .pantsTop, coordinate: pantsTop.cgPoint),
            BodyLandmark(landmark: .pantsBot, coordinate: pantsBot.cgPoint),
            BodyLandmark(landmark: .elbow, coordinate: elbow.cgPoint),
            BodyLandmark(landmark: .knee, coordinate: knee.cgPoint),
        ]
    }
}

struct Side: Decodable {
    let top        : Coordinate
    let bot        : Coordinate
    let bustLeft   : Coordinate
    let bustRight  : Coordinate
    let waistStart : Coordinate
    let waistEnd   : Coordinate
    let hipLeft    : Coordinate
    let hipRight   : Coordinate

    enum CodingKeys: String, CodingKey {
        case top          = "top_coords"
        case bot          = "bot_coords"
        case bustLeft     = "bust_left_coords"
        case bustRight    = "bust_right_coords"
        case waistStart   = "waist_start_coords"
        case waistEnd     = "waist_end_coords"
        case hipLeft      = "hip_left_coords"
        case hipRight     = "hip_right_coords"
    }
    
    
}

// For retrieving all side body landmarks
extension Side {
    var allBodyLandmarks: [BodyLandmark] {
        return  [
            BodyLandmark(landmark: .top, coordinate: top.cgPoint),
            BodyLandmark(landmark: .bot, coordinate: bot.cgPoint),
            BodyLandmark(landmark: .bustLeft, coordinate: bustLeft.cgPoint),
            BodyLandmark(landmark: .bustRight, coordinate: bustRight.cgPoint),
            BodyLandmark(landmark: .waistStart, coordinate: waistStart.cgPoint),
            BodyLandmark(landmark: .waistEnd, coordinate: waistEnd.cgPoint),
            BodyLandmark(landmark: .hipLeft, coordinate: hipLeft.cgPoint),
            BodyLandmark(landmark: .hipRight, coordinate: hipRight.cgPoint)
        ]
    }
}

struct Coordinate: Decodable {
    let x: Double
    let y: Double
}

extension Coordinate {
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
