import UIKit

class DetailsViewController: UIViewController {
    
    private var header: String
    private var desc: String
    private var photo: URL
    private var hero: Hero?
    private var transformations: [Transformation] = []
    private let network = NetworkModel()
    
    init(
        title: String,
        description: String,
        photo: URL,
        hero: Hero?
    ) {
        self.header = title
        self.desc = description
        self.photo = photo
        self.hero = hero
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var imagePrincipal: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var transformacionesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transformacionesButton.isHidden = true // Default
        
        imagePrincipal.setImage(for: photo)
        titleLable.text = header
        descriptionLabel.text = desc
        title = header
        
        if let dragonBall = hero {
            network.getTransformations(for: dragonBall) { [weak self] result in
                guard case let .success( transformations ) = result else {
                    return
                }
                
                self?.transformations = transformations
                DispatchQueue.main.async {
                    self?.transformacionesButton.isHidden = transformations.count == 0
                }
            }
        }
        
    }
    
    
    @IBAction func didTapTransformations(_ sender: Any) {
        
    }
    
}
