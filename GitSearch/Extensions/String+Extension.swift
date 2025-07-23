import Foundation

extension String {
	var formattedDate: String {
		let isoFormatter = ISO8601DateFormatter()
		let displayFormatter = DateFormatter()
		displayFormatter.dateStyle = .medium
		displayFormatter.timeStyle = .none

		if let date = isoFormatter.date(from: self) {
			return displayFormatter.string(from: date)
		}
		return self
	}
}
