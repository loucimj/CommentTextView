//
//  ViewController.swift
//  CommentTextView
//
//  Created by Javier Loucim on 08/03/2018.
//  Copyright © 2018 Qeeptouch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldContainerView: UIView!
    @IBOutlet weak var textFieldContainerHeightConstraint: NSLayoutConstraint!
    var writeCommentView:WriteCommentView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.writeCommentView = WriteCommentView.initAndAttachToView(view:self.textFieldContainerView)
        self.writeCommentView?.charsLimit = 20
        self.writeCommentView?.placeholderText = "hola esto es una prueba"
        self.writeCommentView?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController: WriteCommentViewDelegate {
    func userUpdatedText(in commentView: WriteCommentView, text: String) {
        
    }
    func writeCommentViewDidChangeHeight(commentView: WriteCommentView, height: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.textFieldContainerHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func writeCommentViewWillChangeHeight(commentView: WriteCommentView, height: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.textFieldContainerHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    func userWantsToSendText(using commentView: WriteCommentView, text: String) {
        
    }
}

