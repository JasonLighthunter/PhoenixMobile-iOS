import UIKit
import PhoenixKitsuMedia

class MangaTableViewController: PhoenixMediaItemTableViewController<Manga> {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Manga"
    self.cellIdentifier = "MangaCell"
  }
}
