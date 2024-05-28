//
//  BookEntity+CoreDataProperties.swift
//  DNS_test
//
//  Created by mac on 28.05.2024.
//
//

import Foundation
import CoreData

extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var authorName: String
    @NSManaged public var bookName: String
    @NSManaged public var year: String

}

extension BookEntity : Identifiable {

}
