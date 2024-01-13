//
//  MenuSceneViewModel.swift
//  IPTracker
//
//  Created by Dmitry Fedorov on 13.01.2024.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    @Published var ipAddressState: String
    @Published var lastUpdate: String
    
    private var fetcher = IPFetcher()
    private var cancellable: AnyCancellable?
    
    init() {
        ipAddressState = "Fetching..."
        lastUpdate = "Last update: never"
    }
    
    func startFetching() {
        cancellable = fetcher.$result.sink { [weak self] result in
            guard let self else { return }
            switch result {
            case .none:
                break
            case .success(let ipAddressData):
                ipAddressState = ipAddressData.ip
                lastUpdate = "Last update: \(ipAddressData.updateDate.formatted(date: .omitted, time: .standard))"
                print("new date: \(lastUpdate)")
            case .failure:
                ipAddressState = "Error"
            }
        }
        fetcher.startFetching()
    }
}
