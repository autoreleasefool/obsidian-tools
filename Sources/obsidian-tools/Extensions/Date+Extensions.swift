import Foundation

extension Date {
	public static let obsidianDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	var obsidianDate: String {
		Self.obsidianDateFormatter.string(from: self)
	}
}
