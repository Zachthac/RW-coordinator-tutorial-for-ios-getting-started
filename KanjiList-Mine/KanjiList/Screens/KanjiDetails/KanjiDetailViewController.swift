import Foundation
import UIKit

protocol KanjiDetailViewControllerDelegate: class {
    func kanjiDetailViewControllerDidSelectWord(_ word: String)
}

class KanjiDetailViewController: UIViewController {

    weak var delegate: KanjiDetailViewControllerDelegate?

    var selectedKanji: Kanji? {
        didSet {
            DispatchQueue.main.async {
                self.detailTableView?.reloadData()
            }
        }
    }

    @IBOutlet weak var detailTableView: UITableView? {
        didSet {
            guard let detailTableView = detailTableView else { return }
            detailTableView.dataSource = self
            detailTableView.delegate = self

            // Word cell
            let wordCellNib = UINib(nibName: "WordExampleTableViewCell", bundle: nil)
            detailTableView.register(wordCellNib, forCellReuseIdentifier: "WordExampleTableViewCell")

            // Detail cell
            let detailCellNib = UINib(nibName: "KanjiDataTableViewCell", bundle: nil)
            detailTableView.register(detailCellNib, forCellReuseIdentifier: "KanjiDataTableViewCell")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let listViewController = segue.destination as? KanjiListViewController else {

            return
        }

        listViewController.shouldOpenDetailsOnCellSelection = false
        listViewController.word = sender as? String
    }

}

// MARK: - UITableViewDataSource
extension KanjiDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 1: return "Words"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0: return (selectedKanji != nil) ? 1 : 0
        case 1: return selectedKanji?.examples.count ?? 0
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "KanjiDataTableViewCell", for: indexPath)
            (cell as? KanjiDataTableViewCell)?.setupCell(data: selectedKanji)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WordExampleTableViewCell", for: indexPath)
            if let word = selectedKanji?.examples[indexPath.row] {
                (cell as? WordExampleTableViewCell)?.setupCell(data: word)
            }
            return cell
        default:
            fatalError()
        }

    }

}

// MARK: - UITableViewDelegate
extension KanjiDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      defer {
        tableView.deselectRow(at: indexPath, animated: true)
      }

      guard indexPath.section == 1,
        let word = selectedKanji?.examples[indexPath.row].word else {
          return
      }
      delegate?.kanjiDetailViewControllerDidSelectWord(word)
    }


}

