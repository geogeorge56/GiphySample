//
//  GiphyModel.swift
//  GifySampleProject
//
//  Created by user on 14/02/20.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation


// MARK: - Giphy
struct Giphy: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id, title, rating: String
    let images: Images
}

// MARK: - Images
struct Images: Codable {
    let downsized: Downsized
    let original: Original
}

// MARK: - Downsized
struct Downsized: Codable {
    let height, size: String
    let url: String
    let width: String
}

struct Original:Codable {
    let url:String
}

