import Foundation
import AppKit

let manager = FileManager()
let decoder = JSONDecoder()

let fileContents = manager.contents(atPath: "./emoji.json")!
let emojiLib = try decoder.decode(Dictionary<String, [String]>.self, from: fileContents)

var keyword = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""

if keyword != "" {
    let matches = search(keyword: keyword)
    if matches.count > 0 {
        for (index, emoji) in matches.enumerated() {
            print("\(index). \(emoji)")
        }

        if matches.count == 1 {
            print("wanna copy it? (Y/n)")
            let decision = readLine() ?? "Y"
            if decision == "" || decision == "Y" {
                copy(emoji: matches[0])
            } else {
                print("bye")
            }
        } else {
            print("which one?")
            let choice = Int(readLine() ?? "") ?? -1
            if choice > 0 && choice <= matches.count - 1 {
                copy(emoji: matches[choice])
            } else {
                print("i don't know what that is. bye")
            }
        }
    } else {
        print("no matches")
    }
} else {
    print("keyword thx")
}

func search(keyword: String) -> [String] {
    var matches: [String] = []
    for (key, value) in emojiLib {
        if key.contains(keyword) {
            matches = matches + value
        }
    }
    return matches
}


func copy(emoji: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(emoji, forType: .string)
    print("copied. have a good day")
}
