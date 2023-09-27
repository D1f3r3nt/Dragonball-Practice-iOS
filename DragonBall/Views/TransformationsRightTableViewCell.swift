import UIKit

class TransformationsRightTableViewCell: UITableViewCell {
    static let identifier: String = "TransformationsRightTableViewCell"
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(transformation: Transformation) {
        backgroundImage.layer.zPosition = -1 // Para que se ponga al fondo
        backgroundImage.alpha = 0.5 // 50% transparencia
        
        backgroundImage.setImage(for: transformation.photo)
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
    }
    
}
