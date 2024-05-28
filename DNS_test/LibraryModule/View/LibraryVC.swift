//
//  LibraryVC.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

protocol LibraryVCProtocol: AnyObject {
    func updateData()
}

final class LibraryVC: UIViewController, LibraryVCProtocol {
    
    //MARK: - Properties
    var presenter: LibraryPresenterProtocol!
    
    private let reusedCell = "reusedCell"
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    private var addButton = UIButton()
    private var sortButton = UIButton()
    
    //MARK: - Lificycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        addSubviews()
        addConstraints()
        prepareSubviews()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.switchSortType()
        updateData()
    }
    
    //MARK: - Methods
    @objc private func addButtonPressed() {
        presenter.openBookPage(book: BookModel(name: "", author: "", year: ""), bookIndex: nil)
    }
    
    @objc private func sortButtonPressed() {
        presenter.switchSortType()
        updateData()
    }
    
    func updateData() {
        tableView.reloadData()
    }
    
    //MARK: - Configuration
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
            sortButton.widthAnchor.constraint(equalToConstant: 30),
            sortButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func prepareSubviews() {
        title = "Библиотека"
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .always
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        sortButton.tintColor = .systemBlue
        sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
    }
}

//MARK: - Extensions
extension LibraryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCell)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusedCell)
        
        guard let cell = cell else {
            return UITableViewCell(style: .default, reuseIdentifier: reusedCell)
        }
        
        let bookName = presenter.books[indexPath.row].name
        let author = presenter.books[indexPath.row].author
        let year = presenter.books[indexPath.row].year
        
        cell.textLabel?.text = bookName
        cell.detailTextLabel?.text = author + ", " + year
        
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension LibraryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = presenter.books[indexPath.row]
        presenter.openBookPage(book: selectedBook, bookIndex: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeRead = UIContextualAction(style: .normal, title: "Удалить") { [weak self] action, view, success in
            guard let self else { return }
            tableView.performBatchUpdates {
                self.presenter.deleteBook(indexPath: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateData()
            }
        }
        swipeRead.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [swipeRead])
    }
}

extension LibraryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBook(text: searchText)
        updateData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
