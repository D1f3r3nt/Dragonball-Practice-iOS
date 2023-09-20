import UIKit

class HomeTableViewController: UITableViewController {
    
    private let network = NetworkModel()
    
    var heroes: [Hero] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Heroes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        network.getHeroes(completion: { [weak self] result in
            guard case let .success(hero) = result else {
                return
            }
                          
            self?.heroes = hero
        })
    }
    
}

// MARK: - Data Source
extension HomeTableViewController {
    // Set Size
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        heroes.count
    }
    
    // Catch cell and add object
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTableViewCell.identifier,
            for: indexPath
        ) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let hero = heroes[indexPath.row]
        cell.configure(with: hero)
        return cell
    }
}
