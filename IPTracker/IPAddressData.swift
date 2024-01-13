//
//  IPAddressData.swift
//  IPTracker
//
//  Created by Dmitry Fedorov on 13.01.2024.
//

import Foundation

struct IPAddressData: Decodable {
    let ip: String
    let updateDate: Date
    
    enum CodingKeys: CodingKey {
        case ip
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ip = try container.decode(String.self, forKey: .ip)
        self.updateDate = Date()
    }
}
