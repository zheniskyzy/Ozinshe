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
    var delegate : MovieProtocol?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureView()
    }
    
    override func prepareForReuse() {
        configureView()
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovies = mainMovie
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(){
        if mainMovies.cellType == .ageCategory{
            titleLabel.text = "APPROPIATE_FOR_AGE".localized()
        }else{
            titleLabel.text = "CHOOSE_A_GENRE".localized()
        }
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if mainMovies.cellType == .genre{
            delegate?.genreDidSelect(genreId: mainMovies.genres[indexPath.row].id, genreName: mainMovies.genres[indexPath.row].name)
        }else{
            delegate?.ageCategoryDidSelect(categoryAgeId: mainMovies.categoryAges[indexPath.row].id)
        }
       
    }
    
}
