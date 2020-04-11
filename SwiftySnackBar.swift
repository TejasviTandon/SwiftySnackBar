//
//  SwiftySnackBar.swift
//  SwiftySnackBar
//
//  Created by Tejsvi Tandon on 11/04/20.
//  Copyright © 2020 Tejsvi Tandon. All rights reserved.
//

import Foundation
import UIKit

public final class SwiftySnackBar {
    
    typealias Message = String
    static let shared = SwiftySnackBar()
    
    
    private init() { }
    private let snackBarViewTag = 99999
    
    func show(with message: Message, backgroundColor:UIColor = UIColor(named: "202020")!, textColor: UIColor = .white, autoDismissal: Bool = true, after dismissAfter: TimeInterval = 4, font: UIFont = UIFont.systemFont(ofSize: 14)) {
        guard let keyWindow = UIApplication.shared.windows.first else { return }
        
        //get size for text to be displayed.
        let space: CGFloat = 20
        let textWidth = keyWindow.bounds.width - (2 * space) - 30
        let textViewSize = rectForText(text: message, font: font, maxSize: CGSize(width: textWidth,height: 999))
        let textViewHeight = textViewSize.height + 30
        
        
        let textViewX = keyWindow.bounds.minX
        let textViewY = keyWindow.bounds.maxY
        let textViewWidth = keyWindow.bounds.width
        
        let textView = UITextView(frame: CGRect(x: textViewX, y: textViewY, width: textViewWidth, height: textViewHeight))
        textView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.backgroundColor = backgroundColor
        textView.textColor = textColor
        textView.font = font
        textView.text = message
        textView.tag = snackBarViewTag
        textView.isUserInteractionEnabled = false
        keyWindow.addSubview(textView)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            textView.frame = CGRect(x: textViewX, y: textViewY - textViewHeight, width: textViewWidth, height: textViewHeight)
        }, completion: nil)
        
        if autoDismissal {
            let removeView = DispatchWorkItem {
                textView.removeFromSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter, execute: removeView)
        }
        
    }
    
    func removeSnackBar() {
        guard let keyWindow = UIApplication.shared.windows.first else { return }
        keyWindow.viewWithTag(snackBarViewTag)?.removeFromSuperview()
    }
    
   internal func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    
}
