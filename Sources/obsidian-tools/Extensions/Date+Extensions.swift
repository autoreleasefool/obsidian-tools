import Foundation

extension Date {
	public static let yyyyMMddFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	var watchDateFormatted: String {
		Self.yyyyMMddFormatter.string(from: self)
	}
}
