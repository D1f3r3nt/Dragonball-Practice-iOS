import UIKit

class DetailsViewController: UIViewController {
    
    private var header: String
    private var desc: String
    private var photo: URL
    private var isHero: Bool
    
    init(
        title: String,
        description: String,
        photo: URL,
        isHero: Bool
    ) {
        self.header = title
        self.desc = description
        self.photo = photo
        self.isHero = isHero
        
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
        
        imagePrincipal.setImage(for: photo)
        titleLable.text = header
        descriptionLabel.text = desc
        title = header
        
        
    }
    
    
    @IBAction func didTapTransformations(_ sender: Any) {
    }
    
}
