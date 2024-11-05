import ArgumentParser
import Foundation

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
			let importer = ObsidianEntryImporter()
			let files = try await ObsidianFiles(baseDirectory: obsidianArguments.sourceVaultUrl)
			let obsidianEntries = try await importer.findEntries(in: files)
			let letterboxdEntries = obsidianEntries.map(LetterboxdEntry.init(obsidianEntry:))

			var csv = "Title,Year,WatchedDate,Rating,Rewatch\n"
			for entry in letterboxdEntries {
				guard let rating = entry.rating.letterboxdRating else { continue }
				csv += "\(entry.title.escapingCommas),\(entry.releaseYear.orEmptyString),\(entry.date.watchDateFormatted),\(rating),\(entry.rewatch)\n"
			}

			try csv.write(to: outputUrl, atomically: true, encoding: .utf8)
		}
	}
}

extension String {
	var escapingCommas: String {
		self.contains(",") ? "\"\(self)\"" : self
	}
}

extension Optional where Wrapped == Int {
	var orEmptyString: String {
		if let self {
			"\(self)"
		} else {
			""
		}
	}
}
