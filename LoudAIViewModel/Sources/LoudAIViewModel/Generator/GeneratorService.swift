//
//  GeneratorService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIModel
import SQLite

public protocol IGeneratorService {
    func addSavedMusic(_ model: SavedMusicModel) throws -> SavedMusicModel
    func getGenreItems() -> [GenreModel]
}

public class GeneratorService: IGeneratorService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func addSavedMusic(_ model: SavedMusicModel) throws -> SavedMusicModel {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedMusic")

        let idColumn = Expression<Int>("id")
        let genreColumn = Expression<String>("genre")
        let subGenreColumn = Expression<String>("sub_genre")
        let durationColumn = Expression<String>("duration")
        let musicsColumn = Expression<Data>("musics")

        try db.run(table.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(genreColumn)
            t.column(subGenreColumn)
            t.column(durationColumn)
            t.column(musicsColumn)
        })

        let musicsData = try JSONEncoder().encode(model.musics)

        let rowId = try db.run(table.insert(
            genreColumn <- model.genre,
            subGenreColumn <- model.subGenre,
            durationColumn <- model.duration,
            musicsColumn <- musicsData
        ))

        return SavedMusicModel(id: Int(rowId),
                               genre: model.genre,
                               subGenre: model.subGenre,
                               duration: model.duration,
                               musics: model.musics)
    }

    public func getGenreItems() -> [GenreModel] {
        [
            GenreModel(image: UIImage(named: "Ambient")!,
                       title: "Ambient",
                       subGenres: ["Cinematic Atmospheres", "Cinematic", "Dark Synth"]),
            GenreModel(image: UIImage(named: "Drum 'n' Bass")!,
                       title: "Drum 'n' Bass",
                       subGenres: ["Liquid Drum 'n' Bass", "Neurofunk", "Dark Drum 'n' Bass"]),
            GenreModel(image: UIImage(named: "EDM")!,
                       title: "EDM",
                       subGenres: ["Future Bass", "Chill EDM", "House Pop"]),
            GenreModel(image: UIImage(named: "Epic Score")!,
                       title: "Epic Score",
                       subGenres: ["Action Tension Score", "Epic Fantasy", "Low Pace Score"]),
            GenreModel(image: UIImage(named: "Hip Hop")!,
                       title: "Hip Hop",
                       subGenres: ["Alternative Hip Hop", "East Coast Hip Hop", "Hip Pop"]),
            GenreModel(image: UIImage(named: "House")!,
                       title: "House",
                       subGenres: ["Afro House", "Deep House", "Soulful House", "Melodic House", "Tech House"]),
            GenreModel(image: UIImage(named: "Lo Fi")!,
                       title: "Lo Fi",
                       subGenres: ["Lo Fi Study Beats", "Chillhop", "Neosoul", "Electro Chill"]),
            GenreModel(image: UIImage(named: "Reggaeton")!,
                       title: "Reggaeton",
                       subGenres: ["Moombahton", "Urban Raggaeton", "Alternative Reggaeton"]),
            GenreModel(image: UIImage(named: "Synthwave")!,
                       title: "Synthwave",
                       subGenres: ["Chillwave", "Outrun", "Electronic Body Music", "Darkwave"]),
            GenreModel(image: UIImage(named: "Techno")!,
                       title: "Techno",
                       subGenres: ["Trance", "Melodic Techno", "Techno House", "Minimal Techno"]),
            GenreModel(image: UIImage(named: "Trap Double Tempo")!,
                       title: "Trap Double Tempo",
                       subGenres: ["Dark Trap Double Tempo", "Electro Trap Double Tempo", "Pop Trap Double Tempo", "Drill"]),
            GenreModel(image: UIImage(named: "Trap Half Tempo")!,
                       title: "Trap Half Tempo",
                       subGenres: ["Dark Trap Half Tempo", "Electro Trap Half Tempo", "Pop Trap Half Tempo"]),
            GenreModel(image: UIImage(named: "Downtempo")!,
                       title: "Downtempo",
                       subGenres: ["Electro Dub", "Electronica", "Trip Hop"]),
            GenreModel(image: UIImage(named: "Rock")!,
                       title: "Rock",
                       subGenres: ["Indie Rock", "Pop Rock", "Metal", "Slow Rock"]),
            GenreModel(image: UIImage(named: "Zen")!,
                       title: "Zen",
                       subGenres: []),
        ]
    }
}
