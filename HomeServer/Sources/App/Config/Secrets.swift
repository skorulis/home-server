//  Created by Alexander Skorulis on 23/6/2024.

import Foundation

/// Protocol to define what secrets and keys are used in the app. The real version of these values is not checked into the codebase
protocol Secrets {
    var notionKey: String { get }
}
