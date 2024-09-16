

import UIKit
import SnapKit

class MovieGridCell: UICollectionViewCell {
    
    private let baseURL = "https://image.tmdb.org/t/p/w500/"
    
    weak var delegate: DidTapMovieDelegate?
    
    var movie: Movie? {
        didSet {
            guard let character = movie else { return }
            if let imageUrl = URL(string: (baseURL + (character.backdropPath ?? "") )) {
                characterImageView.sd_setImage(with: imageUrl, completed: nil)
            }
            
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(containerView)
        
        containerView.addSubview(characterImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
            make.height.equalTo(containerView.snp.height)
        }
        
        DispatchQueue.main.async {
            self.roundTopCorners(for: self.characterImageView)
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
}
