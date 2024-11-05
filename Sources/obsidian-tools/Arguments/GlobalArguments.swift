import ArgumentParser
import Foundation

struct GlobalArguments: ParsableArguments {
	@Flag(name: [.long, .short]) var verbose = false
}
