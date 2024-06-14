//  Created by Alexander Skorulis on 14/6/2024.

import Foundation
import Network

final class BonjourService {
    
    var serverURL: URL?
    
    var browser: NWBrowser = {
        let parameters = NWParameters()
        parameters.includePeerToPeer = true
        return NWBrowser(for: .bonjour(type: "_http._tcp", domain: nil), using: parameters)
    }()
    
    init() {
        startBrowsing()
    }
    
    func startBrowsing() {
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Browser is ready")
            case .failed(let error):
                print("Browser failed with error: \(error.localizedDescription)")
            default:
                break
            }
        }
        
        browser.browseResultsChangedHandler = { results, changes in
            for result in results {
                self.handleFoundService(result)
            }
        }
        
        browser.start(queue: .main)
    }
    
    func handleFoundService(_ result: NWBrowser.Result) {
        
        switch result.endpoint {
        case let .service(name, type, domain, interface):
            print("Found service: \(name), type: \(type), domain: \(domain), interface: \(String(describing: interface))")
            resolveService(endpoint: result.endpoint)
        case let .hostPort(host, port):
            print("Found Host: \(host):\(port)")
        case let .unix(path):
            print("Unix: \(path)")
        case let .url(url):
            print("URL: \(url)")
        case let .opaque(value):
            print("Opaque: \(value)")
        @unknown default:
            break
        }
    }
    
    func resolveService(endpoint: NWEndpoint) {
        guard case let .service(name, type, domain, _) = endpoint else {
            return
        }
        let parameters = NWParameters.tcp
        let serviceEndpoint = NWEndpoint.service(name: name, type: type, domain: domain, interface: nil)
        let connection = NWConnection(to: serviceEndpoint, using: parameters)
        
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Connected to service")
                if let endpoint = connection.currentPath?.remoteEndpoint {
                    if case let .url(url) = endpoint {
                        print("Got URL \(url)")
                    }
                    if case let .hostPort(host, port) = endpoint {
                        let urlString = "http://\(Self.santize(host: host.debugDescription)):\(port)"
                        self.serverURL = URL(string: urlString)
                        
                        print("Connected to", "\(self.serverURL!)")
                    }
                }
            case .failed(let error):
                print("Failed to connect: \(error.localizedDescription)")
            default:
                break
            }
        }
        
        connection.start(queue: .main)
    }
    
    private static func santize(host: String) -> String {
        guard let end = host.firstIndex(of: "%") else {
            return host
        }
        return String(host[host.startIndex..<end])
    }

}
