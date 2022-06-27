//
//  WalletConnect.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/20/21.
//


import Foundation
//import WalletConnectSwift
//
//protocol WalletConnectDelegate {
//    func failedToConnect()
//    func didConnect(url: String)
//    func didDisconnect()
//}
//
//class WalletConnect {
//    var client: Client!
//    var session: Session!
//    var delegate: WalletConnectDelegate
//
//    let sessionKey = "sessionKey"
//    static let safeKeyPrefix = "gnosissafe".data(using: .utf8)!.toHexString()
//
//    init(delegate: WalletConnectDelegate) {
//        self.delegate = delegate
//    }
//
//    func connect() -> String {
//        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
//        // test bridge with latest protocol version: https://bridge.walletconnect.org
//        // "https://safe.gnosis.io"
//        let bridge = "https://safe-walletconnect.gnosis.io/"
//        let key = try! randomKey().replacingCharacters(in: ..<Self.safeKeyPrefix.endIndex, with: Self.safeKeyPrefix)
//
//        let wcUrl =  WCURL(topic: UUID().uuidString,
//                           bridgeURL: URL(string: bridge)!,
//                           key: key)
//        let clientMeta = Session.ClientMeta(name: "AmirDapp",
//                                            description: "WalletConnectSwift ",
//                                            icons: [],
//                                            url: URL(string: bridge)!)
//        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
//        client = Client(delegate: self, dAppInfo: dAppInfo)
//
//        print("WalletConnect URL: \(wcUrl.absoluteString)")
//
//        try! client.connect(to: wcUrl)
//        return wcUrl.absoluteString
//    }
//
//    func reconnectIfNeeded() {
//        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
//            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
//            client = Client(delegate: self, dAppInfo: session.dAppInfo)
//            try? client.reconnect(to: session)
//        }
//    }
//
//    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
//    private func randomKey() throws -> String {
//        var bytes = [Int8](repeating: 0, count: 32)
//        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
//        if status == errSecSuccess {
//            return Data(bytes: bytes, count: 32).toHexString()
//        } else {
//            // we don't care in the example app
//            enum TestError: Error {
//                case unknown
//            }
//            throw TestError.unknown
//        }
//    }
//}
//
//extension WalletConnect: ClientDelegate {
//    func client(_ client: Client, didFailToConnect url: WCURL) {
//        UserDefaults.standard.removeObject(forKey: sessionKey)
//        delegate.failedToConnect()
//    }
//
//    func client(_ client: Client, didConnect url: WCURL) {
//        // do nothing
////        delegate.didConnect(url: "url.absoluteString")
//    }
//
//    func client(_ client: Client, didConnect session: Session) {
//        print("session")
//        self.session = session
//        let sessionData = try! JSONEncoder().encode(session)
//        UserDefaults.standard.set(sessionData, forKey: sessionKey)
//        delegate.didConnect(url: "")
//    }
//
//    func client(_ client: Client, didDisconnect session: Session) {
//        UserDefaults.standard.removeObject(forKey: sessionKey)
//        UserDefaults.standard.synchronize()
//        delegate.didDisconnect()
//
//    }
//
//    func client(_ client: Client, didUpdate session: Session) {
//        // do nothing
//    }
//}
