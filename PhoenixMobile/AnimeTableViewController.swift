import UIKit
import PhoenixCoreSwift
import PhoenixKitsuCore
import PhoenixKitsuMedia

class AnimeTableViewController: PhoenixTableViewController<Anime> {
  let filters: [String : String] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Anime"
    
    do {
      try PhoenixCore.getCollection(withFilters: filters) { (searchResult: SearchResult<Anime>?) in
        if let result = searchResult {
          DispatchQueue.main.async {
            self.items.append(contentsOf: result.data ?? [])
            super.addResultToItems(result)
          }
        }
      }
    } catch PhoenixError.invalidURL(let reason, _){
      print(reason)
    } catch {
      print(error.localizedDescription)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailcontroller = segue.destination as? AnimeDetailViewController {
      detailcontroller.mediaItem = items[self.tableView.indexPathForSelectedRow!.row]
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

    let anime = items[indexPath.row]

    let titleLanguageEnum = getTitleLanguageEnum()

    cell.textLabel?.text = anime.getTitleWith(identifier: titleLanguageEnum)
    cell.detailTextLabel?.text = anime.attributes?.slug

    return cell
  }
}
