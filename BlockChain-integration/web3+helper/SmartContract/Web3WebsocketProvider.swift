//
//  File.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/8/21.
//

import Foundation
import Starscream
import web3swift

protocol Web3WebsocketProviderDelegate {
    func socketConnected(_ header: [String:String])
    func receivedMessage(_ message: Any)
    func gotError(_ error: Error)
}


class Web3WebsocketProvider {
    
    private var socket: WebSocket
    private var isSocketConnected: Bool = false
    private var delegate: Web3WebsocketProviderDelegate
    
    private var writeTimer: RepeatingTimer?
    
    init(endPoint: String, delegate: Web3WebsocketProviderDelegate) throws {
        self.delegate = delegate
        guard let url = URL(string: endPoint) else {throw Web3Error.inputError(desc: "end point is not correct")}
        var request = URLRequest(url: url)
//        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    /// Connect socket to end point
    public func connect() {
        socket.connect()
    }
    /// Disconnect socket from end point
    public func disConnect() {
        socket.disconnect()
    }
    /// Check the socket connection state
    public func isConnected() -> Bool {
        return isSocketConnected
    }
    
    
    public func write(_ string: String) {
        if isSocketConnected {
            writeTimer = RepeatingTimer(timeInterval: 1)
            writeTimer?.eventHandler = { [weak self] in
                self?.socket.write(string: string)
            }
            writeTimer?.resume()
        }else {
            print("Error in socket.write: socket is not connected!")
        }
    }
    
    public func writeWithoutTimer(_ string: String){
        socket.write(string: string)
    }
    
    private func resetWriteTimer(){
        guard let _ = writeTimer else {return}
        writeTimer?.suspend()
        writeTimer = nil
    }
    
}

extension Web3WebsocketProvider: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isSocketConnected = true
            delegate.socketConnected(headers)
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
            isSocketConnected = false
            delegate.gotError(Web3Error.connectionError)
        case .text(let string):
            resetWriteTimer()
            delegate.receivedMessage(string)
            break
        case .binary(let data):
            resetWriteTimer()
            print("Received data")
            delegate.receivedMessage(data)
        case .ping(_):
            print("ping")
            break
        case .pong(_):
            print("pong")
            break
        case .viabilityChanged(_):
            print("viabilityChanged")
            break
        case .reconnectSuggested(_):
            print("reconnectSuggested")
            break
        case .cancelled:
            print("cancelled")
            isSocketConnected = false
            delegate.gotError(Web3Error.nodeError(desc: "socket cancelled"))
        case .error(let error):
            isSocketConnected = false
            delegate.gotError(error!)
        }
    }
    
}
