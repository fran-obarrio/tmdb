

import UIKit
import SDWebImage


class MovieListViewController: UIViewController {
    
    var viewModel: MovieListViewModel?
    var coordinator: AppCoordinator?
    
    private var lottieAnimation: LottieAnimationsManager = LottieAnimationsManager()
    private var currentFeaturePage = 1
    private var currentPage = 1
    private var isFetching = false
    private var isFirstTimeLoading = true
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.alpha = 0
        return cv
    }()
    
    
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
        self.view.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1.0)
        setupUI()
        setupLottieAnimation()
        fetchMovies(type: .featured)
        fetchMovies(type: .nowPlaying)
    }
    
    private func setupUI() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemsPerRow: CGFloat = 3
            let padding: CGFloat = 16  
            let minimumSpacing: CGFloat = 1
            let totalPadding = padding * 2 + (minimumSpacing * (itemsPerRow - 1))
            let individualItemWidth = (view.frame.width - totalPadding) / itemsPerRow
            
            layout.itemSize = CGSize(width: individualItemWidth, height: individualItemWidth * 1.5)
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = minimumSpacing
            layout.sectionInset = UIEdgeInsets(top: 4, left: padding, bottom: 4, right: padding)
        }


        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "MovieGridCell")
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCell")
        collectionView.register(FeaturedMoviesContainerCollectionViewCell.self, forCellWithReuseIdentifier: "FeaturedMoviesCell")
        collectionView.register(ButtonSectionCollectionViewCell.self, forCellWithReuseIdentifier: "ButtonSectionCell")
                
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func setupLottieAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation = LottieAnimationsManager()
            self.lottieAnimation.setup(
                view: self.view,
                animation: .popCornIntro,
                loop: true,
                isMainLoader: true,
                backgroundColor: .clear,
                contentMode: .scaleAspectFit)
            self.lottieAnimation.play()
        }
    }
    
    private func fetchMovies(type: MovieType) {
        isFetching = true
        
        viewModel?.fetchMovies(type: type, page: currentFeaturePage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .success(_):
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.refreshData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func refreshData() {
        self.collectionView.reloadData()
        if self.isFirstTimeLoading {
            self.removeAnimation()
        }
    }
    
    private func removeAnimation() {
        isFirstTimeLoading = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation.stop()
            self.lottieAnimation.removeAnimationView()
            self.view.bringSubviewToFront(self.collectionView)
            self.startFadeIn()
        }
    }
    
    private func startFadeIn() {
        self.collectionView.alpha = 1
        self.hideAllCells()
        self.doAnimFadeIn()
    }
    
    private func hideAllCells() {
        let cells = self.collectionView.visibleCells
        if cells.count > 0 {
            for cell in cells {
                cell.alpha = 0
            }
        }
    }
    
    private func doAnimFadeIn() {
        var index = 0
        let cells = self.collectionView.visibleCells
        if cells.count > 0 {
            for cell in cells {
                UIView.animate(withDuration: 0.15, delay: 0.15 * Double(index), options: [], animations: {
                    cell.alpha = 1
                }, completion: nil)
                index+=1
            }
        }
        
    }
        
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if let _ = viewModel?.featuredMovies {
                return 1
            } else {
                return 0
            }
        case 2:
            return 1
        case 3:
            if let movies = viewModel?.bottomMovies {
                return movies.count
            } else {
                return 0
            }
        default:
            return 0
        }
     
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
            return cell
        case 1:            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMoviesCell", for: indexPath) as? FeaturedMoviesContainerCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let characters = viewModel?.featuredMovies {
                cell.movies =  characters
                cell.delegate = self
            }
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonSectionCell", for: indexPath) as! ButtonSectionCollectionViewCell
            cell.delegate = self
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as? MovieGridCell else {
                return UICollectionViewCell()
            }
            cell.accessibilityIdentifier = "CharacterCell_\(indexPath.item)"
            
             if let character = viewModel?.bottomMovies[indexPath.item] {
                cell.movie = character
                cell.delegate = self
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 115) // Search bar
        case 1:
            return CGSize(width: collectionView.frame.width, height: 250) // Featured movies
        case 2:
            return CGSize(width: collectionView.frame.width, height: 80) // Button section
        case 3:
            return CGSize(width: collectionView.frame.width / 3.5, height: 150) // Grid of movies
        default:
            return CGSize(width: collectionView.frame.width, height: 44)
        }
    }
}

extension MovieListViewController: ButtonSectionDelegate {
    func didTapNowPlaying() {
        fetchMovies(type: .nowPlaying)
    }
    
    func didTapUpcoming() {
        fetchMovies(type: .upcoming)
    }
    
    func didTapTopRated() {
        fetchMovies(type: .topRated)
    }
}

extension MovieListViewController: DidTapMovieDelegate {
    func didSelectMovie(movieId: Int) {
        coordinator?.openDetailViewController(movieId: movieId)
    }
            
}
