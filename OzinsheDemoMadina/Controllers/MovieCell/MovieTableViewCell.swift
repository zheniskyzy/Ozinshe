//
//  MovieTableViewCell.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 09.01.2024.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var playLabel: UILabel!
    
    var movie:[Movie] = []
    var genreName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 8
        playView.layer.cornerRadius = 8
        
        configureViews()
    }
    
    override func prepareForReuse() {
        configureViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(movie: Movie){
        posterImageView.sd_setImage(with: URL(string: movie.poster_link), completed: nil)
        nameLabel.text = movie.name
        
         yearLabel.text = "\(movie.year) •\(movie.movieType)"
        
    }
    
    func configureViews(){
        
        playLabel.text = "PLAY".localized()
    }
}
