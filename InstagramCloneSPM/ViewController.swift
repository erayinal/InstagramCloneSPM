//
//  ViewController.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 25.02.2024.


//1 Burada Swift Package Manager(SPM) nedir onu görücez
//.1 Aslıdna Cocoapods ile biz zaten SDK'ları eklemiştik ama bunu da görelim diye ikinci bir projeyi açtık.Bu yöntem Cocoapods'a göre çok daha kolay. Nasıl yapıldığına bakalım:

//2 Öncelikle menü barından 'File' kısmına gelip 'Add Package Dependencies..'a tıklıyoruz. Burada kendi bilgisayarımızdaki değil de internetteki dosyaları kendi projemize koymamıza imkan sağlıyor.
//.2 Tıkladıktan sonra çıkan ekrandaki metin yerine Firebase tarafından verilen linki kopyalayıp yapıştırıyoruz ve 'Add Packages'a tıklıyoruz. Çıkan sayfada 4 tane pod seçiyoruz(FirebaseFirestore FirebaseAnalytics FirebaseStorage FirebaseAuth). Hepsini  seçmek zorunda kaldıysak uygulamaya tıklayıp 'Build Phases' sekmesinde 'Link Binary With Libraries' altında istediğimizi kaldırabiliyoruz. Ve SPM için işlem bitti indirmiş olduk şimdi sadece son bir adım kaldı
//3 Yandan 'AppDelegate' dosyasına gidip 'import Firebase' ile Firebase'i import ediyoruz

//4 Şimdi Main üzerinden kullanıcı arayüzünü tasarlayalım. Öncelikle bir tane Tab Bar Controller ekleyelim ve ona Show Segue ekleyelim. Segue ekleyince Tab Bar Cont'taki sayfalar üstten atılabilir sayfalar gibi bir görüntü oluşuyor, bunu ortadan kaldırmak için Mainde Segue üzerine tıklayıp Attributes kısmından 'Kind' seçeneğini 'Present Modally' olarak, 'Presentation' seçeneğini ise 'Full Screen' olarak değiştirelim.
//5 İstersek Tab Bar Control'daki sayfaların altındaki butonların isimlerini de simgelerini de değiştirebiliriz. Bunun için iki tane alt alta olan sayfalarda bulunan alttaki butona tıklayarak onların Attributes kısmından Title ve Image ile isim ve simgelerini değiştirebiliriz.

//6 Tasarım bittikten sonra şimdi ViewController üzerinden kodlamaya başlayabiliriz. Önce logInButton methodu içerisine gidip performSegue yapalım

//7 Şimdi bizim tasarımımızda giriş yaptıktan sonra iki tane ViewController var yani altta iki tane simge gözüküyor. Biz buna 3.yü eklemek için; Main içerisine gidip '+' işaretinden ViewController ekleyip ana VC'den bir tane Segue çekmemiz lazım ama burada önemli olan Segue'nin cinsi 'Relationship Segue' olmalı
//.7 İstediğimiz kadar ViewController ekledikten sonra hepsine ayrı ayrı Cocoa Touch Class'ları tanımlamam gerekiyor, bunun için yandaki Project Navigator kısmından 'InstagramCloneSPM' dosyası üzerine sağ tıklayıp 'New File..'a tıklayarak Cocoa Touch Class seçip isim verip ekliyoruz
//..7 Ekledikten sonra eklediğimiz her ViewConroller sayfası için 'Identity Ispector' ayarlarından, 'Class' ayarını daha önce oluşturduğumuz class'dan tek tek eşleştiriyoruz.

//8 Şimdi 'Profil' sayfasına eklediğimiz 'Log Out' butonunu aktif hale getirmek için ProfileViewController class'ına gidelim

//9 Şimdi kullanıcı nasıl oluşturulur ona bakalım. Firebase sitesine gidelim ve Authentication sayfasına gidelim. Burada bir çok sign in methodu var, biz kendi uygulamamız için 'Email/Password' seçicez. Seçtikten sonra Enable'ı aktif hale getiriyoruz ve açmış oluyoruz. Şimdi signUpButton içerisine gidip kodumuza yazalım ama öncesinde'import Firebase' yapmamız gerekiyor

import UIKit
import Firebase //.9


class ViewController: UIViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    

    @IBAction func logInButton(_ sender: Any) {
        //performSegue(withIdentifier: "toFeedVC", sender: nil) //.6
        
        if(usernameText.text != "" && passwordText.text != ""){ //.13 Eğer username ve password boş değilse:
            
            Auth.auth().signIn(withEmail: usernameText.text!, password: passwordText.text!) { authData, error in
                if(error != nil){   //..13 Buralar zaten signUpButton ile aynı, oradan istersek detaylara bakabiliriz
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Eror")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil) //...13 Şifreyi Firebase bizim için kontrol ediyor
                }
            }
            
        }
        else{ //..13 Eğer username ve password boş ise hata mesajı versin:
            makeAlert(title: "Error!", message: "Username/Password?")
        }
        
        //14 Sign Up ve Sign In olaylarını hallettik ama biz isiyoruz ki kullanıcı uygulamayı kapattıktan sonra tekrar uygulmaya giriş yaparsa, tekrardan kullanıcı adı ve şifre sormayalım, log out olana kadar direkt giriş yapsın. Bunun için yandan 'SceneDelegate' class'ına gitmemiz gerekiyor.
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        if(usernameText.text != "" && passwordText.text != ""){ //10 Eğer username ve şifre boş değilse kullanıcı oluştursun
            Auth.auth().createUser(withEmail: usernameText.text!, password: passwordText.text!) { authData, error in
                
                if(error != nil){   //11 Eğer kullanıcı oluşturulamaz ve bir error verirse mesela Firebase en az 6 karakter istiyor şifre için ve bunun hatasını otomatik veriyor bizim için biz de hata varsa bunu kullanıcıya vermeliyiz
                    //12 Tekrar tekrar alert yazmayalım diye aşağıda bir tane alert fonksiyonu yazalım
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Eror") //..12 Burada error!.localizedDescription yapmamak için 'Default Value' verdik ki hata vermesin, hata açıklaması olmasa da direkt "Error" yazıp geçicek
                    
                }
                else{ //.11 Eğer kullanıcı oluşturulursa performSegue yapıp giriş sayfasına yönlendiricez
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
        else{ //.10 Eğer username ve password boşsa bir alert verelim
            let alert = UIAlertController(title: "Don't Exist", message: "Username/Password?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
        //13 Böylece kullanıcı yaratma adımı bitti, şimdi signInButton'a geçip giriş yapalım
        
    }
    
    
    
    func makeAlert(title: String, message: String){ //.12
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}

