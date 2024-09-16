

import UIKit
import SnapKit

protocol DidTapMovieDelegate: AnyObject {
    func didSelectMovie(movieId: Int)
}

class FeaturedMoviesContainerCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: DidTapMovieDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 145, height: 210)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 24)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var movies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(FeaturedMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "FeaturedMoviesCollectionViewCell")
        contentView.addSubview(collectionView)
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FeaturedMoviesContainerCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMoviesCollectionViewCell", for: indexPath) as! FeaturedMoviesCollectionViewCell
        cell.tag = indexPath.item + 1
        cell.movie = movies[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension FeaturedMoviesContainerCollectionViewCell: DidTapMovieDelegate {
    func didSelectMovie(movieId: Int) {
        delegate?.didSelectMovie(movieId: movieId)
    }
    
    
}


class FeaturedMoviesCollectionViewCell: UICollectionViewCell {
    
    private let baseURL = "https://image.tmdb.org/t/p/w500/"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 96)
        label.textColor = UIColor(hex: "#242A32")  
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    weak var delegate: DidTapMovieDelegate?
    
    var movie: Movie? {
        didSet {
            guard let character = movie else { return }
            
            if let imageUrl = URL(string: (baseURL + (character.backdropPath ?? "") )) {
                imageView.sd_setImage(with: imageUrl, completed: nil)
            }
            titleLabel.text = String(describing: self.tag)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTapGesture()
        configureTitleLabel()
        configureShadowToTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(-48)
            make.width.equalTo(140)
            make.height.equalTo(96)
        }
        
        DispatchQueue.main.async {
            self.roundTopCorners(for: self.imageView)
        }
    }
    
    private func configureTitleLabel() {
        let text = "1"
        let font = UIFont(name: "Arial", size: 96)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor(hex: "#0296E5"),
            .foregroundColor: UIColor(hex: "#242A32"),
            .strokeWidth: -1.0,
            .font: font
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        titleLabel.attributedText = attributedString
        
        for family in UIFont.familyNames.sorted() {
            let fontNames = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(fontNames)")
        }
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard let movie = movie else { return }
        delegate?.didSelectMovie(movieId: movie.id)
    }
    
    private func roundTopCorners(for view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    private func configureShadowToTitleLabel() {
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowOpacity = 1.25
        titleLabel.layer.shadowRadius = 4
        
        let innerShadow = CALayer()
        innerShadow.frame = titleLabel.bounds
        let shadowPath = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -4, dy: -4)).cgPath
        innerShadow.shadowPath = shadowPath
        innerShadow.masksToBounds = true
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 4)
        innerShadow.shadowOpacity = 1.25
        innerShadow.shadowRadius = 4
        titleLabel.layer.addSublayer(innerShadow)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
