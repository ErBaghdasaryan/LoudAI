//
//  SavedMusicModel.swift
//  LoudAIModel
//
//  Created by Er Baghdasaryan on 25.03.25.
//

import UIKit

public struct SavedMusicModel {
    public let id: Int?
    public let genre: String
    public let subGenre: String
    public let duration: String
    public let musics: [LoadedMusicModel]

    public init(id: Int? = nil, genre: String, subGenre: String, duration: String, musics: [LoadedMusicModel]) {
        self.id = id
        self.genre = genre
        self.subGenre = subGenre
        self.duration = duration
        self.musics = musics
    }
}
