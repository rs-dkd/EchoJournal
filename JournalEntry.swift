import SwiftUI
import Foundation

struct JournalEntry: Identifiable{
    let id = UUID()
    var date: Date
    var title: String
    var text: String
    var images: [Data] = []
    var emotion: String?
    var emoji: String?
    var recommendations: [String]?
    
    static func == (lhs: JournalEntry, rhs: JournalEntry) -> Bool{
        return lhs.id == rhs.id
    }
}
