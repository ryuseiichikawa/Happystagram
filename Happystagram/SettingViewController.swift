//
//  SettingViewController.swift
//  Happystagram
//
//  Created by 市川龍星 on 2018/09/06.
//  Copyright © 2018年 市川龍星. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openCamera(){
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
        //        カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            //            インスタンス作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func openPhoto(){
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        //        カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            //            インスタンス作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
        
    }

    @IBAction func changeProfileImage(_ sender: Any) {
//        大元のアラートヴューを作成！！
        let alertViewController = UIAlertController(title: "選択してください", message: "", preferredStyle: .actionSheet)
        
//alertViewControllerに載せるためのアクションを生成❶
        let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler:{(action: UIAlertAction!) -> Void in
//cameraActionが具体的にどんなアクションか
            self.openCamera()
            })
        
//alertViewControllerに載せるためのアクションを生成❷
        let photosAction = UIAlertAction(title: "アルバム", style: .default, handler: {(action: UIAlertAction!) -> Void in
//photosActionが具体的にどんなアクションか
            self.openPhoto()
        })
        
//alertViewControllerに載せるためのアクションを生成❸
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        // ❶❷❸のアクションをalertViewControllerに追加
        alertViewController.addAction(cameraAction)
        alertViewController.addAction(photosAction)
        alertViewController.addAction(cancelAction)

        present(alertViewController, animated: true, completion: nil)
    }
    
//    画像を受け取る
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
//            スケールを合わせる
            profileImageView.contentMode = .scaleToFill
//profileImageViewに画像を受け取る
            profileImageView.image = pickedImage
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        
//ログアウトしたときにわかるように
        UserDefaults.standard.removeObject(forKey: "check")
//ログアウトしたときに画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    受け取ったイメージを圧縮してヴァイなりーデータに変換してアプリ内に保存
    @IBAction func done(_ sender: Any) {
        var data: NSData = NSData()
//profileImageViewに画像が入れられたら
        if let image = profileImageView.image{
//            圧縮率0.1でNSDataに変換
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
        }
        
        let username = userNameTextField.text
        
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
        
// アプリ内に保存する
        UserDefaults.standard.set(base64String, forKey: "profileImage")
        UserDefaults.standard.set(username, forKey: "username")
        dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        もしuserNameTextFieldが出ていたら、
        if(userNameTextField.isFirstResponder){
//            userNameTextFieldを下げてください
            userNameTextField.resignFirstResponder()
        }
    }
    
}
