import UIKit
import SnapKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieListViewModel?
    var coordinator: AppCoordinator?
    var movieId: Int!
    
    private let posterImageView = UIImageView()
    private let backdropImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingContainerView = UIView()
    private let ratingLabel = UILabel()
    private let starImageView = UIImageView()
    private let yearLabel = UILabel()
    private let durationLabel = UILabel()
    private let genreLabel = UILabel()
    private let overviewLabel = UILabel()
    private let bookmarkButton = UIButton()
    
    private let yearIconImageView = UIImageView(image: UIImage(systemName: "calendar"))
    private let durationIconImageView = UIImageView(image: UIImage(systemName: "clock"))
    private let genreIconImageView = UIImageView(image: UIImage(systemName: "film"))
    
    init(viewModel: MovieListViewModel, coordinator: AppCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1.0)
        setupNavigationBar()
        setupUI()
        fetchMovieDetail()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: nil)
        bookmarkBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = bookmarkBarButton
        
        navigationItem.title = "Detail"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        
        // Backdrop Image
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        view.addSubview(backdropImageView)
        
        // Poster Image
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.masksToBounds = true
        view.addSubview(posterImageView)
        
        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Rating Container
        ratingContainerView.layer.cornerRadius = 8
        ratingContainerView.backgroundColor = UIColor(white: 0.2, alpha: 1) // Gris oscuro
        view.addSubview(ratingContainerView)
        
        // Star Icon
        starImageView.image = UIImage(systemName: "star")
        starImageView.tintColor = .orange
        ratingContainerView.addSubview(starImageView)
        
        // Rating Label
        ratingLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        ratingLabel.textColor = .orange
        ratingContainerView.addSubview(ratingLabel)
        
        // Year Label + Icon
        yearIconImageView.tintColor = .lightGray
        view.addSubview(yearIconImageView)
        
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.textColor = .lightGray
        view.addSubview(yearLabel)
        
        // Duration Label + Icon
        durationIconImageView.tintColor = .lightGray
        view.addSubview(durationIconImageView)
        
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .lightGray
        view.addSubview(durationLabel)
        
        // Genre Label + Icon
        genreIconImageView.tintColor = .lightGray
        view.addSubview(genreIconImageView)
        
        genreLabel.font = UIFont.systemFont(ofSize: 12)
        genreLabel.textColor = .lightGray
        view.addSubview(genreLabel)
        
        // Overview Label
        overviewLabel.font = UIFont.systemFont(ofSize: 14)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        view.addSubview(overviewLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(-65) // Superposición con el backdrop
            make.leading.equalToSuperview().offset(32)
            make.width.equalTo(100)
            make.height.equalTo(135)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(12)
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalTo(backdropImageView.snp.trailing).offset(16)
        }
        
        ratingContainerView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).offset(-36)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(24)
            make.width.equalTo(50)
        }
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalTo(ratingContainerView.snp.leading).offset(8)
            make.centerY.equalTo(ratingContainerView.snp.centerY)
            make.size.equalTo(14)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        yearIconImageView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(60)
            make.size.equalTo(20)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearIconImageView.snp.centerY)
            make.leading.equalTo(yearIconImageView.snp.trailing).offset(8)
        }
        
        durationIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(yearLabel.snp.trailing).offset(12)
            make.centerY.equalTo(yearLabel.snp.centerY)
            make.size.equalTo(20)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(durationIconImageView.snp.centerY)
            make.leading.equalTo(durationIconImageView.snp.trailing).offset(8)
        }
        
        genreIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(durationLabel.snp.trailing).offset(12)
            make.centerY.equalTo(durationLabel.snp.centerY)
            make.size.equalTo(20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(genreIconImageView.snp.centerY)
            make.leading.equalTo(genreIconImageView.snp.trailing).offset(8)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        DispatchQueue.main.async {
            self.roundTopCorners(for: self.backdropImageView)
        }
        
    }
    
    private func fetchMovieDetail() {
        viewModel?.fetchMovieDetail(movieId: movieId, completion: { [weak self] result in
            switch result {
            case .success(let movieDetail):
                DispatchQueue.main.async {
                    self?.updateUI(with: movieDetail)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error.localizedDescription)")
            }
        })
    }
    
    private func roundTopCorners(for view: UIView) {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [ .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    private func updateUI(with movieDetail: MovieDetail) {
        titleLabel.text = movieDetail.title
        ratingLabel.text = String(format: "%.1f", movieDetail.voteAverage)
        yearLabel.text = "\(movieDetail.releaseDate.prefix(4).description)   | "
        durationLabel.text = "\(movieDetail.runtime) Minutes  | "
        overviewLabel.text = movieDetail.overview
        if let firstGenre = movieDetail.genres.first {
            genreLabel.text = firstGenre.name
        } else {
            genreLabel.text = "Genre not available"
        }
        
        if let posterPath = movieDetail.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.sd_setImage(with: posterURL, completed: nil)
        }
        
        if let backdropPath = movieDetail.backdropPath {
            let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
            
            backdropImageView.sd_setImage(with: backdropURL, placeholderImage: UIImage.init(named: ""), options: []) { [weak self] (img, err, cacheType, imgURL) in
                guard let self = self, let img = img else { return }
                backdropImageView.image = nil
                let positions: [animPosition] = [.right, .left]
                let randomPosition = positions.randomElement() ?? .right

                img.animateByColumnsMovie(cols: 15, container: backdropImageView, velocity: .normal, position: randomPosition)
            }
            
        }
    }
}
