//
//  AssemblyBuilder.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

protocol AssemblyModuleProtocol {
    func createBooksVC(router: RouterProtocol) -> UIViewController
    func createOrEditBookVC(chosenBook: BookModel, bookIndex: IndexPath?, router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleProtocol {
    func createBooksVC(router: RouterProtocol) -> UIViewController {
        let view = LibraryVC()
        let presenter = LibraryPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createOrEditBookVC(chosenBook: BookModel, bookIndex: IndexPath?, router: RouterProtocol) -> UIViewController {
        let view = BookVC()
        let presenter = BookPresenter(view: view, router: router, chosenBook: chosenBook, bookIndex: bookIndex)
        view.presenter = presenter
        return view
    }
}
