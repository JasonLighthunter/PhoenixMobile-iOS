import UIKit
import PhoenixKitsuMedia

class AnimeTableViewController: PhoenixMediaItemTableViewController<Anime> {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Anime"
    self.cellIdentifier = "AnimeCell"
  }
}
