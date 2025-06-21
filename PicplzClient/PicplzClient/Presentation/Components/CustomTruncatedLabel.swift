//
//  CustomTruncatedLabel.swift
//  PicplzClient
//
//  Created by 임영택 on 4/20/25.
//

import Foundation
import UIKit

class CustomTruncatedLabel: UILabel {
    private let ellipsisString: String
    private let ellipsisFont: UIFont
    private let ellipsisPadding: CGFloat
    private var originalText: String?
    
    override var numberOfLines: Int {
        didSet {
            if let originalText = originalText {
                setText(originalText)
            }
        }
    }
    
    init(ellipsisString: String = "...더보기", ellipsisPadding: CGFloat = 16, ellipsisFont: UIFont, normalFont: UIFont) {
        self.ellipsisString = ellipsisString
        self.ellipsisPadding = ellipsisPadding
        self.ellipsisFont = ellipsisFont
        
        super.init(frame: .zero)
        self.font = normalFont
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        self.originalText = text
        
        guard let font = self.font else { return }
        
        let labelWidth = self.bounds.width
        
        let lineHeight = self.font.lineHeight
        
        let numberOfLines: Int = self.numberOfLines == 0 ? .max : self.numberOfLines
        let labelHeight = lineHeight * CGFloat(numberOfLines)
        
        let basicAttributes: [NSAttributedString.Key: Any] = [.font: font]
        let trailingAttributes: [NSAttributedString.Key: Any] = [.font: ellipsisFont]
        
        // MARK: Check full size renderable
        let fullSizeText = NSAttributedString(string: text, attributes: basicAttributes)
        let fullSize = fullSizeText.boundingRect(
            with: CGSize(width: labelWidth - 16, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        if fullSize.height <= labelHeight {
            self.attributedText = fullSizeText
            return
        }
        
        // MARK: Truncate
        var fittingText = text
        var finalText = NSAttributedString(string: ellipsisString)
        
        while !fittingText.isEmpty {
            let combined = NSMutableAttributedString(string: fittingText, attributes: basicAttributes)
            let trailing = NSAttributedString(string: ellipsisString, attributes: trailingAttributes)
            combined.append(trailing)
            
            let size = combined.boundingRect(
                with: CGSize(width: labelWidth - 16, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                context: nil
            )
            
            if size.height <= labelHeight {
                finalText = combined
                break
            }
            
            fittingText.removeLast()
        }
        
        self.attributedText = finalText
    }
}
