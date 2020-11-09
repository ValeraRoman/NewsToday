//
//  ArticleTableViewCell.swift
//  NewsToday
//
//  Created by Macbook Air 13 on 06.11.2020.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//       article.getData{
//            DispatchQueue.main.async {
//                self.titleLabel.text = self.article.title
//                self.authorLabel.text = self.article.author
//                self.descriptionLabel.text = self.article.description
//                self.publishedAtLabel.text = self.article.publishedAt
//            }
//          
//        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
