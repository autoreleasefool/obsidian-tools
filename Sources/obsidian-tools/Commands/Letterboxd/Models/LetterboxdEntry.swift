import Foundation

struct LetterboxdEntry {
	let title: String
	let releaseYear: Int?
	let date: Date
	let rating: Rating
	let rewatch: Bool
	let letterboxdUri: URL?

	init(title: String, releaseYear: Int? = nil, date: Date, rating: Rating, rewatch: Bool, letterboxdUri: URL? = nil) {
		self.title = title
		self.releaseYear = releaseYear
		self.date = date
		self.rating = rating
		self.rewatch = rewatch
		self.letterboxdUri = letterboxdUri
	}

	init(obsidianEntry: ObsidianMovieEntry) {
		self.title = obsidianEntry.title
		self.releaseYear = obsidianEntry.releaseYear
		self.date = obsidianEntry.date
		self.rating = obsidianEntry.rating
		self.rewatch = obsidianEntry.rewatch
		self.letterboxdUri = obsidianEntry.letterboxdUri
	}
}
