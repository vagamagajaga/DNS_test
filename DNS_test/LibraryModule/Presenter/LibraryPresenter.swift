//
//  LibraryPresenter.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import Foundation

protocol LibraryPresenterProtocol: AnyObject {
    var books: [BookModel] { get }
    init(view: LibraryVCProtocol, router: RouterProtocol)
    func openBookPage(book: BookModel, bookIndex: IndexPath?)
    func switchSortType()
    func searchBook(text: String)
    func setLibrary()
    func deleteBook(indexPath: IndexPath)
}

final class LibraryPresenter: LibraryPresenterProtocol {
    
    //MARK: - Properties
    weak var view: LibraryVCProtocol!
    var router: RouterProtocol
    
    var books: [BookModel] = []
    private var allBooks: [BookModel]
    private var count: Int = 0
    
    //MARK: - Init
    required init(view: LibraryVCProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
        allBooks = books
    }
    
    //MARK: - Methods
    private func sortByName() {
        books = CoreDataService.shared.sortBooks(by: .name)
    }
    
    private func sortByAuthor() {
        books = CoreDataService.shared.sortBooks(by: .author)
    }
    
    private func sortByYear() {
        books = CoreDataService.shared.sortBooks(by: .year)
    }
    
    func openBookPage(book: BookModel, bookIndex: IndexPath?) {
        router.showChosenOrNewBook(book: book, bookIndex: bookIndex)
    }
    
    func switchSortType() {
        if count == 0 {
            sortByName()
            count += 1
        } else if count == 1 {
            sortByAuthor()
            count += 1
        } else {
            sortByYear()
            count -= 2
        }
    }
    
    func searchBook(text: String) {
        if text.isEmpty {
            setLibrary()
        } else {
            let fetchBook = CoreDataService.shared.fetchBooksMatching(searchString: text)
            books = fetchBook
        }
    }
    
    func setLibrary() {
        books = CoreDataService.shared.getAllBooks()
    }
    
    func deleteBook(indexPath: IndexPath) {
        let book = books[indexPath.row]
        CoreDataService.shared.deleteBook(book: book)
        setLibrary()
    }
}
