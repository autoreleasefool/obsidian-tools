import ArgumentParser
import Foundation
import SwiftCSV
import Yams

extension ObsidianTools.Letterboxd {
	struct Pull: AsyncParsableCommand {
		@OptionGroup var obsidianArguments: ObsidianArguments
		@OptionGroup var globalArguments: GlobalArguments

		@Argument(
			help: "Input CSV file",
			completion: .file(),
			transform: { URL(filePath: $0, directoryHint: .notDirectory) }
		)
		var inputUrl: URL

		mutating func run() async throws {
			let ratings = try CSV<Named>(url: inputUrl)

			let isVerboseLoggingEnabled = globalArguments.verbose
			func verboseLog(_ log: String) {
				if isVerboseLoggingEnabled {
					print(log)
				}
			}

			var letterboxdEntries: [String: [LetterboxdEntry]] = [:]
			try ratings.enumerateAsDict { rating in
				guard let dateStr = rating["Watched Date"],
							let name = rating["Name"],
							let yearStr = rating["Year"],
							let letterboxdUriStr = rating["Letterboxd URI"],
							let ratingStr = rating["Rating"] else {
					verboseLog("Could not parse row \(rating)")
					return
				}

				guard let date = Date.yyyyMMddFormatter.date(from: dateStr) else {
					verboseLog("Could not parse date \(dateStr)")
					return
				}

				print(letterboxdUriStr)

				letterboxdEntries[name, default: []].append(
					LetterboxdEntry(
						title: name,
						releaseYear: Int(yearStr),
						date: date,
						rating: Rating(letterboxdRating: ratingStr) ?? .zero,
						rewatch: rating["Rewatch"] == "Yes",
						letterboxdUri: URL(string: letterboxdUriStr)
					)
				)
			}

			let encoder = YAMLEncoder()
			let decoder = YAMLDecoder()
			try enumerateDocuments(in: obsidianArguments.sourceVaultUrl) { document in
//				print("\(document.url)")
//				guard let rawFrontmatter = document.frontmatter,
//							var frontmatter = try? decoder.decode(Obsidian.Document..Frontmatter.self, from: rawFrontmatter) else {
//					verboseLog("Invalid frontmatter \(document.url)")
//					return
//				}
//
//				guard frontmatter.tags?.contains("media/movie") == true else {
//					verboseLog("Document \(document.url) is not a movie")
//					return
//				}
//
//				guard let entries = letterboxdEntries[frontmatter.title ?? document.title], let firstEntry = entries.first else {
//					print("has no entry \(frontmatter.title ?? document.title)")
//					return
//				}
//
////				frontmatter.releaseYear = firstEntry.releaseYear
////				frontmatter.letterboxdUri = firstEntry.letterboxdUri
//				print(frontmatter.letterboxdUri)

//				try document.frontmatter = encoder.encode(frontmatter)
			}
		}
	}
}
