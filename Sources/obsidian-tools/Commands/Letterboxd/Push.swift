import ArgumentParser
import SwiftCSV
import Foundation
import OSLog
import Yams

extension ObsidianTools.Letterboxd {
	struct Push: AsyncParsableCommand {
		@OptionGroup var obsidianArguments: ObsidianArguments
		@OptionGroup var globalArguments: GlobalArguments

		@Argument(
			help: "Output CSV file",
			completion: .file(),
			transform: { URL(filePath: $0, directoryHint: .notDirectory) }
		)
		var outputUrl: URL

		mutating func run() async throws {
			var entries: [ObsidianMovieEntry] = []

			for var document in Obsidian.Vault.enumerateDocuments(in: obsidianArguments.sourceVaultUrl) {
				guard document.frontmatter.tags.contains("media/movie") else {
					verboseLog("Document \(document.url) is not a movie entry")
					continue
				}

				verboseLog("Adding movie metrics from \(document.url)")

				entries.append(
					contentsOf: document.frontmatter.movieMetrics?
						.filter { !$0.pushedToLetterboxd }
						.sorted(using: KeyPathComparator(\.date))
						.enumerated()
						.map { index, metric in
							ObsidianMovieEntry(
								title: document.frontmatter.movieTitle ?? document.title,
								releaseYear: document.frontmatter.movieReleaseYear,
								date: metric.date,
								rating: metric.rating,
								rewatch: index != 0,
								letterboxdUri: document.frontmatter.movieLetterboxdUri
							)
						} ?? []
				)

				document.frontmatter.movieMetrics = document.frontmatter.movieMetrics?
					.map { metric in
						ObsidianMovieEntry.Metric(
							date: metric.date,
							rating: metric.rating,
							pushedToLetterboxd: true
						)
					} ?? []

				try document.contents.write(to: document.url, atomically: true, encoding: .utf8)
			}

			entries.sort(using: KeyPathComparator(\.title))

			var csv = "Title,Year,WatchedDate,Rating,Rewatch,Letterboxd URI\n"
			for entry in entries {
				guard let rating = entry.rating.letterboxdRating else { continue }
				csv += "\(entry.title.escapingCommas),\(entry.releaseYear.orEmptyString),\(entry.date.obsidianDate),\(rating),\(entry.rewatch),\(entry.letterboxdUri.orEmptyString)\n"
			}

			try csv.write(to: outputUrl, atomically: true, encoding: .utf8)
		}

		private func verboseLog(_ log: String) {
			if globalArguments.verbose {
				print(log)
			}
		}
	}
}

extension String {
	var escapingCommas: String {
		self.contains(",") ? "\"\(self)\"" : self
	}
}

extension Optional {
	var orEmptyString: String {
		if let self {
			"\(self)"
		} else {
			""
		}
	}
}
