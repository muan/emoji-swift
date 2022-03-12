import Foundation
var endpoint = URL(string: "https://raw.githubusercontent.com/muan/emojilib/main/dist/emoji-en-US.json")!
var fileContents = try String.init(contentsOf: endpoint).data(using: .utf8)!
var decoder = JSONDecoder()
var emojiLib = try decoder.decode(Dictionary<String, [String]>.self, from: fileContents)
var reversedLib: Dictionary<String, [String]> = [:]

for (key, stringArr) in emojiLib {
    for word in stringArr {
        if reversedLib.contains(where: { (key: String, value: [String]) -> Bool in key == word}) {
            reversedLib[word] = reversedLib[word]! + [key]
        } else {
            reversedLib[word] = [key]
        }
    }
}

var keyword = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""

if keyword != "" {
    let matches = search(keyword: keyword)
    if matches.count > 0 {
        for (index, emoji) in matches.enumerated() {
            print("\(index + 1). \(emoji)")
        }
    } else {
        print("no matches")
    }
} else {
    print("keyword thx")
}

func search(keyword: String) -> [String] {
    var matches: [String] = []
    for (key, value) in reversedLib {
        if key.contains(keyword) {
            matches = matches + value
        }
    }
    return matches
}
