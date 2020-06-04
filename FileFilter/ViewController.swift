//
//  ViewController.swift
//  FileFilter
//
//  Created by young on 2020/5/23.
//  Copyright © 2020 young. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    private var allContents: [String] = []
    private var filtContents: [String] = []
    private let fileManager = FileManager.default
    
    private let destPathLabel = NSTextField()
    private let specificFolderLabel = NSTextField()
    private let fileTypeLabel = NSTextField()
    private let minSizeLabel = NSTextField()
    private let maxSizeLabel = NSTextField()
    private let KSpecificFolderNamesKey = "specificFolderNames"
    private let KFileTypeKey = "fileTypeKey"
    private let KSizeUnitKey = "sizeUnitKey"

    private var folderDatas: [String] = []
    private var typeDatas: [String] = []
    private var unitDatas: [String] = []
    
    @IBOutlet weak var folderBox: NSComboBox!
    @IBOutlet weak var typeBox: NSComboBox!
    @IBOutlet weak var minSizeBox: NSComboBox!
    @IBOutlet weak var maxSizeBox: NSComboBox!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatas()
        setupSubviews()
    }

    private func setupSubviews() {
        let destName = NSTextField(labelWithString: "Select destination folder:")
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
        
        let specificFolder = NSTextField(labelWithString: "Specific folder names:")
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
        
        folderBox.delegate = self
        folderBox.dataSource = self
        folderBox.placeholderString = "quick select"
        view.addSubview(folderBox)
        folderBox.snp.makeConstraints { (make) in
            make.centerY.equalTo(specificFolder)
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.left.equalTo(specificFolderLabel.snp.right).offset(15)
            make.right.equalTo(destBtn)
        }
        
        let fileType = NSTextField(labelWithString: "Specific file types:")
        fileType.backgroundColor = NSColor.clear
        view.addSubview(fileType)
        fileType.snp.makeConstraints { (make) in
            make.top.equalTo(specificFolder.snp.bottom).offset(20)
            make.left.height.equalTo(destName)
        }
        
        fileTypeLabel.placeholderString = "input or select file types,separated by ','"
        fileTypeLabel.lineBreakMode = .byTruncatingTail
        view.addSubview(fileTypeLabel)
        fileTypeLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(fileType)
            make.left.equalTo(fileType.snp.right).offset(15)
        }
        
        typeBox.delegate = self
        typeBox.dataSource = self
        typeBox.placeholderString = "quick select"
        view.addSubview(typeBox)
        typeBox.snp.makeConstraints { (make) in
            make.centerY.equalTo(fileType)
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.left.equalTo(fileTypeLabel.snp.right).offset(15)
            make.right.equalTo(destBtn)
        }
        
        let minSize = NSTextField(labelWithString: "minimum file size:")
        minSize.backgroundColor = NSColor.clear
        view.addSubview(minSize)
        minSize.snp.makeConstraints { (make) in
            make.top.equalTo(fileType.snp.bottom).offset(20)
            make.left.height.equalTo(destName)
        }
        
        minSizeLabel.placeholderString = "input minimus file size, default 0"
        minSizeLabel.lineBreakMode = .byTruncatingTail
        view.addSubview(minSizeLabel)
        minSizeLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(minSize)
            make.left.equalTo(minSize.snp.right).offset(15)
        }
        
        minSizeBox.dataSource = self
        minSizeBox.placeholderString = "select unit"
        view.addSubview(minSizeBox)
        minSizeBox.snp.makeConstraints { (make) in
            make.centerY.equalTo(minSize)
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.left.equalTo(minSizeLabel.snp.right).offset(15)
            make.right.equalTo(destBtn)
        }
        minSizeBox.selectItem(at: 1)
        
        let maxSize = NSTextField(labelWithString: "maximum file size:")
        maxSize.backgroundColor = NSColor.clear
        view.addSubview(maxSize)
        maxSize.snp.makeConstraints { (make) in
            make.top.equalTo(minSize.snp.bottom).offset(20)
            make.left.height.equalTo(destName)
        }
        
        maxSizeLabel.placeholderString = "input maximum file size, should >= minSize"
        maxSizeLabel.lineBreakMode = .byTruncatingTail
        view.addSubview(maxSizeLabel)
        maxSizeLabel.snp.makeConstraints { (make) in
            make.top.height.equalTo(maxSize)
            make.left.equalTo(maxSize.snp.right).offset(15)
        }
        
        maxSizeBox.dataSource = self
        maxSizeBox.placeholderString = "select unit"
        view.addSubview(maxSizeBox)
        maxSizeBox.snp.makeConstraints { (make) in
            make.centerY.equalTo(maxSize)
            make.height.equalTo(20)
            make.width.equalTo(150)
            make.left.equalTo(maxSizeLabel.snp.right).offset(15)
            make.right.equalTo(destBtn)
        }
        maxSizeBox.selectItem(at: 1)
        
        let startBtn = NSButton(title: "start", target: self, action: #selector(startFilt))
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.top.equalTo(maxSizeBox.snp.bottom).offset(20)
            make.height.width.equalTo(destBtn)
            make.right.equalTo(-20)
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
    
    @objc private func startFilt() {
        let path = destPathLabel.stringValue
        do {
            self.allContents = try fileManager.subpathsOfDirectory(atPath: path)
            self.filtAllContents()
            debugPrint("self.filtAllContents() = \(self.filtContents)")
        } catch let error {
            debugPrint("open \(path) error:\n \(error.localizedDescription)")
            return
        }
        
    }
    
    private func filtAllContents() {
        self.filtContents = self.allContents.compactMap { (name) -> String? in
            let fullPath = self.destPathLabel.stringValue + "/" + name
            var isDirectory: ObjCBool =  ObjCBool(false)
            if fileManager.fileExists(atPath: fullPath, isDirectory: &isDirectory) == false {
                return nil
            }
            if isDirectory.boolValue == true {
                return nil
            }
            if specificFolderLabel.stringValue.isEmpty != true {
                let specialFolders = (specificFolderLabel.stringValue as NSString).components(separatedBy: ",")
                
                let folder = specialFolders.first { (specialName) -> Bool in
                    return name.contains("\(specialName)/")
                }
                if folder == nil {
                    return nil
                }
            }
            if fileTypeLabel.stringValue.isEmpty != true {
                let fileTypes = (fileTypeLabel.stringValue as NSString).components(separatedBy: ",")
                let filtType = fileTypes.first { (type) -> Bool in
                    return name.hasSuffix(".\(type)")
                }
                if filtType == nil {
                    return nil
                }
            }
            
            if minSizeLabel.stringValue.isEmpty != true || maxSizeLabel.stringValue.isEmpty != true {
                let data = fileManager.contents(atPath: fullPath)
                if data == nil {
                    return nil
                }
                if let count = data?.count {
                    if minSizeLabel.stringValue.isEmpty != true {
                        var minSize = (minSizeLabel.stringValue as NSString).intValue
                        let unitIndex = minSizeBox.indexOfSelectedItem
                        if unitIndex == 1 {
                            minSize *= 1024
                        } else if unitIndex == 2 {
                            minSize *= 1024 * 1024
                        }
                        if minSize > count {
                            return nil
                        }
                    }
                    
                    if maxSizeLabel.stringValue.isEmpty != true {
                        var maxSize = (maxSizeLabel.stringValue as NSString).intValue
                        let unitIndex = maxSizeBox.indexOfSelectedItem
                        if unitIndex == 1 {
                            maxSize *= 1024
                        } else if unitIndex == 2 {
                            maxSize *= 1024 * 1024
                        }
                        if maxSize < count {
                            return nil
                        }
                    }
                }
            }
            return fullPath
        }
    }
}

extension ViewController: NSComboBoxDelegate, NSComboBoxDataSource {
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        if comboBox == folderBox {
            return folderDatas.count
        } else if comboBox == typeBox {
            return typeDatas.count
        } else if comboBox == minSizeBox || comboBox == maxSizeBox {
            return unitDatas.count
        }
        return 0
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        if comboBox == folderBox {
            return folderDatas[index]
        } else if comboBox == typeBox {
            return typeDatas[index]
        } else if comboBox == minSizeBox || comboBox == maxSizeBox {
            return unitDatas[index]
        }
        return ""
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if let obj = notification.object as? NSComboBox {
            var datas: [String] = []
            if obj == folderBox {
                datas = folderDatas
            } else if obj == typeBox {
                datas = typeDatas
            }
            if obj.indexOfSelectedItem < datas.count {
                var value = ""
                var label = NSTextField()
                if obj == folderBox {
                    value = folderDatas[obj.indexOfSelectedItem]
                    label = specificFolderLabel
                } else if obj == typeBox {
                    value = typeDatas[obj.indexOfSelectedItem]
                    label = fileTypeLabel
                }
                let currentValue = label.stringValue
                let isExisted = currentValue.contains(value) || currentValue == value
                if isExisted == true {
                    return
                }
                if currentValue.isEmpty == true {
                    label.stringValue.append(value)
                } else {
                    label.stringValue.append(",\(value)")
                }
            }
        }
    }
    
    func setupDatas() {
        if let string = UserDefaults.standard.object(forKey: KSpecificFolderNamesKey) as? String {
            let strArray = (string as NSString).components(separatedBy: ",")
            folderDatas = strArray
        } else {
            let string = "Assets.xcassets,Resources"
            UserDefaults.standard.set(string, forKey: KSpecificFolderNamesKey)
            let strArray = (string as NSString).components(separatedBy: ",")
            folderDatas = strArray
        }
        
        if let string = UserDefaults.standard.object(forKey: KFileTypeKey) as? String {
            let strArray = (string as NSString).components(separatedBy: ",")
            typeDatas = strArray
        } else {
            let string = "png,jpg,jpeg,zip"
            UserDefaults.standard.set(string, forKey: KFileTypeKey)
            let strArray = (string as NSString).components(separatedBy: ",")
            typeDatas = strArray
        }
        unitDatas = ["B","KB","M"]
    }
}

//extension ViewController: NSTextFieldDelegate {
//    func control(_ control: NSControl, isValidObject obj: Any?) -> Bool {
//        if let value = obj as? String {
//            let regex = "([1-9]*.?)|(0.[0-9]+)"
//            let predicate = NSPredicate(format: "SELF MATCHES \(regex)", argumentArray:nil)
//            return predicate.evaluate(with: value)
//        }
//        return false
//    }
//}
