//
//  ByPromptResponseModel.swift
//  LoudAIModel
//
//  Created by Er Baghdasaryan on 10.04.25.
//
import Foundation

// MARK: - ByPromptResponseModel
public struct ResponseModel: Codable {
    public let id: UUID
    public let error: String?
    public let items: [LoadedMusicModel]
}

// MARK: - LoadedMusicModel
public struct LoadedMusicModel: Codable {
    public let id: Int
    public let title, musicURL: String

    public enum CodingKeys: String, CodingKey {
        case id, title
        case musicURL = "music_url"
    }
}
