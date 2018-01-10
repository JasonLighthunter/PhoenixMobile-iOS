import UIKit
import PhoenixKitsuMedia

class AnimeTableViewController: PhoenixTableViewController<Anime> {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Anime"
  }
}
