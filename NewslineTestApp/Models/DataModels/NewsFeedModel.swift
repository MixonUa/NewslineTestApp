//
//  NewsFeedModel.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import Foundation

struct NewsFeedModel: Codable {
    var posts: [Posts]
}


struct Posts: Codable {
    var postId: Int
    var timeshamp: Int
    var title: String
    var preview_text: String
    var likes_count: Int
}
