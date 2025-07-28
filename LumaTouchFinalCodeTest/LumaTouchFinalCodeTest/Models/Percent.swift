//
//  Percent.swift
//  LumaTouchFinalCodeTest
//
//  Created by Jestin Dorius on 7/28/25.
//

import Foundation

struct Percent: Decodable, Equatable {
    // Adding this computed property to make the identifiable protocol happy
    /* After lots of thought, I decided that the best way to identify the items in this list
     is to use their percent value, i don't know the future of this app, and what other features
     will be added later. If we created multiple surveys for each items to show, they wouldn't
     appear with the names being the id
    */

    // Copy the data in my models to match the json exactly, or use coding keys
    
    var description: String
    // This needs to be a float not an Int
    var percentValue: Float
    var backColor: String
    var foreColor: String
}
