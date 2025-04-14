//
//  CreateService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import UIKit
import LoudAIModel
import SQLite

public protocol ICreateService {
    func addSavedMusic(_ model: SavedMusicModel) throws -> SavedMusicModel
    func getAllSavedMusics() throws -> [SavedMusicModel]
    func deleteSavedMusic(by id: Int) throws
}

public class CreateService: ICreateService {

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

    public func getAllSavedMusics() throws -> [SavedMusicModel] {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedMusic")

        let idColumn = Expression<Int>("id")
        let genreColumn = Expression<String>("genre")
        let subGenreColumn = Expression<String>("sub_genre")
        let durationColumn = Expression<String>("duration")
        let musicsColumn = Expression<Data>("musics")

        var result: [SavedMusicModel] = []

        for row in try db.prepare(table) {
            let musicsData = row[musicsColumn]
            let decodedMusics = try JSONDecoder().decode([LoadedMusicModel].self, from: musicsData)

            let model = SavedMusicModel(
                id: row[idColumn],
                genre: row[genreColumn],
                subGenre: row[subGenreColumn],
                duration: row[durationColumn],
                musics: decodedMusics
            )
            result.append(model)
        }

        return result
    }

    public func deleteSavedMusic(by id: Int) throws {
        let db = try Connection("\(path)/db.sqlite3")
        let table = Table("SavedMusic")
        let idColumn = Expression<Int>("id")

        let itemToDelete = table.filter(idColumn == id)
        try db.run(itemToDelete.delete())
    }

}
