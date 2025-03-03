//
//  NetworkMonitor.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/13.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .unknown
    
    // 网络状态变化回调
    var onNetworkStatusChanged: ((Bool, ConnectionType) -> Void)?

    enum ConnectionType {
        case wifi, cellular, ethernet, unknown
    }
    
    private init() {
        // 设置网络状态更新处理
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateNetworkStatus(path)
            }
        }
        
        // 在后台队列启动网络监听
        monitor.start(queue: queue)
        
        // 确保在monitor启动后更新初始状态
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateNetworkStatus(self.monitor.currentPath)
        }
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func updateNetworkStatus(_ path: NWPath) {
        self.isConnected = path.status == .satisfied
        self.connectionType = self.getConnectionType(path)
        
        // 触发状态变化回调
        self.onNetworkStatusChanged?(self.isConnected, self.connectionType)
        
        print("📡 网络状态更新: \(self.isConnected ? "在线" : "离线") - \(self.connectionType)")
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        }
        return .unknown
    }
}
