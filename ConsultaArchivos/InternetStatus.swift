//
//  InternetStatus.swift
//  ConsultaArchivos
//
//  Created by Oscar Hernandez on 01/06/22.
//

import Network

enum InternetType {
    case none
    case cellular
    case wifi
}

class InternetStatus: NSObject {
    
    static let instance = InternetStatus()
    
    private override init() {
        super.init()
        monitoring()
    }

    var internetType: InternetType = .none
    
    private func monitoring() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                self.internetType = .none
            }
            else {
                if path.usesInterfaceType(.wifi) {
                    self.internetType = .wifi
                }
                else if path.usesInterfaceType(.cellular) {
                    self.internetType = .cellular
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
}
