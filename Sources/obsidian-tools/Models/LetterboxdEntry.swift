import Foundation

struct LetterboxdEntry {
	let title: String
	let releaseYear: Int?
	let date: Date
	let rating: Rating
	let rewatch: Bool
	let letterboxdUri: URL?

	init(obsidianEntry: ObsidianEntry) {
		self.title = obsidianEntry.title
		self.releaseYear = obsidianEntry.releaseYear
		self.date = obsidianEntry.date
		self.rating = obsidianEntry.rating
		self.rewatch = obsidianEntry.rewatch
		self.letterboxdUri = obsidianEntry.letterboxdUri
	}
}
