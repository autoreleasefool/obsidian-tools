enum Obsidian {}

extension Obsidian {
	enum Error: Swift.Error {
		case invalidVaultURL
		case invalidFrontmatter
	}
}
