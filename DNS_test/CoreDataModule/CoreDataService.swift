//
//  CoreDataService.swift
//  DNS_test
//
//  Created by mac on 28.05.2024.
//

import UIKit
import CoreData

final class CoreDataService {
    
    //MARK: - Singleton
    static let shared = CoreDataService()
    private init() {}
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func saveContext() {
        let context = getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createBook(bookModel: BookModel) {
        guard let bookEntityDescription = NSEntityDescription.entity(forEntityName: "BookEntity", in: getContext()) else { return }
        let book = BookEntity(entity: bookEntityDescription, insertInto: getContext())
        book.bookName = bookModel.name
        book.authorName = bookModel.author
        book.year = bookModel.year
        
        saveContext()
    }
    
    func getAllBooks() -> [BookModel] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            let books = entities.map { entity in
                return BookModel(name: entity.bookName , author: entity.authorName, year: entity.year)
            }
            
            return books
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    func deleteAllBooks() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            
            for entity in entities {
                context.delete(entity)
            }
            
            try context.save()
        } catch {
            print("Failed to delete books: \(error)")
        }
    }
    
    func deleteBook(book: BookModel) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            let deletedBook = entities.first { entity in
                BookModel(name: entity.bookName , author: entity.authorName, year: entity.year) == book
            }
            
            if let deletedBook {
                context.delete(deletedBook)
            }
            
            try context.save()
        } catch {
            print("Failed to delete book: \(error)")
        }
    }
    
    func fetchBooksMatching(searchString: String) -> [BookModel] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(fetchRequest)
            let books = entities.map { entity in
                return BookModel(name: entity.bookName, author: entity.authorName, year: entity.year)
            }
            
            let filteredBooks = books.filter { book in
                return book.name.lowercased().contains(searchString.lowercased()) ||
                book.author.lowercased().contains(searchString.lowercased()) ||
                book.year.lowercased().contains(searchString.lowercased())
                
            }
            
            return filteredBooks
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    
    func sortBooks(by sortType: SortType) -> [BookModel] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            var entities = try context.fetch(fetchRequest)
            
            switch sortType {
            case .name:
                entities.sort { $0.bookName < $1.bookName }
            case .author:
                entities.sort { $0.authorName < $1.authorName }
            case .year:
                entities.sort { $0.year  < $1.year }
            }
            
            let books = entities.map { entity in
                return BookModel(name: entity.bookName , author: entity.authorName, year: entity.year)
            }
            
            try context.save()
            return books
        } catch {
            print("Failed to sort books: \(error)")
            return []
        }
    }
}

enum SortType {
    case name
    case author
    case year
}
