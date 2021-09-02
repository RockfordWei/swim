//
//  Languages.swift
//  SWIM
//
//  Created by Rocky Wei on 2021-09-02.
//  Copyright © 2021 Treefrog. All rights reserved.
//

import Foundation


fileprivate class LanguagePacks: NSObject {
	var _dictionary: [String: String] = [:]
	override init() {
		super.init()
		guard let url = Bundle.main.url(forResource: "strings", withExtension: "xml"),
			  let xml = XMLParser(contentsOf: url) else {
			NSLog("Warning: unable to load dictionary: url or xml failure")
			return
		}
		xml.delegate = self
		xml.parse()
	}

	static let shared = LanguagePacks()

	fileprivate var cursor = ""
	fileprivate var content = ""
}

extension LanguagePacks: XMLParserDelegate {
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
		if elementName == "string", let name = attributeDict["name"] {
			cursor = name
			content = ""
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		content += string
	}
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "string", cursor.isNotEmpty && content.isNotEmpty {
			_dictionary[cursor] = content
			cursor = ""
			content = ""
		}
	}
}

func __(_ text: String) -> String {
	return LanguagePacks.shared._dictionary[text] ?? text
}
