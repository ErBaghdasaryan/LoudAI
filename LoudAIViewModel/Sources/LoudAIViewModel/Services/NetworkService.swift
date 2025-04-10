//
//  NetworkService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import LoudAIModel
import Combine

public protocol INetworkService {
    func createByPromptRequest(userId: String, appBundle: String, prompt: String) async throws -> ByPromptResponseModel
}

public final class NetworkService: INetworkService {

    public init() { }

    public func createByPromptRequest(userId: String, appBundle: String, prompt: String) async throws -> ByPromptResponseModel {
        guard let url = URL(string: "https://backend.codecraftedsolutionss.shop/api/task/text") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("4cf2e553-c8ad-4331-8ed0-0762aacd09c8", forHTTPHeaderField: "api-token")

        var body: [String: Any] = [:]
        body["user_id"] = userId
        body["app_bundle"] = appBundle
        body["prompt"] = prompt

        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, _) = try await URLSession.shared.data(for: request)
        if let jsonString = String(data: data, encoding: .utf8) {
                print("Ответ от сервера: \(jsonString)")
            }
        let result = try JSONDecoder().decode(ByPromptResponseModel.self, from: data)
        return result
    }

}
