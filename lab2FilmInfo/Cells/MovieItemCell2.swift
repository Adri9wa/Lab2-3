//
//  MovieItemCell2.swift
//  lab2FilmInfo
//
//  Created by Adrian Chizhevskyi on 21.12.2020.
//

import UIKit

import Kingfisher
import MarkerKit

import UIKit

final class MovieItemCell2: UICollectionViewCell{
    
    private struct Sizes {
        static let posterDefaultWidth: CGFloat = 120
        static let posterDefaultHeight: CGFloat = 200
    }
    
    private let posterImageView = UIImageView(contentMode: .scaleAspectFill)
    private let movieTitleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), backgroundColor: .white, lines: 1)
    private let releaseDateView = MovieYearReleaseView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.add(subviews: posterImageView, movieTitleLabel, releaseDateView)
    }
    
    private func setupConstraints() {
        posterImageView.mrk.top(to: contentView, attribute: .top, relation: .equal, constant: 50)
        posterImageView.mrk.leading(to: contentView, attribute: .leading, relation: .equal, constant: 0)
        posterImageView.mrk.centerX(to: contentView, relation: .equal, constant: 0)
        posterImageView.mrk.width(Sizes.posterDefaultWidth)
        posterImageView.mrk.height(Sizes.posterDefaultHeight)

        movieTitleLabel.mrk.top(to: posterImageView, attribute: .bottom, relation: .equal, constant: 5)
        releaseDateView.mrk.top(to: movieTitleLabel, attribute: .bottom, relation: .equal, constant: 12)
        
    }

    func setup(with movie: Movie) {
        if let path = movie.posterPath, let imageBaseUrl = URL(string: Config.URL.basePoster) {
            let posterPath = imageBaseUrl
                .appendingPathComponent("w300")
                .appendingPathComponent(path)

            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(
                with: posterPath,
                options: [.transition(.fade(0.2))], completionHandler:  { [weak self] _,_,_,_  in
                    self?.contentView.layoutIfNeeded()
                })
        }
        movieTitleLabel.text    = movie.title
        releaseDateView.setupWith(date: movie.releaseDate)
    }
    
    override func prepareForReuse() {
        movieTitleLabel.text = ""
        posterImageView.image = nil
        super.prepareForReuse()
    }
}
