//
//  HomeTableViewCell.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import UIKit
import Kingfisher

protocol HomeTableViewCellDelegate: AnyObject {
    func favouriteClicked(isFavourite: Bool, article: NewsArticle?)
}

final class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    @IBOutlet weak var bgview: UIView! {
        didSet {
            bgview.addCornerRadius(withRadius: 10.0)
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.addCornerRadius(withRadius: 10.0)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
        
    private var article: NewsArticle?
    
    weak var delegate: HomeTableViewCellDelegate?
    private var isFavourite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpUI(article : NewsArticle) {
        self.article = article
        titleLabel.text = article.title ?? ""
        descLabel.text = article.articleDescription ??  ""
        createdAtLabel.text = (article.author ?? "") + " at " + (article.publishedAt?.formatedDate() ?? "")
        if let imageString = article.imageUrl, let url = URL(string: imageString)  {
            profileImageView.kf.setImage(with: url)
        }
        isFavourite = article.isFavourite
        handlefavouriteUI()
    }
    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        isFavourite = !isFavourite
        handlefavouriteUI()
        delegate?.favouriteClicked(isFavourite: isFavourite, article: article)
    }
}

private extension HomeTableViewCell {
    func handlefavouriteUI() {
        if isFavourite {
            favouriteImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }  else {
            favouriteImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        }
    }
}
