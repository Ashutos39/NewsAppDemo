//
//  HomeScreenViewController.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import UIKit

final class HomeScreenViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpUI()
    }
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
        cell.delegate = self
        cell.setUpUI(article: homeViewModel.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !DemoNetworkReachabilityManager.isConnectedToNetwork  {
            showError(errorMessage: "Internet not avilable")
            return
        }
        guard let url = homeViewModel.articles[indexPath.row].url else {return }
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailView.initialiseData(articleUrl: url)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension HomeScreenViewController: HomeTableViewCellDelegate {
    func favouriteClicked(isFavourite: Bool, article: NewsArticle?) {
        
        homeViewModel.updateIsFavourite(isFavorite: isFavourite, article: article)
    }

}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        homeViewModel.articles = []
        newsTableView.reloadData()
        homeViewModel.getHomeData(searchKey: searchText)
        showActivityIndicator()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeScreenViewController: HomeViewModelDelegate, HelperProtocol {
    func updateUI() {
        mainThread {
            self.hideActivityIndicator()
            self.newsTableView.reloadData()
        }
    }
    
    func showError(errorMessage: String) {
        mainThread {
            self.hideActivityIndicator()
            self.showAlert(withTitle: "Error", withMessage: errorMessage)
        }
    }
    
}

private extension HomeScreenViewController {
    func registerCells() {
        newsTableView.registerCell(HomeTableViewCell.self)
    }
    
    func setUpUI() {
        homeViewModel.delegate = self
        homeViewModel.getHomeData(searchKey: "")
        searchBar.delegate = self
        showActivityIndicator()
    }
    
    func showActivityIndicator() {
        activityView.isHidden = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityView.isHidden = true
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
