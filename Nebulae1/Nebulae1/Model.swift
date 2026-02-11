//
//  Model.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

import Foundation

struct DailyWonder: Codable {
    let date: String
    let neighbour_text: String
    let neighbour_title: String
    let fact_text: String
    let fact_title: String
    let fact_image_url: String
    
    
    enum CodingKeys: String, CodingKey {
      case date
        case neighbour_text
        case neighbour_title
        case fact_text
        case fact_title
        case fact_image_url
    }
    
}

struct SpaceHistory: Codable {
    let historyId: String
    let date: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case historyId = "history_id"
        case date
        case description
    }
}
