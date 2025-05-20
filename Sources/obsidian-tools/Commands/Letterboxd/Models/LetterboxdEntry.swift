import Foundation

struct LetterboxdEntry {
	let title: String
	let releaseYear: Int
	let letterboxdUri: URL
	let rating: Rating
	let rewatch: Bool
	let date: Date

	init?(data: [String: String]) {
		guard let title = data["Name"],
					let releaseYearStr = data["Year"],
					let releaseYear = Int(releaseYearStr),
					let letterboxdUriStr = data["Letterboxd URI"],
					let letterboxdUri = URL(string: letterboxdUriStr),
					let ratingStr = data["Rating"],
					let rating = Rating(letterboxdRating: ratingStr),
					let dateStr = data["Watched Date"],
					let date = Date.yyyyMMddFormatter.date(from: dateStr),
					let rewatchStr = data["Rewatch"] else {
			return nil
		}

		self.title = title
		self.releaseYear = releaseYear
		self.letterboxdUri = letterboxdUri
		self.rating = rating
		self.date = date
		self.rewatch = rewatchStr.lowercased() == "yes" || rewatchStr.lowercased() == "true"
	}
}
