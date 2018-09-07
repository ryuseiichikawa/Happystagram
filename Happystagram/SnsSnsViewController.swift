//
//  SnsSnsViewController.swift
//  Happystagram
//
//  Created by 市川龍星 on 2018/09/06.
//  Copyright © 2018年 市川龍星. All rights reserved.
//

import UIKit
import Social

class SnsSnsViewController: UIViewController {

    var detailImage = UIImage()
    var detailProfileImage = UIImage()
    var detailUserName = String()
    
//    投稿用の画面を初期化
    var myComposeview: SLComposeViewController!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImageView.image = detailProfileImage
        label.text = detailUserName
        imageView.image = detailImage
//        プロフィール画像を丸くする
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func shareTwitter(_ sender: Any) {
        myComposeview = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    }
    
    
    

}
