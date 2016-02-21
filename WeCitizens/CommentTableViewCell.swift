//
//  CommentTableViewCell.swift
//  WeCitizens
//
//  Created by  Harold LIU on 2/11/16.
//  Copyright © 2016 Tongji Apple Club. All rights reserved.
//

import UIKit
import SnapKit

class CommentTableViewCell: UITableViewCell,UITextViewDelegate,UIScrollViewDelegate{

    
    var pageImages = [UIImage(named: "logo")!,UIImage(named: "logo")!,UIImage(named: "logo")!]
    var pageViews: [UIImageView?] = []
    
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var CommentUser: UILabel!
    @IBOutlet weak var Reputation: UILabel!
    @IBOutlet weak var Classify: UILabel!
    @IBOutlet weak var UpdateTime: UILabel!
    @IBOutlet weak var BrowseNum: UILabel!
    @IBOutlet weak var Abstract: UITextView!
    @IBOutlet weak var ClassifyKind: UIImageView!
    
    
    @IBOutlet weak var imageContainter: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIconfigure()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//MARK:- Configure UI
    func UIconfigure()
    {
        self.backgroundColor = UIColor(red: 249/255, green: 251/255, blue: 255/255, alpha: 1.0)
        
        //make avatar circle
        Avatar.layer.masksToBounds = false
        Avatar.layer.borderWidth = 1
        Avatar.layer.borderColor = UIColor.clearColor().CGColor
        Avatar.layer.cornerRadius = Avatar.frame.height/2
        Avatar.clipsToBounds = true
        
        // Adjust the height of the textview
        let contentSize = self.Abstract.sizeThatFits(self.Abstract.bounds.size)
        var frame = self.Abstract.frame
        frame.size.height = contentSize.height
        self.Abstract.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: self.Abstract, attribute: .Height, relatedBy: .Equal, toItem: self.Abstract, attribute: .Width, multiplier: Abstract.bounds.height/Abstract.bounds.width, constant: 8)
        self.Abstract.addConstraint(aspectRatioTextViewConstraint)
        
    }
    
}
