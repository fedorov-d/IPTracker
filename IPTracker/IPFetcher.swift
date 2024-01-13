//
//  IPFetcher.swift
//  IPTracker
//
//  Created by Dmitry Fedorov on 13.01.2024.
//

import Foundation

final class IPFetcher: ObservableObject {
    private let source = "https://api.ipify.org?format=json"
    private let urlSession = URLSession.shared
    
    @Published var result: Result<IPAddressData, Error>?
    
    func startFetching() {
        fetch()
    }
    
    private func fetch() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            var request = URLRequest(url: URL(string: source)!)
            request.timeoutInterval = 5.0
            do {
                let (data, response) = try await urlSession.data(for: request)
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("Did receive result: \(String(decoding: data, as: UTF8.self))")
                    let result = try JSONDecoder().decode(IPAddressData.self, from: data)
                    self.result = .success(result)
                }
            } catch {
                self.result = .failure(error)
                print("Error fetching data: \(error)")
            }
            try await Task.sleep(for: .seconds(3))
            fetch()
        }
    }
}
