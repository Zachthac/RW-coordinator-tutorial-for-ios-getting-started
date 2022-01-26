import UIKit

class AllKanjiListCoordinator: Coordinator {
    private let presenter: UINavigationController  // 1
    private let allKanjiList: [Kanji]  // 2
    private var kanjiListViewController: KanjiListViewController? // 3
    private let kanjiStorage: KanjiStorage // 4
    private var kanjiDetailCoordinator: KanjiDetailCoordinator?


    init(presenter: UINavigationController, kanjiStorage: KanjiStorage) {
        self.presenter = presenter
        self.kanjiStorage = kanjiStorage
        allKanjiList = kanjiStorage.allKanji()  // 5
    }

    func start() {
        let kanjiListViewController = KanjiListViewController(nibName: nil, bundle: nil) // 6
        kanjiListViewController.delegate = self
        kanjiListViewController.title = "Kanji list"
        kanjiListViewController.kanjiList = allKanjiList
        presenter.pushViewController(kanjiListViewController, animated: true)  // 7

        self.kanjiListViewController = kanjiListViewController

    }
}

// MARK: - KanjiListViewControllerDelegate
extension AllKanjiListCoordinator: KanjiListViewControllerDelegate {
    func kanjiListViewControllerDidSelectKanji(_ selectedKanji: Kanji) {
        let kanjiDetailCoordinator = KanjiDetailCoordinator(presenter: presenter,
                                                            kanji: selectedKanji,
                                                            kanjiStorage: kanjiStorage)
        kanjiDetailCoordinator.start()

        self.kanjiDetailCoordinator = kanjiDetailCoordinator

    }
}
