import Foundation

func enumerateDocuments(
	in vaultUrl: URL,
	perform: (inout Obsidian.Document) throws -> Void
) throws {
	guard let files = FileManager.default.enumerator(at: vaultUrl, includingPropertiesForKeys: nil) else {
		return
	}

	for case let file as URL in files where file.pathExtension == "md" {
		let originalDocument = try Obsidian.Document(url: file)
		var document = originalDocument

		try perform(&document)

		if document != originalDocument {
			try document.contents.write(to: file, atomically: true, encoding: .utf8)
		}
	}
}
