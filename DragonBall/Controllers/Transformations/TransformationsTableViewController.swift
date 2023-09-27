import UIKit

class TransformationsTableViewController: UITableViewController {
    
    private let transformations: [Transformation]
    
    init(transformations: [Transformation]) {
        self.transformations = transformations
        
        super.init(nibName: "TransformationsTableViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("TransformationsTableViewController(coder:) has not been implemented")
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transformations"
        self.tableView.register(
            UINib(nibName: "TransformationsRightTableViewCell", bundle: nil),
            forCellReuseIdentifier: TransformationsRightTableViewCell.identifier
        )
    }
    
}

// MARK: - Data Source
extension TransformationsTableViewController {
    
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        self.transformations.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TransformationsRightTableViewCell.identifier,
            for: indexPath
        ) as? TransformationsRightTableViewCell else {
            return UITableViewCell()
        }
        
        let transformation = transformations[indexPath.row]
        
        cell.configure(transformation: transformation)
        
        return cell
    }
}

// MARK: - Actions
extension TransformationsTableViewController {
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let transformation = transformations[indexPath.row]
        let details = DetailsViewController(
            title: transformation.name,
            description: transformation.description,
            photo: transformation.photo,
            hero: nil
        )
        
        self.navigationController?.pushViewController(details, animated: true)
    }
}
