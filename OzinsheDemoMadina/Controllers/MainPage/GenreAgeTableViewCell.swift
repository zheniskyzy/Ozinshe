//
//  GenreAgeTableViewCell.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 25.01.2024.
//

import UIKit
import SDWebImage

class GenreAgeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    var mainMovies = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovies = mainMovie
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mainMovies.cellType == .ageCategory{
            return mainMovies.categoryAges.count
        }
        return mainMovies.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // imageview
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.layer.cornerRadius = 8
        
        // movieNameLabel
        let nameLabel = cell.viewWithTag(1001) as! UILabel
        if mainMovies.cellType == .ageCategory{
            imageview.sd_setImage(with: URL(string: mainMovies.categoryAges[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
            nameLabel.text = mainMovies.categoryAges[indexPath.row].name
        }else{
            imageview.sd_setImage(with: URL(string: mainMovies.genres[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
            nameLabel.text = mainMovies.genres[indexPath.row].name
        }
        
        return cell
    }
    
    

}
