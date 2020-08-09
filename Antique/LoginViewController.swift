//
//  LoginViewController.swift
//  Antique
//
//  Created by user on 2020/08/04.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
class LoginViewController: UIViewController {
   
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
         if let address = mailTextField.text, let password = passTextField.text {

             // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
             if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")

                return
             }
            // HUDで処理中を表示
            SVProgressHUD.show()

            
             Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                 if let error = error {
                     print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")

                     return
                 }
                 print("DEBUG_PRINT: ログインに成功しました。")

                // HUDを消す
                SVProgressHUD.dismiss()
                
                 // 画面を閉じてタブ画面に戻る
                 self.dismiss(animated: true, completion: nil)
             }
         }
    }
    @IBAction func createButton(_ sender: Any) {
      if let address = mailTextField.text, let password = passTextField.text, let displayName = nameTextField.text {

                         // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
                         if address.isEmpty || password.isEmpty || displayName.isEmpty {
                             print("DEBUG_PRINT: 何かが空文字です。")
                            SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")

                             return
                         }
        // HUDで処理中を表示
                  SVProgressHUD.show()
                         // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
                         Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                             if let error = error {
                                 // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                                 print("DEBUG_PRINT: " + error.localizedDescription)

                                 return
                             }
                             print("DEBUG_PRINT: ユーザー作成に成功しました。")

                             // 表示名を設定する
                             let user = Auth.auth().currentUser
                             if let user = user {
                                 let changeRequest = user.createProfileChangeRequest()
                                 changeRequest.displayName = displayName
                                 changeRequest.commitChanges { error in
                                     if let error = error {
                                         // プロフィールの更新でエラーが発生
                                         print("DEBUG_PRINT: " + error.localizedDescription)
                                         return
                                     }
                                     print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                                    // HUDを消す
                                    SVProgressHUD.dismiss()
                                     // 画面を閉じてタブ画面に戻る
                                     self.dismiss(animated: true, completion: nil)
                                 }
                             }
                         }
                     }
                 
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
