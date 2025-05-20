import Foundation

extension Obsidian {
	enum Vault {
		static func enumerateDocuments(in vaultUrl: URL) -> any Sequence<Document> {
			AnySequence {
				let enumerator = FileManager.default.enumerator(at: vaultUrl, includingPropertiesForKeys: nil)
				return AnyIterator {
					while let file = enumerator?.nextObject() as? URL {
						if file.pathExtension == "md" {
							return try? Document(url: file)
						}
					}

					return nil
				}
			}
		}
	}
}
