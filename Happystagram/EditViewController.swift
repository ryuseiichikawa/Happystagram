//
//  EditViewController.swift
//  Happystagram
//
//  Created by 市川龍星 on 2018/09/06.
//  Copyright © 2018年 市川龍星. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextViewDelegate {
    
    var willEditImage: UIImage = UIImage()

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
//    アプリ内で保存したユーザーネームをとってくる
    var userNameString: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        画像を受け取ってそれらを取り込んだ変数willEditImageをimageViewに代入
        imageView.image = willEditImage
//commentTextViewのデリゲートはこのEditViewControllerが担う
        commentTextView.delegate = self
//myProfileImageViewを丸くする
        myProfileImageView.layer.cornerRadius = 8.0
        myProfileImageView.clipsToBounds = true
        
//        もし、SettingViewControllerのUserDefaults.standard.set(base64String, forKey: "profileImage")の処理で設定したprofileImageがnil出ないなら
        if UserDefaults.standard.object(forKey: "profileImage") != nil {
            
//   エンコードして取り出す
        let decodeData = UserDefaults.standard.object(forKey: "profileImage")
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
//       decodedDataをImage型にする
            let decodedImage = UIImage(data: decodedData! as Data)
        myProfileImageView.image = decodedImage
            
// 上で作ったuserNameStringの中にusernameをString型で取り出して入れる
// ちなみにlet val1 = UserDeafaults.standard.object(forKey: "key01")は読み込み時の記述方法
            userNameString = UserDefaults.standard.object(forKey: "username") as! String
            profileLabel.text = userNameString
        }else{
            myProfileImageView.image = UIImage(named: "logo.png")
// ＜疑問＞profileImageがないとしてもusernameがあるんじゃないかな？その場合も考慮してelse ifとかで分けて場合分けすべきでは。
            profileLabel.text = "匿名"
        }
        
    }

    @IBAction func post(_ sender: Any) {
        postAll()
    }
    
    
    func postAll(){
//        サーバーに飛ばすものを入れる
        let databaseref = Database.database().reference()
        
        let username = profileLabel.text!
        let message = commentTextView.text!
        
//投稿画像
       //        dataを初期化しとかないとえらー出るよ
        var data: NSData = NSData()
        if let image = imageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
//プロフィール画像
        var data2: NSData = NSData()
        if let image2 = myProfileImageView.image {
            data2 = UIImageJPEGRepresentation(image2, 0.1)! as NSData
        }
        let base64String2 = data2.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
// サーバーに飛ばす箱
        let user: NSDictionary = ["username": username, "comment": message, "postImage": base64String2, "profileImage": base64String]
      //   ここで飛ばす
      databaseref.child("Posts").childByAutoId().setValue(user)
        
//        戻る
        self.navigationController?.popToRootViewController(animated: true)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
