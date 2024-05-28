//
//  AssemblyBuilder.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

protocol AssemblyModuleProtocol {
    func createBooksVC(router: RouterProtocol) -> UIViewController
    func createOrEditBookVC(chosenBook: BookModel, doWeChooseBook: Bool, router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyModuleProtocol {
    func createBooksVC(router: RouterProtocol) -> UIViewController {
        let store = Store()
        let view = LibraryVC()
        let presenter = LibraryPresenter(view: view, store: store, router: router)
        view.presenter = presenter
        return view
    }
    
    func createOrEditBookVC(chosenBook: BookModel, doWeChooseBook: Bool, router: RouterProtocol) -> UIViewController {
        let store = Store()
        let view = BookVC()
        let presenter = BookPresenter(view: view, store: store, router: router)
        view.presenter = presenter
        return view
    }
}

