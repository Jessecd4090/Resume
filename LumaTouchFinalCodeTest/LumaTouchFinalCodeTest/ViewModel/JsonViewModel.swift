//
//  JsonViewModel.swift
//  LumaTouchFinalCodeTest
//
//  Created by Jestin Dorius on 7/28/25.
//
import SwiftUI

@Observable
class JsonViewModel {
    enum loadingErrors: LocalizedError, Error {
        case invalidFileName
        case invalidData
    }
    var percents: [Percent] = []
    
    func loadPercents(fileName: String) async throws -> [Percent] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw loadingErrors.invalidFileName
        }
        do {
            /* It is interesting that we don't recieve a response
             here, but that makes sense given that we aren't reaching
             to an API
             */
            let data = try Data(contentsOf: url)
            print("Data Successfully Retrieved: \(data.count) bytes")
            let percents = try JSONDecoder().decode([Percent].self, from: data)
            print("Percents converted from jsonFile")
            return percents
        } catch {
            throw loadingErrors.invalidData
        }
    }
}
