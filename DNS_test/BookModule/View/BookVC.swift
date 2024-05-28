//
//  BookVC.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

protocol BookVCProtocol: AnyObject {}

final class BookVC: UIViewController, BookVCProtocol {
    
    //MARK: - Properties
    var presenter: BookPresenterProtocol!
    
    private var bookNameTF = UITextField()
    private var authorNameTF = UITextField()
    private var yearTF = UITextField()
    private var saveButton = UIButton(type: .system)
    
    private var addButtonBottomConstraint: NSLayoutConstraint!
    
    private var reusedCell = "reusedCell"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        prepareViews()
        addConstraints()
        
        bookNameTF.delegate = self
        authorNameTF.delegate = self
        yearTF.delegate = self
        
        addObservers()
        updateSaveButtonState()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Init
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Methods
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        addButtonBottomConstraint.constant = -keyboardHeight - 20
        view.layoutIfNeeded()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        addButtonBottomConstraint.constant = -60
        view.layoutIfNeeded()
    }
    
    @objc private func saveButtonPressed() {
        let bookName = bookNameTF.text!
        let authorName = authorNameTF.text!
        let year = yearTF.text!
        
        let book = BookModel(name: bookName, author: authorName, year: year)
        presenter.addOrEditBook(book: book)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func updateSaveButtonState(with textField: UITextField? = nil, text: String? = nil) {
        let bookNameText = (textField == bookNameTF) ? text : bookNameTF.text
        let authorNameText = (textField == authorNameTF) ? text : authorNameTF.text
        let yearText = (textField == yearTF) ? text : yearTF.text
        
        let isFormFilled = !(bookNameText?.isEmpty ?? true) &&
        !(authorNameText?.isEmpty ?? true) &&
        !(yearText?.isEmpty ?? true)
        
        saveButton.isEnabled = isFormFilled
        saveButton.alpha = isFormFilled ? 1.0 : 0.5
    }
    
    //MARK: - Configuration
    private func addSubviews() {
        view.addSubview(bookNameTF)
        view.addSubview(authorNameTF)
        view.addSubview(yearTF)
        view.addSubview(saveButton)
    }
    
    private func prepareViews() {
        title = "Книга"
        view.backgroundColor = .systemBackground
        
        yearTF.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        bookNameTF.translatesAutoresizingMaskIntoConstraints = false
        authorNameTF.translatesAutoresizingMaskIntoConstraints = false
        
        yearTF.borderStyle = .roundedRect
        yearTF.layer.cornerRadius = 5
        
        bookNameTF.borderStyle = .roundedRect
        bookNameTF.layer.cornerRadius = 5
        
        authorNameTF.borderStyle = .roundedRect
        authorNameTF.layer.cornerRadius = 5
        
        if presenter.bookIndex != nil {
            yearTF.text = presenter.chosenBook.year
            bookNameTF.text = presenter.chosenBook.name
            authorNameTF.text = presenter.chosenBook.author
        } else {
            bookNameTF.placeholder = "Название книги"
            authorNameTF.placeholder = "Имя автора"
            yearTF.placeholder = "Дата выпуска"
        }
        
        saveButton.alpha = 0.5
        saveButton.isEnabled = (presenter.bookIndex != nil) ? false : true
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.setTitle((presenter.bookIndex != nil) ? "Изменить" : "Сохранить", for: .normal)
        
    }
    
    private func addConstraints() {
        addButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        
        NSLayoutConstraint.activate([
            bookNameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            bookNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authorNameTF.topAnchor.constraint(equalTo: bookNameTF.bottomAnchor, constant: 20),
            
            yearTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            yearTF.topAnchor.constraint(equalTo: authorNameTF.bottomAnchor, constant: 20),
            
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButtonBottomConstraint
        ])
    }
}
//MARK: - Extensions
extension BookVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        updateSaveButtonState(with: textField, text: updatedText)
        return true
    }
}
