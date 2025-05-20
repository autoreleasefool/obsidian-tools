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

		init?(node: Yams.Node) {
			self.date = node["date"]?.timestamp ?? Date()
			self.rating = Rating(rawValue: node["rating"]?.int ?? 0) ?? .zero
		}

		init(date: Date, rating: Rating) {
			self.date = date
			self.rating = rating
		}

		func represented() throws -> Node {
			try .init([
				"date": Yams.Node(date.watchDateFormatted, .init(.str), .singleQuoted),
				"rating": Yams.Node(rating.rawValue),
			])
		}
	}
}
