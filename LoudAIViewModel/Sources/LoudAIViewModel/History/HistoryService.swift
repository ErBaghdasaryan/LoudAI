//
//  HistoryService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIModel
import SQLite

public protocol IHistoryService {
    func getAllSavedMusics() throws -> [SavedMusicModel]
}

public class HistoryService: IHistoryService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

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

}
