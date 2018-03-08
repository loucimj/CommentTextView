//
//  WriteCommentView.swift
//  Feedback
//
//  Created by Cristopher A. Bautista Gómez on 10/11/17.
//  Copyright © 2017 Globant. All rights reserved.
//

import UIKit
import NextGrowingTextView

protocol WriteCommentViewDelegate : class {
    func userWantsToSendText (using commentView: WriteCommentView, text : String)
    func userUpdatedText (in commentView: WriteCommentView, text : String)
    func writeCommentViewWillChangeHeight(commentView:WriteCommentView, height: CGFloat)
    func writeCommentViewDidChangeHeight(commentView:WriteCommentView, height: CGFloat)
    
}

extension WriteCommentViewDelegate {
    func userUpdatedText (in commentView: WriteCommentView, text : String) {}
    func writeCommentViewWillChangeHeight(commentView:WriteCommentView, height: CGFloat) {}
    func writeCommentViewDidChangeHeight(commentView:WriteCommentView, height: CGFloat) {}
}

class WriteCommentView: UIView, NibLoadable {

    var setBottomPadding : CGFloat = 60
    fileprivate var viewLine : UIView?
    @IBOutlet weak var sendViewWidth : NSLayoutConstraint!
    @IBOutlet weak var sendView : UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var sendButton : UIButton!
    @IBOutlet weak var placeHolder : UILabel!
    @IBOutlet weak var counterChars : UILabel!
    @IBOutlet weak var textView : NextGrowingTextView!
    
    var originalHeightWithoutTextField:CGFloat = 0
    
    weak var delegate: WriteCommentViewDelegate? {
        didSet {
            self.textView.delegates.didChangeHeight = { [weak self] height in
                guard let `self` = self else { return }
                self.delegate?.writeCommentViewDidChangeHeight(commentView: self, height: self.originalHeightWithoutTextField + height)
            }
            
            self.textView.delegates.willChangeHeight = { [weak self] height in
                guard let `self` = self else { return }
                self.delegate?.writeCommentViewWillChangeHeight(commentView: self, height: self.originalHeightWithoutTextField + height)
            }
        }
    }
    
    var charsLimit : Int = 1200 {
        didSet {
            self.textViewDidChange(self.textView.textView)
        }
    }
    var placeholderText:String = "" {
        didSet {
            placeHolder.text = placeholderText
        }
    }
    var hideSendButton : Bool = false {
        didSet {
            if hideSendButton {
                self.sendView.alpha = 0
                self.sendViewWidth.constant = 0
            }else {
                self.sendView.alpha = 1
                self.sendViewWidth.constant = 32
            }
        }
    }

    class func initAndAttachToView(view:UIView) -> WriteCommentView {
        let commentView = WriteCommentView.initFromNib()
        commentView.frame = view.bounds
        commentView.originalHeightWithoutTextField = view.bounds.height - commentView.textView.frame.height
        commentView.textView.maxNumberOfLines = 7
        commentView.textView.textView.delegate = commentView
        commentView.translatesAutoresizingMaskIntoConstraints = true
        commentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
        view.addSubview(commentView)
        
        return commentView
    }
    
    @objc fileprivate func sendAction () {
        delegate?.userWantsToSendText(using: self, text: textView.textView.text)
    }
    
    
    func clearAndDisable () {
        //counterLabel.text = "0/1200"
        sendButton.isEnabled = false
        textView.textView.isEditable = false
        textView.textView.text = ""
        _ = textView.resignFirstResponder()
    }
    
    func enable () {
        sendButton.isEnabled = true
        textView.textView.isEditable = true
        textView.textView.text = ""
        _ = textView.resignFirstResponder()
    }
}

extension WriteCommentView : UITextViewDelegate {
 
    func disableSendButton() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 75, initialSpringVelocity: 15, options: [.beginFromCurrentState], animations: {
            self.sendView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.sendView.alpha = 0.2
            self.sendButton.isEnabled = false
        }, completion: nil)
    }
    
    func enableSendButton() {
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 275, initialSpringVelocity: 15, options: [.beginFromCurrentState], animations: {
            self.sendView.transform = CGAffineTransform.identity
            self.sendView.alpha = 1.0
            self.sendButton.isEnabled = true
        }, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let txtCounter = charsLimit - textView.text.count
        if txtCounter < 0 {
            disableSendButton()
        } else {
            enableSendButton()
        }

        if txtCounter <= 20 {
            counterChars.textColor = .red
        } else {
            counterChars.textColor = UIColor(hex: "#A8A8A8")
            if textView.text.count == 1 {
                placeHolder.isHidden = true
            }else if textView.text.count == 0 {
                placeHolder.isHidden = false
            }
        }
        counterChars.text = "\(txtCounter)"
        delegate?.userUpdatedText(in: self, text: textView.text)
        
        if textView.text.count == 0 {
            placeHolder.isHidden = false
        } else {
            placeHolder.isHidden = true
        }
    }
}


