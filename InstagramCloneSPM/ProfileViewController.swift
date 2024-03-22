//
//  ProfileViewController.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 25.02.2024.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var darkModeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        //.8 Bunu yapabilmek için öncelikle Main'de ProfileViewController'ndan ana sayfamıza bir Show Seguesi yapalım ve ona isim verelim
        //performSegue(withIdentifier: "toViewController", sender: nil)
        
        
        //.15 Biz burada sadece Segue yapmasını istemiyoruz, çıkış yapınca Firebase'den de çıkış yapsın. Öncelikle Firebase'i import edelim
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch{
            print("Error") //..15 Herhangi bir sorun için bunu yapıyoruz, normalde olmaması lazım ama internet falan giderse bile error mesajı versin istiyoruz
        }
        
        //16 Şuan giriş ve çıkış işlemlerini hallettik, NewPostVC sayfasına geçip onu yapmaya başlayalım
        
    }
    
    
    
    //35 Info içerisinde uygulamayı her zaman light modda çallışsın diye ayarlama yaptım
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        
        if #available(ios 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first
            
            if (sender.isOn){
                darkModeLabel.textColor = .white
                appDelegate?.overrideUserInterfaceStyle = .dark
                return
            }
            darkModeLabel.textColor = .black
            appDelegate?.overrideUserInterfaceStyle = .light
            return
            
        }
        
    }
    

}
