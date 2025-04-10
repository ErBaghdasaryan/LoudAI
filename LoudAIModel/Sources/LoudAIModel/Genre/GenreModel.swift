//
//  GenreModel.swift
//  LoudAIModel
//
//  Created by Er Baghdasaryan on 31.03.25.
//

import UIKit

public struct GenreModel {
    public let image: UIImage
    public let title: String
    public let subGenres: [String]

    public init(image: UIImage, title: String, subGenres: [String]) {
        self.image = image
        self.title = title
        self.subGenres = subGenres
    }
}
