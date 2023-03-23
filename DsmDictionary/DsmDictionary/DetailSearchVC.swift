//
//  DetailSearchVC.swift
//  DsmDictionary
//
//  Created by furkan vural on 23.03.2023.
//

import UIKit

class DetailSearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailSearchPageView()
    }
    func configureDetailSearchPageView(){
        // Open keyboard
        searchBar.becomeFirstResponder()
        
        //MARK: - TableView
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        
        //MARK: - SearchBar
        self.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
    }
    
}

extension DetailSearchVC: UISearchBarDelegate {
    
}

extension DetailSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = "PlaceHolder"
        cell.contentConfiguration = content
        return cell
    }
}