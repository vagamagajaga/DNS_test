//
//  BookModel+.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import Foundation

extension BookModel: Comparable {
    static func < (lhs: BookModel, rhs: BookModel) -> Bool {
        lhs.name > rhs.name
    }
    
    static func == (lhs: BookModel, rhs: BookModel) -> Bool {
        lhs.author == rhs.author && lhs.name == rhs.name && lhs.year == rhs.year
    }
}
