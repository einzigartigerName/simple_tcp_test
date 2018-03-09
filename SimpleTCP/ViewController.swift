//
//  ViewController.swift
//  SimpleTCP
//
//  Created by Nelson Gillo on 28.02.18.
//  Copyright © 2018 DodoProgramms. All rights reserved.
//

import UIKit
import SwiftSocket
import os.log

class ViewController: UIViewController {
    
    @IBOutlet weak var ipText: UITextField!
    @IBOutlet weak var portText: UITextField!
    @IBOutlet weak var dataText: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var terminal: UITextView!
    
    var client: TCPClient?
    var ip: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func connect(_ sender: Any) {
        if !((ipText.text?.isEmpty)! || (portText.text?.isEmpty)!){
            ip = ipText.text ?? ""
            let port: Int32 = Int32(portText.text ?? "")!
            
            client = TCPClient(address: ip!, port: port)
            var res = client?.connect(timeout: 10)
            if (res?.isSuccess)!{
                statusLabel.text = "Connected"
                statusLabel.textColor = UIColor.green
                terminal.text = terminal.text + "Connected to " + ip! + "\n"
            }
            else{
                statusLabel.text = "No Connection"
                statusLabel.textColor = UIColor.darkText
                terminal.text = terminal.text + "Could not connect to " + ip! + "\n"
            }
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        if client != nil{
            client?.close()
            statusLabel.text = "Disconnected"
            statusLabel.textColor = UIColor.red
            terminal.text = terminal.text + "Disonnected from " + ip! + "\n"
        }
    }
    
    @IBAction func sendData(sender: AnyObject) {
        if !(dataText.text?.isEmpty)!{
            let data: Data = (dataText.text?.data(using: String.Encoding.utf8))!
            let reseve = client?.send(data: data)
            if (reseve?.isSuccess)!{ terminal.text = terminal.text + "Sending.... Done\n"}
            else{ terminal.text = terminal.text + ".. Senden Fehlgeschlagen\n"}
        }
    }
    
    @IBOutlet weak var disconnectButton: UIButton!
    @IBAction func clearAll(_ sender: Any) {
        disconnect(disconnectButton)
        
        statusLabel.text = "No Connection"
        statusLabel.textColor = UIColor.darkText
        
        ipText.text = ""
        portText.text = ""
        dataText.text = ""
        terminal.text = ""
    }
}


