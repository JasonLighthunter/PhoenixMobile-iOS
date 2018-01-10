import UIKit
import PhoenixCoreSwift
import PhoenixKitsuCore
import PhoenixKitsuMedia

class MangaTableViewController: PhoenixTableViewController<Manga> {
  let filters = ["text": "titan"]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Manga"

    do {
      try PhoenixCore.getCollection(withFilters: filters) { (searchResult: SearchResult<Manga>?) in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items.append(contentsOf: result.data ?? [])
            super.addResultToItems(result)
          }
        }
      }
    } catch PhoenixError.invalidURL(let reason, _){
      print(reason) //TODO: handle error
    } catch {
      print(error.localizedDescription)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? MangaDetailViewController {
      detailcontroller.mediaItem = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MangaCell", for: indexPath)

    let manga = items[indexPath.row]

    let titleLanguageEnum = getTitleLanguageEnum()

    cell.textLabel?.text = manga.getTitleWith(identifier: titleLanguageEnum)
    cell.detailTextLabel?.text = manga.attributes?.slug

    return cell
  }
}
