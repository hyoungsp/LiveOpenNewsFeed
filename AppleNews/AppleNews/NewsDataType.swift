//
//  NewsDataType.swift
//  AppleNews
//
//  Created by HYOUNGSUN park on 1/28/18.
//  Copyright © 2018 stanleypark. All rights reserved.
//

import Foundation

/// Note:🤔
///   For the `Codable` protocol to work, the names of the properties
///   must EXACTLY match the keys in the JSON

/// Hold the top level JSON from the Open News API
struct News: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

/// Data about the `Article`
struct Article: Codable {
    var title: String
    var author: String?
    var description: String
    var urlToImage: URL?
    var source: Source
    var url: URL
    var publishedAt: String
}

// Article sources (ie. who wrote it)
struct Source: Codable {
    var id: String?
    var name: String
}
