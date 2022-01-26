import UIKit

class KanjiDetailCoordinator: Coordinator {
    private let presenter: UINavigationController  // 1
    private var kanjiDetailViewController: KanjiDetailViewController? // 2
    private var wordKanjiListViewController: KanjiListViewController? // 3
    private let kanjiStorage: KanjiStorage  // 4
    private let kanji: Kanji  // 5

    init(presenter: UINavigationController, // 6
         kanji: Kanji,
         kanjiStorage: KanjiStorage) {

        self.kanji = kanji
        self.presenter = presenter
        self.kanjiStorage = kanjiStorage
    }

    func start() {
        let kanjiDetailViewController = KanjiDetailViewController(nibName: nil, bundle: nil) // 7
        kanjiDetailViewController.delegate = self
        kanjiDetailViewController.title = "Kanji details"
        kanjiDetailViewController.selectedKanji = kanji

        presenter.pushViewController(kanjiDetailViewController, animated: true) // 8
        self.kanjiDetailViewController = kanjiDetailViewController
    }
}

// MARK: - KanjiDetailViewControllerDelegate
extension KanjiDetailCoordinator: KanjiDetailViewControllerDelegate {
  func kanjiDetailViewControllerDidSelectWord(_ word: String) {
    let wordKanjiListViewController = KanjiListViewController(nibName: nil, bundle: nil)
    let kanjiForWord = kanjiStorage.kanjiForWord(word)
    wordKanjiListViewController.kanjiList = kanjiForWord
    wordKanjiListViewController.title = word

    presenter.pushViewController(wordKanjiListViewController, animated: true)
  }
}

