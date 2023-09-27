import UIKit

final class HomeTableViewCell: UITableViewCell {

    static let identifier = "HomeTableViewCell"
    
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    
    func configure(with hero: Hero) {
        title.text = hero.name
        body.text = hero.description
        imageUrl.setImage(for: hero.photo)
    }
    
}
