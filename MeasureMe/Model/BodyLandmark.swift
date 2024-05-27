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
    case shoulderStart
    case shoulderEnd
    case sleeveTop
    case sleeveBot
    case waistStart
    case waistEnd
    case bustStart
    case bustEnd
    case hipStart
    case hipEnd
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

struct Front: Codable {
    let shoulderStart    : Coordinate
    let shoulderEnd   : Coordinate
    let sleeveTop       : Coordinate
    let elbow           : Coordinate
    let sleeveBot       : Coordinate
    let waistStart      : Coordinate
    let waistEnd        : Coordinate
    let bustStart        : Coordinate
    let bustEnd       : Coordinate
    let hipStart         : Coordinate
    let hipEnd        : Coordinate
    let pantsTop        : Coordinate
    let knee            : Coordinate
    let pantsBot        : Coordinate
    let top             : Coordinate
    let bot             : Coordinate
    
    enum CodingKeys: String, CodingKey {
        case top            = "top_coords"
        case bot            = "bot_coords"
        case shoulderStart   = "shoulder_start_coords"
        case shoulderEnd  = "shoulder_end_coords"
        case sleeveTop      = "sleeve_top_coords"
        case sleeveBot      = "sleeve_bot_coords"
        case waistStart     = "waist_start_coords"
        case waistEnd       = "waist_end_coords"
        case bustStart       = "bust_start_coords"
        case bustEnd      = "bust_end_coords"
        case hipStart        = "hip_start_coords"
        case hipEnd       = "hip_end_coords"
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
            BodyLandmark(landmark: .shoulderStart, coordinate: shoulderStart.cgPoint),
            BodyLandmark(landmark: .shoulderEnd, coordinate: shoulderEnd.cgPoint),
            BodyLandmark(landmark: .sleeveTop, coordinate: sleeveTop.cgPoint),
            BodyLandmark(landmark: .elbow, coordinate: elbow.cgPoint),
            BodyLandmark(landmark: .sleeveBot, coordinate: sleeveBot.cgPoint),
            BodyLandmark(landmark: .waistStart, coordinate: waistStart.cgPoint),
            BodyLandmark(landmark: .waistEnd, coordinate: waistEnd.cgPoint),
            BodyLandmark(landmark: .bustStart, coordinate: bustStart.cgPoint),
            BodyLandmark(landmark: .bustEnd, coordinate: bustEnd.cgPoint),
            BodyLandmark(landmark: .hipStart, coordinate: hipStart.cgPoint),
            BodyLandmark(landmark: .hipEnd, coordinate: hipEnd.cgPoint),
            BodyLandmark(landmark: .pantsTop, coordinate: pantsTop.cgPoint),
            BodyLandmark(landmark: .knee, coordinate: knee.cgPoint),
            BodyLandmark(landmark: .pantsBot, coordinate: pantsBot.cgPoint),
            BodyLandmark(landmark: .top, coordinate: top.cgPoint),
            BodyLandmark(landmark: .bot, coordinate: bot.cgPoint),
        ]
    }
}

struct Side: Codable {
    let bustStart   : Coordinate
    let bustEnd  : Coordinate
    let waistStart : Coordinate
    let waistEnd   : Coordinate
    let hipStart    : Coordinate
    let hipEnd   : Coordinate
    let top        : Coordinate
    let bot        : Coordinate

    enum CodingKeys: String, CodingKey {
        case bustStart  = "bust_start_coords"
        case bustEnd    = "bust_end_coords"
        case waistStart = "waist_start_coords"
        case waistEnd   = "waist_end_coords"
        case hipStart   = "hip_start_coords"
        case hipEnd     = "hip_end_coords"
        case top        = "top_coords"
        case bot        = "bot_coords"
    }
}

// For retrieving all side body landmarks
extension Side {
    var allBodyLandmarks: [BodyLandmark] {
        return  [
            BodyLandmark(landmark: .bustStart, coordinate: bustStart.cgPoint),
            BodyLandmark(landmark: .bustEnd, coordinate: bustEnd.cgPoint),
            BodyLandmark(landmark: .waistStart, coordinate: waistStart.cgPoint),
            BodyLandmark(landmark: .waistEnd, coordinate: waistEnd.cgPoint),
            BodyLandmark(landmark: .hipStart, coordinate: hipStart.cgPoint),
            BodyLandmark(landmark: .hipEnd, coordinate: hipEnd.cgPoint),
            BodyLandmark(landmark: .top, coordinate: top.cgPoint),
            BodyLandmark(landmark: .bot, coordinate: bot.cgPoint),
        ]
    }
}

struct Coordinate: Codable {
    let x: Double
    let y: Double
}

extension Coordinate {
    var cgPoint: CGPoint {
        return CGPoint(x: x, y: y)
    }
}
