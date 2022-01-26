import UIKit

protocol KanjiListViewControllerDelegate: class {
    func kanjiListViewControllerDidSelectKanji(_ selectedKanji: Kanji)
}

class KanjiListViewController: UIViewController {

    @IBOutlet weak var kanjiListTableView: UITableView! {
        didSet {
            kanjiListTableView?.dataSource = self
            kanjiListTableView?.delegate = self
        }
    }

    weak var delegate: KanjiListViewControllerDelegate?


    var kanjiList: [Kanji] = KanjiStorage.sharedStorage.allKanji() {
        didSet {
            kanjiListTableView?.reloadData()
        }
    }

    var shouldOpenDetailsOnCellSelection = true

    var word: String? {
        didSet {
            guard let word = word else {
                return
            }
            kanjiList = KanjiStorage.sharedStorage.kanjiForWord(word)
            title = word
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailKanjiViewControler = segue.destination as? KanjiDetailViewController,
              let kanji = sender as? Kanji else{
                  return
              }
        detailKanjiViewControler.selectedKanji = kanji
    }

}

extension KanjiListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjiList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ListItem") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ListItem")
        }
        let kanji = kanjiList[indexPath.row]
        cell.textLabel?.text = kanji.character
        cell.detailTextLabel?.text = kanji.meaning
        cell.accessoryType = shouldOpenDetailsOnCellSelection ? .disclosureIndicator : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let kanji = kanjiList[indexPath.row]
      delegate?.kanjiListViewControllerDidSelectKanji(kanji)
      tableView.deselectRow(at: indexPath, animated: true)
    }



}

