import Foundation

struct KanjiCache {
  let kanjiArray: [Kanji]
  let kanjiDictionary: [String: Kanji]
}

// Provides kanji data from JSON
class KanjiStorage {
  
  static let sharedStorage = KanjiStorage()
  static let kanjiURL = Bundle.main.url(forResource: "knji", withExtension: "json")!
  
  private let allKanjiFromJSON: KanjiCache
  
  init() {
    
    // Parse json and store it's data
    let data = try! Data(contentsOf: KanjiStorage.kanjiURL)
    let allKanjis = try! JSONDecoder().decode([Kanji].self, from: data)
    
    let kanjiDictionary = allKanjis.reduce([:]) { (dictionary, kanji) -> [String: Kanji] in
      var dictionary = dictionary
      dictionary[kanji.character] = kanji
      return dictionary
    }
    
    // Save new cache
    allKanjiFromJSON = KanjiCache(kanjiArray: allKanjis, kanjiDictionary: kanjiDictionary)
  }
  
  func allKanji() -> [Kanji] {
    
    return allKanjiFromJSON.kanjiArray
  }
  
  func kanjiForWord(_ word: String) -> [Kanji] {
    
    let kanjiInWord: [Kanji] = word.compactMap { (character) -> Kanji? in
      
      let kanjiForCharacter = allKanjiFromJSON.kanjiDictionary["\(character)"]
      return kanjiForCharacter
    }
    
    return kanjiInWord
  }
  
}
