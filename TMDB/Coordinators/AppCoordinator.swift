
import Foundation
import UIKit

class AppCoordinator: NSObject {
    var childCoordinators: [AppCoordinator] = []
    var navigationController: BaseNavigationViewController?
    
    
    func start() {
        let viewModel = MovieListViewModel()
        let vc = MovieListViewController(viewModel: viewModel, coordinator: self)
        
        navigationController = BaseNavigationViewController(rootViewController: vc)
        navigationController?.showAsRoot()        
    }
    
    func openDetailViewController(movieId: Int) {
        let viewModel = MovieListViewModel()
        let vc = MovieDetailViewController(viewModel: viewModel, coordinator: self)
        vc.movieId = movieId
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

