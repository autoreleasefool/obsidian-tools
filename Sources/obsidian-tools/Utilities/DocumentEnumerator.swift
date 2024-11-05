import Foundation

func enumerateDocuments(
	in vaultUrl: URL,
	perform: (Obsidian.Document) -> Void
) throws {
	guard let files = FileManager.default.enumerator(at: vaultUrl, includingPropertiesForKeys: nil) else {
		return
	}

	for case let file as URL in files where file.pathExtension == "md" {
		let document = try Obsidian.Document(url: file)
		perform(document)
	}
}
