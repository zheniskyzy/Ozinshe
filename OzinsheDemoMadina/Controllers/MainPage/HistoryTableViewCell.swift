//
//  HistoryTableViewCell.swift
//  OzinsheDemoMadina
//
//  Created by Madina Olzhabek on 25.01.2024.
//

import UIKit
import SDWebImage

class HistoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func configureView(){
        titleLabel.text = "CONTINUE_WATCHING".localized()
    }
    
    func setData(mainMovie: MainMovies){
        self.mainMovies = mainMovie
        collectionView.reloadData()
    }
    
    
    //MARK: - collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovies.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // imageview
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.sd_setImage(with: URL(string: mainMovies.movies[indexPath.row].poster_link), placeholderImage: nil, context: [.imageTransformer: transformer])
        imageview.layer.cornerRadius = 8
        
        // movieNameLabel
        let movieNameLabel = cell.viewWithTag(1001) as! UILabel
        movieNameLabel.text = mainMovies.movies[indexPath.row].name
        
        
        //movieGenreNameLabel
        let movieGenreNameLabel = cell.viewWithTag(1002) as! UILabel
        
        if let genrename = mainMovies.movies[indexPath.row].genres.first{
            movieGenreNameLabel.text = genrename.name
        }else{
            movieGenreNameLabel.text = ""
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.movieDidSelect(movie: mainMovies.movies[indexPath.row])
    }
    
}
