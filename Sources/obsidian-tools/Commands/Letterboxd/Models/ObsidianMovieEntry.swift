import Foundation

struct ObsidianMovieEntry {
	let title: String
	let releaseYear: Int?
	let date: Date
	let rating: Rating
	let rewatch: Bool
	let letterboxdUri: URL?

	init(title: String, releaseYear: Int?, date: Date, rating: Rating, rewatch: Bool, letterboxdUri: URL?) {
		self.title = title
		self.releaseYear = releaseYear
		self.date = date
		self.rating = rating
		self.rewatch = rewatch
		self.letterboxdUri = letterboxdUri
	}

	init(letterboxdEntry: LetterboxdEntry) {
		self.title = letterboxdEntry.title
		self.releaseYear = letterboxdEntry.releaseYear
		self.date = letterboxdEntry.date
		self.rating = letterboxdEntry.rating
		self.rewatch = letterboxdEntry.rewatch
		self.letterboxdUri = letterboxdEntry.letterboxdUri
	}
}

extension ObsidianMovieEntry {
	struct Frontmatter: Codable {
		let title: String?
		let releaseYear: Int?
		let tags: [String]
		let metrics: [Metric]
		let letterboxdUri: URL?
	}
}

extension ObsidianMovieEntry.Frontmatter {
	struct Metric: Codable {
		let date: Date
		let rating: Rating

		enum CodingKeys: CodingKey {
			case date
			case rating
		}

		init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)

			let dateStr = try container.decode(String.self, forKey: .date)
			guard let date = Date.yyyyMMddFormatter.date(from: dateStr) else {
				throw DecodingError.typeMismatch(String.self, .init(codingPath: [], debugDescription: ""))
			}

			self.date = date
			self.rating = try container.decode(Rating.self, forKey: .rating)
		}

		func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(date.watchDateFormatted, forKey: .date)
			try container.encode(self.rating, forKey: .rating)
		}
	}
}
