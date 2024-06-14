//  Created by Alexander Skorulis on 14/6/2024.

import Foundation

final class BonjourService: NSObject, NetServiceDelegate {
    
    static let shared = BonjourService()
    
    private let service = NetService(domain: "local.", type: "_http._tcp.", name: "sk-home", port: 8080)
    
    override init() {}
    
    func start() {
        service.publish()
        print("Bonjour service published: \(service)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("Service Published: domain=\(sender.domain) type=\(sender.type) name=\(sender.name) port=\(sender.port)")
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Failed to publish service: \(errorDict)")
    }

    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let addresses = sender.addresses else { return }
        for address in addresses {
            let data = address as NSData
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(data.bytes.bindMemory(to: sockaddr.self, capacity: data.length), socklen_t(data.length), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let ipAddress = String(cString: hostname)
                print("Resolved IP Address: \(ipAddress)")
            }
        }
    }
}
