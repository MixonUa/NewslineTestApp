//
//  PostCellViewModel.swift
//  NewslineTestApp
//
//  Created by Михаил Фролов on 01.02.2024.
//

import Foundation

struct PostCellViewModel {
    let post: Posts
    var collapsed: Bool
    let buttonHandler: (Posts) -> Void
}
