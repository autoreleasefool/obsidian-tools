import Foundation
import Yams

extension Obsidian.Document {
	struct MovieEntry {
	}
}

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

extension Obsidian.Document.Frontmatter {
	var movieTitle: String? {
		get { yaml["movie-title"]?.string }
		set { yaml["movie-title"] = try! Yams.Node(newValue) }
	}

	var movieReleaseYear: Int? {
		get { yaml["movie-year"]?.int }
		set { yaml["movie-year"] = try! Yams.Node(newValue) }
	}

	var movieMetrics: [ObsidianMovieEntry.Metric]? {
		get { yaml["movie-metrics"]?.array().compactMap(ObsidianMovieEntry.Metric.init) }
		set { yaml["movie-metrics"] = try! Yams.Node(newValue) }
	}

	var movieLetterboxdUri: URL? {
		get { yaml["letterboxd-uri"]?.url }
		set { yaml["letterboxd-uri"] = try! Yams.Node(newValue?.absoluteString) }
	}
}

extension ObsidianMovieEntry {
	struct Metric: NodeRepresentable {
		var date: Date
		var rating: Rating
		var pushedToLetterboxd: Bool

		init?(node: Yams.Node) {
			self.date = Date.obsidianDateFormatter.date(from: node["date"]?.string ?? "") ?? Date()
			self.rating = Rating(rawValue: node["rating"]?.int ?? 0) ?? .zero
			self.pushedToLetterboxd = node["pushed-to-lbx"]?.bool ?? false
		}

		init(date: Date, rating: Rating, pushedToLetterboxd: Bool) {
			self.date = date
			self.rating = rating
			self.pushedToLetterboxd = pushedToLetterboxd
		}

		func represented() throws -> Node {
			try .init([
				"date": Yams.Node(date.obsidianDate, .init(.str), .singleQuoted),
				"rating": Yams.Node(rating.rawValue),
				"pushed-to-lbx": Yams.Node(pushedToLetterboxd)
			])
		}
	}
}
