//
//  GeneratorService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIModel

public protocol IGeneratorService {
    func getGenreItems() -> [GenreModel]
}

public class GeneratorService: IGeneratorService {

    public init() { }

    public func getGenreItems() -> [GenreModel] {
        [
            GenreModel(image: UIImage(named: "genre1")!,
                       title: "Ambient",
                       subGenres: ["Cinematic Atmospheres", "Cinematic", "Dark Synth"]),
            GenreModel(image: UIImage(named: "genre2")!,
                       title: "Drum 'n' Bass",
                       subGenres: ["Liquid Drum 'n' Bass", "Neurofunk", "Dark Drum 'n' Bass"]),
            GenreModel(image: UIImage(named: "genre3")!,
                       title: "EDM",
                       subGenres: ["Future Bass", "Chill EDM", "House Pop"]),
            GenreModel(image: UIImage(named: "genre4")!,
                       title: "Epic Score",
                       subGenres: ["Action Tension Score", "Epic Fantasy", "Low Pace Score"]),
            GenreModel(image: UIImage(named: "genre5")!,
                       title: "Hip Hop",
                       subGenres: ["Alternative Hip Hop", "East Coast Hip Hop", "Hip Pop"]),
            GenreModel(image: UIImage(named: "genre6")!,
                       title: "House",
                       subGenres: ["Afro House", "Deep House", "Soulful House", "Melodic House", "Tech House"]),
            GenreModel(image: UIImage(named: "genre7")!,
                       title: "Lo Fi",
                       subGenres: ["Lo Fi Study Beats", "Chillhop", "Neosoul", "Electro Chill"]),
            GenreModel(image: UIImage(named: "genre8")!,
                       title: "Reggaeton",
                       subGenres: ["Moombahton", "Urban Raggaeton", "Alternative Reggaeton"]),
            GenreModel(image: UIImage(named: "genre9")!,
                       title: "Synthwave",
                       subGenres: ["Chillwave", "Outrun", "Electronic Body Music", "Darkwave"]),
            GenreModel(image: UIImage(named: "genre10")!,
                       title: "Techno",
                       subGenres: ["Trance", "Melodic Techno", "Techno House", "Minimal Techno"]),
            GenreModel(image: UIImage(named: "genre11")!,
                       title: "Trap Double Tempo",
                       subGenres: ["Dark Trap Double Tempo", "Electro Trap Double Tempo", "Pop Trap Double Tempo", "Drill"]),
            GenreModel(image: UIImage(named: "genre12")!,
                       title: "Trap Half Tempo",
                       subGenres: ["Dark Trap Half Tempo", "Electro Trap Half Tempo", "Pop Trap Half Tempo"]),
            GenreModel(image: UIImage(named: "genre13")!,
                       title: "Downtempo",
                       subGenres: ["Electro Dub", "Electronica", "Trip Hop"]),
            GenreModel(image: UIImage(named: "genre14")!,
                       title: "Rock",
                       subGenres: ["Indie Rock", "Pop Rock", "Metal", "Slow Rock"]),
            GenreModel(image: UIImage(named: "genre15")!,
                       title: "Zen",
                       subGenres: []),
        ]
    }
}
