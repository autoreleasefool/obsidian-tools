// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "obsidian-tools",
	platforms: [
		.macOS(.v14),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
		.package(url: "https://github.com/jpsim/Yams.git", from: "6.0.0"),
		.package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.3.1"),
		.package(url: "https://github.com/swiftcsv/SwiftCSV", from: "0.10.0"),
	],
	targets: [
		.executableTarget(
			name: "obsidian-tools",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
				.product(name: "SwiftCSV", package: "SwiftCSV"),
				.product(name: "Yams", package: "yams"),
			]
		),
		.testTarget(
			name: "obsidian-toolsTests",
			dependencies: [
				"obsidian-tools",
			]
		)
	]
)
