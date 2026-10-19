import Foundation

struct CaptureItem: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var createdDate: Date
    var isProcessed: Bool

    init(id: UUID = UUID(), text: String, createdDate: Date = Date(), isProcessed: Bool = false) {
        self.id = id
        self.text = text
        self.createdDate = createdDate
        self.isProcessed = isProcessed
    }
}
