//
//  SearchPageVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 21.03.2023.
//

import UIKit

class SearchPageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordDefinitionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchPageView()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    
     @objc private func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    private func configureSearchPageView(){
        
        // Hide backbutton
        navigationItem.hidesBackButton = true
        
        // MARK: - ImageView
        self.dailyImageView.image = UIImage(named: "Onboarding")
        
        // MARK: - Delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // MARK: - Labels
        self.wordLabel.text = "Günün Kelimesi"
        self.wordLabel.numberOfLines = 0
        self.wordLabel.textColor = .black
        self.wordLabel.textAlignment = .center
        self.wordLabel.font = .boldSystemFont(ofSize: 35)
        
        self.wordDefinitionLabel.text = "Günün kelimesinin açıklaması burada olacak - Günün kelimesinin açıklaması burada olacak"
        self.wordDefinitionLabel.textColor = .black.withAlphaComponent(0.5)
        self.wordDefinitionLabel.numberOfLines = 0
        self.wordDefinitionLabel.textAlignment = .center
        self.wordDefinitionLabel.font = .systemFont(ofSize: 15)
        
        // Search Bar
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Ara"

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "Aranan Kelime"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let title = "Geçmiş"
            return title
    }
    
}
