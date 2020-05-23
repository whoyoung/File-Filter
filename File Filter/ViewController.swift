//
//  ViewController.swift
//  File Filter
//
//  Created by young on 2020/5/23.
//  Copyright © 2020 young. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    private let destPathLabel = NSTextField()
    private let specificFolderLabel = NSTextField()
    
    @IBOutlet weak var specificFolderBtn: NSButton!
    
    @IBAction func folderBtnClicked(_ sender: NSButton) {
        debugPrint("current state = \(sender.state)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    private func setupSubviews() {
        let destName = NSTextField(string: "Select destination folder:")
        destName.isBordered = false
        destName.isEditable = false
        destName.backgroundColor = NSColor.clear
        view.addSubview(destName)
        destName.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.height.equalTo(20)
        }
        
        destPathLabel.placeholderString = "required"
        destPathLabel.lineBreakMode = .byTruncatingMiddle
        view.addSubview(destPathLabel)
        destPathLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(destName)
            make.left.equalTo(destName.snp.right).offset(15)
        }
        
        let destBtn = NSButton(title: "Select folder", target: self, action: #selector(selectFolder))
        view.addSubview(destBtn)
        destBtn.snp.makeConstraints { (make) in
            make.top.height.equalTo(destName)
            make.left.equalTo(destPathLabel.snp.right).offset(15)
            make.right.equalTo(-20)
        }
        
        let specificFolder = NSTextField(string: "Specific folder names:")
        specificFolder.isBordered = false
        specificFolder.isEditable = false
        specificFolder.backgroundColor = NSColor.clear
        view.addSubview(specificFolder)
        specificFolder.snp.makeConstraints { (make) in
            make.top.equalTo(destName.snp.bottom).offset(20)
            make.left.height.equalTo(destName)
        }
        
        specificFolderLabel.placeholderString = "input or select specific folder names,separated by ','"
        specificFolderLabel.lineBreakMode = .byTruncatingTail
        view.addSubview(specificFolderLabel)
        specificFolderLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(specificFolder)
            make.left.equalTo(specificFolder.snp.right).offset(15)
        }
        
        specificFolderBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(specificFolder)
            make.height.width.equalTo(27)
            make.left.equalTo(specificFolderLabel.snp.right).offset(15)
            make.right.equalTo(destBtn)
        }
    }
    
    @objc private func selectFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        if openPanel.runModal() == NSApplication.ModalResponse.OK {
            destPathLabel.stringValue = (openPanel.directoryURL?.path)!
        }
    }
    
}

