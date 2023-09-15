//
//  DetailedNewsModel.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 15.09.2023.
//

import Foundation

struct DetailedNewsModel: Codable {
    var post: Post
}

struct Post: Codable {
    var postId: Int
    var timeshamp: Double
    var title: String
    var text: String
    var postImage: String
    var likes_count: Int
}
