//
//  MenuSceneViewModel.swift
//  IPTracker
//
//  Created by Dmitry Fedorov on 13.01.2024.
//

import SwiftUI
import Combine

final class MenuSceneViewModel: ObservableObject {
    @Published var ipAddressState: String
    @Published var lastUpdate: String
    
    private var fetcher = IPFetcher()
    private var cancellable: AnyCancellable?
    
    init() {
        ipAddressState = String(localized: "fetching")
        lastUpdate = String(localized: "lastUpdate") + " " + String(localized: "never")
    }
    
    func startFetching() {
        cancellable = fetcher.$result.sink { [weak self] result in
            guard let self else { return }
            switch result {
            case .none:
                break
            case .success(let ipAddressData):
                ipAddressState = ipAddressData.ip
                let time = ipAddressData.updateDate.formatted(date: .omitted, time: .standard)
                lastUpdate = "\(String(localized: "lastUpdate")) \(time)"                
            case .failure:
                ipAddressState = "Error"
            }
        }
        fetcher.startFetching()
    }
}
