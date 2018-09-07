//
//  ViewController.swift
//  Happystagram
//
//  Created by 市川龍星 on 2018/09/04.
//  Copyright © 2018年 市川龍星. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

//    辞書がたの配列を用意
    var items = [NSDictionary]()
//    引っ張って更新するのがUIRefreshControl
    let refreshControl = UIRefreshControl()
    
    var passImage: UIImage = UIImage()
    
//    現在の画像と名前
    var nowtableViewImage = UIImage()
    var nowtableViewUserName = String()
    var nowtableViewUserImage = UIImage()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       もしユーザーだフォルトのキー値がcheck出ないときは下記のelse処理
        if UserDefaults.standard.object(forKey: "check") != nil {
//loginViewControllerに遷移する
        }else{
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        tableView.delegate = self
        tableView.dataSource = self
    
//        引っ張った時のタイトル
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
//        どこのメソッドか？＞self
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//        上で作ったrefreshControlをtableViewに載せる
        tableView.addSubview(refreshControl)
        
        
        //itemsを初期化
        items = [NSDictionary]()
        //データをデータベースからとってくる
        loadData()
        // テーブルビューをリロード
        tableView.reloadData()
    }
    
    
    @objc func refresh() {
        
//itemsを初期化
        items = [NSDictionary]()
//データをデータベースからとってくる
        loadData()
// テーブルビューをリロード
        tableView.reloadData()
//        引っ張って更新を終わる
        refreshControl.endRefreshing()
    }
    
//    セルの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
       //データベースからitemsの中に入ったindexpathのrow番目のデータをdictに代入
        let dict = items[(indexPath as NSIndexPath).row ]
        
//プロフィール
        let profileImageView = cell.viewWithTag(1) as! UIImageView
         //        データ型で保存されたものをキー値photo64から取り出す
        let decodeData = (base64Encoded: dict["profileImage"])
         //        こう言うもの？？　String型にダウンキャスト
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        //データ型をUIImage型に切り替える
        let decodedImage = UIImage(data: decodedData! as Data)
        //プロフィール画像を丸くする
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.clipsToBounds = true
        
        profileImageView.image = decodedImage
        
        
        
//ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
     //投稿する際にキー値userNameに指定。dict内のuserNameと言うキーを持ったものを左辺に代入。
        userNameLabel.text = dict["userName"] as? String
        
// 投稿画像
        let postedUserImage = cell.viewWithTag(3) as! UIImageView
        
        let decodeData2 = (base64Encoded: dict["postImage"])
        //        こう言うもの？？　String型にダウンキャスト
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        //        データ型をUIImage型に切り替える
        let decodedImage2 = UIImage(data: decodedData2! as Data)
        postedUserImage.image = decodedImage2
        
//コメント
        let commentTextView = cell.viewWithTag(4) as! UITextView
        commentTextView.text = dict["comment"] as! String
        
        return cell
    }
    
//    データベースからデータを取ってきて配列itemsの中に入れた
    func loadData(){
//        更新が始まったとこでインジケータ開始
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        どこのURLから参照してくるのかを指定
        let firebase = Database.database().reference(fromURL: "https://happystagram-8a3b6.firebaseio.com/").child("Posts")
        
//        上記URLから最新１０件を呼び出す
        firebase.queryLimited(toLast: 10).observe(.value) {(snapshot, error) in
//            配列の中に入れていく
            var tempItems = [NSDictionary]()
            
            for item in(snapshot.children){
                let child = item as! DataSnapshot
//                valueをつけことで、許容されているのはvalueに定義されている型のものだけに限定
                let dict = child.value
                tempItems.append(dict as! NSDictionary)
            }
            
//            for文で回して取り出したitemを取り込んだtempItemsを、配列itemsに代入。配列itemsは辞書型
            self.items = tempItems
//            reversedで配列の順番を反対にする
            self.items = self.items.reversed()
//            セルを更新
            self.tableView.reloadData()
            
//        更新が終わったとこでインジケータ終了
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        indexPath番目のセルを代入
        let dict = items[(indexPath as NSIndexPath).row]
        

//        サーバーから引っ張る
// プロフィール画像　//   エンコードして取り出す
        let decodeData = (base64Encoded: dict["profileImage"])
        
        let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        //       decodedDataをImage型にする
        let decodedImage = UIImage(data: decodedData! as Data)
        nowtableViewUserImage = decodedImage!
        
//ユーザーネーム
        nowtableViewUserName = (dict["username"] as? String)!
        
// 投稿画像
        let decodeData2 = (base64Encoded: dict["postImage"])
        
        let decodedData2 = NSData(base64Encoded: decodeData2 as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        //       decodedDataをImage型にする
        let decodedImage2 = UIImage(data: decodedData2! as Data)
        nowtableViewImage = decodedImage2!
        
        performSegue(withIdentifier: "sns", sender: nil)
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
    
    @IBAction func showCamera(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func showPhoto(_ sender: Any) {
        openPhoto()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
//  このコントローラーの最初で作ったpassImageと言う変数に撮影した写真を受け渡す
            passImage = pickedImage
//            画面遷移
            performSegue(withIdentifier: "next", sender: nil)
        }
//        カメラ画面（アルバム画面）を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "next"){
//EditViewControllerと言うクラスをeditVCと言う変数に置き換える。さらにそのクラスに遷移する。
            let editVC: EditViewController = segue.destination as! EditViewController
//   そのクラスのwillEditImageと言う箱に撮った写真を入れる
            editVC.willEditImage = passImage
        }
        
        if(segue.identifier == "sns"){
            let snsVC: SnsSnsViewController = segue.destination as! SnsSnsViewController
           
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

