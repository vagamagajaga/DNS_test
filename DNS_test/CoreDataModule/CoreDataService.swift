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
    
//    var books: [BookModel] = []
    
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


    
    func fetchBookByName(_ name: String) -> BookModel? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookEntity")
        do {
            let books = try? getContext().fetch(fetchRequest) as? [BookModel]
            return books?.first(where: {$0.name == name})
        }
    }
    
    func updateBook(bookName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookEntity")
        do {
//            guard let books = try? getContext().fetch(fetchRequest) as? [BookModel],
//                  let book = books.first(where: {$0.name == bookName}) else { return }
        }
    }

}
