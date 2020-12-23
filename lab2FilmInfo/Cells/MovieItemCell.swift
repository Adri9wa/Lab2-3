//
//  MovieItemCell.swift
//  lab2FilmInfo
//
//  Created by Adrian Chizhevskyi on 17.12.2020.
//

import UIKit

import Kingfisher
import MarkerKit

import UIKit
extension UIView {

    /// Adds the set of subviews to current view.
    ///
    /// - Parameter subviews: The set of subviews.
    func add(subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
extension UIImageView {
    
    /// Convinience method for initialization with specified content mode.
    ///
    /// - Parameters:
    ///   - image: The inititial image.
    ///   - contentMode: Options to specify how a view adjusts its content when its size changes.
    convenience init(_ image: UIImage? = nil, contentMode: UIView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
}
final class MovieItemCell: UITableViewCell {
    
    private struct Sizes {
        static let posterDefaultWidth: CGFloat = 100
        static let posterDefaultHeight: CGFloat = 150
    }
    
    private let posterImageView = UIImageView(contentMode: .scaleToFill)
    private let movieTitleLabel = UILabel(font: .systemFont(ofSize: 17, weight: .semibold), backgroundColor: .white, lines: 1)
    private let releaseDateView = MovieYearReleaseView()
    private let ratingBar = RatingBar()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.add(subviews: posterImageView, movieTitleLabel, ratingBar, releaseDateView)
    }
    
    private func setupConstraints() {
        //TODO: fix the constraints
       
        posterImageView.mrk.top(to: contentView, attribute: .top, relation: .equal, constant: 5)
        posterImageView.mrk.leading(to: contentView, attribute: .leading, relation: .equal, constant: 30)
        posterImageView.mrk.width(Sizes.posterDefaultWidth)
        posterImageView.mrk.height(Sizes.posterDefaultHeight)

        movieTitleLabel.mrk.top(to: contentView, attribute: .top, relation: .equal, constant: 6)
        movieTitleLabel.mrk.leading(to: posterImageView, attribute: .trailing, relation: .equal, constant: 5)
        ratingBar.mrk.top(to: posterImageView, attribute: .centerY, relation: .equal, constant: -40)
        ratingBar.mrk.leading(to: posterImageView, attribute: .trailing, relation: .equal, constant: 70)

        ratingBar.mrk.width(100)
        ratingBar.mrk.height(100)
        
        releaseDateView.mrk.left(to: posterImageView, attribute: .right, relation: .equal, constant: 12)
        releaseDateView.mrk.bottom(to: contentView, attribute: .bottom, relation: .equal, constant: -6)
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
        ratingBar.awakeFromNib()
        ratingBar.labelPercentSize = 11
        ratingBar.setProgress(to: movie.rating!/10, withAnimation: false, endProgress: movie.rating!/10)
        releaseDateView.setupWith(date: movie.releaseDate)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        ratingBar.setProgress(to: 0, withAnimation: false, endProgress: 0)
    }
}


