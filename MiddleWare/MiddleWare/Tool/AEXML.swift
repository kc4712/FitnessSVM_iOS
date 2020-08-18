//
// AEXML.swift
//
// Copyright (c) 2014 Marko Tadić <tadija@me.com> http://tadija.net
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

// MARK: - AEXMLElement

/**
    This is base class for holding XML structure.

    You can access its structure by using subscript like this: `element["foo"]["bar"]` which would
    return `<bar></bar>` element from `<element><foo><bar></bar></foo></element>` XML as an `AEXMLElement` object.
*/
open class AEXMLElement {
    
    /// A type representing an error value that can be inside `error` property.
    public enum errorMSG: Error {
        case elementNotFound
        case rootElementMissing
    }
    
    fileprivate struct Defaults {
        static let name = String()
        static let attributes = [String : String]()
    }
    
    // MARK: Properties
    
    /// Every `AEXMLElement` should have its parent element instead of `AEXMLDocument` which parent is `nil`.
    open fileprivate(set) weak var parent: AEXMLElement?
    
    /// Child XML elements.
    open fileprivate(set) var children: [AEXMLElement] = [AEXMLElement]()
    
    /// XML Element name (defaults to empty string).
    open var name: String
    
    /// XML Element value.
    open var value: String?
    
    /// XML Element attributes (defaults to empty dictionary).
    open var attributes: [String : String]
    
    /// Error value (`nil` if there is no error).
    open var error: Error?
    
    /// String representation of `value` property (if `value` is `nil` this is empty String).
    open var stringValue: String { return value ?? String() }
    
    /// Boolean representation of `value` property (if `value` is "true" or 1 this is `True`, otherwise `False`).
    open var boolValue: Bool { return stringValue.lowercased() == "true" || Int(stringValue) == 1 ? true : false }
    
    /// Integer representation of `value` property (this is **0** if `value` can't be represented as Integer).
    open var intValue: Int { return Int(stringValue) ?? 0 }
    
    /// Double representation of `value` property (this is **0.00** if `value` can't be represented as Double).
    open var doubleValue: Double { return (stringValue as NSString).doubleValue }
    
    // MARK: Lifecycle
    
    /**
        Designated initializer - all parameters are optional.
    
        - parameter name: XML element name.
        - parameter value: XML element value
        - parameter attributes: XML element attributes
    
        - returns: An initialized `AEXMLElement` object.
    */
    public init(_ name: String? = nil, value: String? = nil, attributes: [String : String]? = nil) {
        self.name = name ?? Defaults.name
        self.value = value
        self.attributes = attributes ?? Defaults.attributes
    }
    /*deinit {
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++call?")
        self.name = ""
        self.value = ""
        self.attributes = ["":""]
    }*/
    
    // MARK: XML Read
    
    /// The first element with given name **(Empty element with error if not exists)**.
    open subscript(key: String) -> AEXMLElement {
        guard let
            first = children.filter({ $0.name == key }).first
        else {
            let errorElement = AEXMLElement(key)
            errorElement.error = errorMSG.elementNotFound
            return errorElement
        }
        return first
    }
    
    /// Returns all of the elements with equal name as `self` **(nil if not exists)**.
    open var all: [AEXMLElement]? { return parent?.children.filter { $0.name == self.name } }
    
    /// Returns the first element with equal name as `self` **(nil if not exists)**.
    open var first: AEXMLElement? { return all?.first }
    
    /// Returns the last element with equal name as `self` **(nil if not exists)**.
    open var last: AEXMLElement? { return all?.last }
    
    /// Returns number of all elements with equal name as `self`.
    open var count: Int { return all?.count ?? 0 }

    fileprivate func allWithCondition(_ fulfillCondition: (_ element: AEXMLElement) -> Bool) -> [AEXMLElement]? {
        var found = [AEXMLElement]()
        if let elements = all {
            for element in elements {
                if fulfillCondition(element) {
                    found.append(element)
                }
            }
            return found.count > 0 ? found : nil
        } else {
            return nil
        }
    }
    
    /**
        Returns all elements with given value.
        
        - parameter value: XML element value.
        
        - returns: Optional Array of found XML elements.
    */
    open func allWithValue(_ value: String) -> [AEXMLElement]? {
        let found = allWithCondition { (element) -> Bool in
            return element.value == value
        }
        return found
    }
    
    /**
        Returns all elements with given attributes.
    
        - parameter attributes: Dictionary of Keys and Values of attributes.
    
        - returns: Optional Array of found XML elements.
    */
    open func allWithAttributes(_ attributes: [String : String]) -> [AEXMLElement]? {
        let found = allWithCondition { (element) -> Bool in
            var countAttributes = 0
            for (key, value) in attributes {
                if element.attributes[key] == value {
                    countAttributes += 1
                }
            }
            return countAttributes == attributes.count
        }
        return found
    }
    
    // MARK: XML Write
    
    /**
        Adds child XML element to `self`.
    
        - parameter child: Child XML element to add.
    
        - returns: Child XML element with `self` as `parent`.
    */
    open func addChild(_ child: AEXMLElement) -> AEXMLElement {
        child.parent = self
        children.append(child)
        return child
    }
    
    /**
        Adds child XML element to `self`.
        
        - parameter name: Child XML element name.
        - parameter value: Child XML element value.
        - parameter attributes: Child XML element attributes.
        
        - returns: Child XML element with `self` as `parent`.
    */
    open func addChild(name: String, value: String? = nil, attributes: [String : String]? = nil) -> AEXMLElement {
        let child = AEXMLElement(name, value: value, attributes: attributes)
        return addChild(child)
    }
    
    /// Removes `self` from `parent` XML element.
    open func removeFromParent() {
        parent?.removeChild(self)
    }
    
    fileprivate func removeChild(_ child: AEXMLElement) {
        if let childIndex = children.index(where: { $0 === child }) {
            children.remove(at: childIndex)
        }
    }
    
    fileprivate var parentsCount: Int {
        var count = 0
        var element = self
        while let parent = element.parent {
            count += 1
            element = parent
        }
        return count
    }
    
    fileprivate func indentation(_ depth: Int) -> String {
        var count = depth
        var indent = String()
        
        while count > 0 {
            indent += "\t"
            count -= 1
        }
        
        return indent
    }
    
    /// Complete hierarchy of `self` and `children` in **XML** escaped and formatted String
    open var xmlString: String {
        var xml = String()
        
        // open element
        xml += indentation(parentsCount - 1)
        xml += "<\(name)"
        
        if attributes.count > 0 {
            // insert attributes
            for (key, value) in attributes {
                xml += " \(key)=\"\(value.xmlEscaped)\""
            }
        }
        
        if value == nil && children.count == 0 {
            // close element
            xml += " />"
        } else {
            if children.count > 0 {
                // add children
                xml += ">\n"
                for child in children {
                    xml += "\(child.xmlString)\n"
                }
                // add indentation
                xml += indentation(parentsCount - 1)
                xml += "</\(name)>"
            } else {
                // insert string value and close element
                xml += ">\(stringValue.xmlEscaped)</\(name)>"
            }
        }
        
        return xml
    }
    
    /// Same as `xmlString` but without `\n` and `\t` characters
    open var xmlStringCompact: String {
        let chars = CharacterSet(charactersIn: "\n\t")
        return xmlString.components(separatedBy: chars).joined(separator: "")
    }
    
}

public extension String {
    
    /// String representation of self with XML special characters escaped.
    public var xmlEscaped: String {
        // we need to make sure "&" is escaped first. Not doing this may break escaping the other characters
        var escaped = replacingOccurrences(of: "&", with: "&amp;", options: .literal)
        
        // replace the other four special characters
        let escapeChars = ["<" : "&lt;", ">" : "&gt;", "'" : "&apos;", "\"" : "&quot;"]
        for (char, echar) in escapeChars {
            escaped = escaped.replacingOccurrences(of: char, with: echar, options: .literal)
        }
        
        return escaped
    }
    
}

// MARK: - AEXMLDocument

/**
    This class is inherited from `AEXMLElement` and has a few addons to represent **XML Document**.

    XML Parsing is also done with this object.
*/
open class AEXMLDocument: AEXMLElement {
    
    public struct Defaults {
        public static let version = 1.0
        public static let encoding = "utf-8"
        public static let standalone = "no"
        public static let documentName = "AEXMLDocument"
    }
    
    /// Default options used by NSXMLParser
    public struct NSXMLParserOptions {
        public var shouldProcessNamespaces = false
        public var shouldReportNamespacePrefixes = false
        public var shouldResolveExternalEntities = false
        
        public init() {}
    }
    
    // MARK: Properties
    
    /// This is only used for XML Document header (default value is 1.0).
    open let version: Double
    
    /// This is only used for XML Document header (default value is "utf-8").
    open let encoding: String
    
    /// This is only used for XML Document header (default value is "no").
    open let standalone: String
    
    /// Options for NSXMLParser (default values are `false`)
    open let xmlParserOptions: NSXMLParserOptions
    
    /// Root (the first child element) element of XML Document **(Empty element with error if not exists)**.
    open var root: AEXMLElement {
        guard let rootElement = children.first else {
            let errorElement = AEXMLElement()
            errorElement.error = errorMSG.rootElementMissing
            return errorElement
        }
        return rootElement
    }
    
    // MARK: Lifecycle
    
    /**
        Designated initializer - Creates and returns XML Document object.
    
        - parameter version: Version value for XML Document header (defaults to 1.0).
        - parameter encoding: Encoding value for XML Document header (defaults to "utf-8").
        - parameter standalone: Standalone value for XML Document header (defaults to "no").
        - parameter root: Root XML element for XML Document (defaults to `nil`).
        - parameter xmlParserOptions: Options for NSXMLParser (defaults to `false` for all).
    
        - returns: An initialized XML Document object.
    */
    public init(version: Double = Defaults.version,
                encoding: String = Defaults.encoding,
                standalone: String = Defaults.standalone,
                root: AEXMLElement? = nil,
                xmlParserOptions: NSXMLParserOptions = NSXMLParserOptions())
    {
        // set document properties
        self.version = version
        self.encoding = encoding
        self.standalone = standalone
        self.xmlParserOptions = xmlParserOptions
        
        // init super with default name
        super.init(Defaults.documentName)
        
        // document has no parent element
        parent = nil
        
        // add root element to document (if any)
        if let rootElement = root {
            addChild(rootElement)
        }
    }
    
    /**
        Convenience initializer - used for parsing XML data (by calling `loadXMLData:` internally).
    
        - parameter version: Version value for XML Document header (defaults to 1.0).
        - parameter encoding: Encoding value for XML Document header (defaults to "utf-8").
        - parameter standalone: Standalone value for XML Document header (defaults to "no").
        - parameter xmlData: XML data to parse.
        - parameter xmlParserOptions: Options for NSXMLParser (defaults to `false` for all).
    
        - returns: An initialized XML Document object containing parsed data. Throws error if data could not be parsed.
    */
    public convenience init(version: Double = Defaults.version,
                            encoding: String = Defaults.encoding,
                            standalone: String = Defaults.standalone,
                            xmlData: Data,
                            xmlParserOptions: NSXMLParserOptions = NSXMLParserOptions()) throws
    {
        self.init(version: version, encoding: encoding, standalone: standalone, xmlParserOptions: xmlParserOptions)
        try loadXMLData(xmlData)
    }
    
    // MARK: Read XML
    
    /**
        Creates instance of `AEXMLParser` (private class which is simple wrapper around `NSXMLParser`) 
        and starts parsing the given XML data. Throws error if data could not be parsed.
    
        - parameter data: XML which should be parsed.
    */
    open func loadXMLData(_ data: Data) throws {
        children.removeAll(keepingCapacity: false)
        let xmlParser = AEXMLParser(xmlDocument: self, xmlData: data)
        try xmlParser.AEparse()
    }
    
    // MARK: Override
    
    /// Override of `xmlString` property of `AEXMLElement` - it just inserts XML Document header at the beginning.
    open override var xmlString: String {
        var xml =  "<?xml version=\"\(version)\" encoding=\"\(encoding)\" standalone=\"\(standalone)\"?>\n"
        for child in children {
            xml += child.xmlString
        }
        return xml
    }
    
}

// MARK: - AEXMLParser

private class AEXMLParser: NSObject, XMLParserDelegate {
    
    // MARK: Properties
    
    let xmlDocument: AEXMLDocument
    let xmlData: Data
    
    var currentParent: AEXMLElement?
    var currentElement: AEXMLElement?
    var currentValue = String()
    var parseError: NSError?
    
    // MARK: Lifecycle
    
    init(xmlDocument: AEXMLDocument, xmlData: Data) {
        self.xmlDocument = xmlDocument
        self.xmlData = xmlData
        currentParent = xmlDocument
        super.init()
    }
    
    // MARK: XML Parse
    
    func AEparse() throws {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        
        parser.shouldProcessNamespaces = xmlDocument.xmlParserOptions.shouldProcessNamespaces
        parser.shouldReportNamespacePrefixes = xmlDocument.xmlParserOptions.shouldReportNamespacePrefixes
        parser.shouldResolveExternalEntities = xmlDocument.xmlParserOptions.shouldResolveExternalEntities
        
        let success = parser.parse()
        if !success {
            throw parseError ?? NSError(domain: "net.tadija.AEXML", code: 1, userInfo: nil)
        }
    }
    
    // MARK: NSXMLParserDelegate
    
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentValue = String()
        currentElement = currentParent?.addChild(name: elementName, attributes: attributeDict)
        currentParent = currentElement
    }
    
    @objc func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
        let newValue = currentValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        currentElement?.value = newValue == String() ? nil : newValue
    }
    
    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentParent = currentParent?.parent
        currentElement = nil
    }
    
    @objc func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError as NSError?
    }
    
}
