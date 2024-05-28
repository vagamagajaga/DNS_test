//
//  BookPresenter.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import Foundation

protocol BookPresenterProtocol: AnyObject {
    var chosenBook: BookModel { get set }
    var bookIndex: IndexPath? { get set }
    func addOrEditBook(book: BookModel)
}

final class BookPresenter: BookPresenterProtocol {
    
    //MARK: - Properties
    weak var view: BookVCProtocol!
    var router: RouterProtocol
    
    var chosenBook: BookModel
    var bookIndex: IndexPath?
    
    //MARK: - Init
    required init(view: BookVCProtocol, router: RouterProtocol, chosenBook: BookModel, bookIndex: IndexPath?) {
        self.view = view
        self.router = router
        self.chosenBook = chosenBook
        self.bookIndex = bookIndex
    }
    
    //MARK: - Methods
    func addOrEditBook(book: BookModel) {
        CoreDataService.shared.deleteBook(book: chosenBook)
        CoreDataService.shared.createBook(bookModel: book)
    }
}
