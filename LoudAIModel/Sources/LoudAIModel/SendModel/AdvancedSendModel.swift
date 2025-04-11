//
//  AdvancedSendModel.swift
//  LoudAIModel
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import Foundation

// MARK: - AdvancedSendModel
public struct AdvancedSendModel: Codable {
    public let userID: String
    public let appBundle: String
    public let genre: String
    public let duration: Int
    public let instruments: [String]
    public let genreBlend: String
    public let energy: String
    public let structureID: Int
    public let bpm: Int
    public let keyRoot: String
    public let keyQuality: String

    public init(userID: String, appBundle: String, genre: String, duration: Int, instruments: [String], genreBlend: String, energy: String, structureID: Int, bpm: Int, keyRoot: String, keyQuality: String) {
        self.userID = userID
        self.appBundle = appBundle
        self.genre = genre
        self.duration = duration
        self.instruments = instruments
        self.genreBlend = genreBlend
        self.energy = energy
        self.structureID = structureID
        self.bpm = bpm
        self.keyRoot = keyRoot
        self.keyQuality = keyQuality
    }
}
