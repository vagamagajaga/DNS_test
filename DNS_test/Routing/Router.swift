//
//  Router.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyModuleProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialLibraryVC()
    func showChosenOrNewBook(book: BookModel, doWeChooseBook: Bool)
}

class Router: RouterProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyModuleProtocol?
    
    //MARK: - Init
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyModuleProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    func initialLibraryVC() {
        if let navigationController = navigationController {
            guard let booksVC = assemblyBuilder?.createBooksVC(router: self) else { return }
            navigationController.viewControllers = [booksVC]
        }
    }
    
    func showChosenOrNewBook(book: BookModel, doWeChooseBook: Bool) {
        if let navigationController = navigationController {
            guard let bookVC = assemblyBuilder?.createOrEditBookVC(chosenBook: book,
                                                                   doWeChooseBook: doWeChooseBook,
                                                                   router: self) else { return }
            navigationController.pushViewController(bookVC, animated: true)
        }
    }
}
