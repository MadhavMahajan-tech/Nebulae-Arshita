//
//  DataModel.swift
//  Nebulae1
//
//  Created by GEU on 07/02/26.
//

//
//  dailyWonderData.swift
//  Nebulae
//
//  Created by GEU on 05/02/26.
//

import Foundation

class DataModel: Codable {
    var dailyWonder: [DailyWonder] = []
    var spaceHistory: [SpaceHistory] = []
    init(){
        do{
            let response = try load()
            dailyWonder = response.dailyWonder
            spaceHistory = response.spaceHistory
            
        } catch {
            print(error)
        }
    }
    enum CodingKeys: String, CodingKey {
        case dailyWonder
        case spaceHistory
    }
    
}
extension DataModel {
    func load(from filename: String = "dailyWonder") throws -> DataModel {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "No file", code: 404, userInfo: [NSLocalizedDescriptionKey: "dailyWonder.json not found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        do{
            return try decoder.decode(DataModel.self, from: data)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    func decode(from data: Data) throws -> DataModel {
        let decoder = JSONDecoder()
            return try decoder.decode(DataModel.self, from: data)
    }
}
// This extension handles "Providing" the data to the app
extension DataModel {
    
    // Function to get the specific data for Today
    func getData() -> [DailyWonder] {
        return dailyWonder
    }
    func spaceHistoryData() -> [SpaceHistory] {
        return spaceHistory
    }
}
