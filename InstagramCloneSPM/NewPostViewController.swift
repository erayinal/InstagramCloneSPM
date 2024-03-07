//
//  NewPostViewController.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 25.02.2024.
//

//.16 Burada öncelikle dikkat etmemiz gereken şey, mainde UI'ı yaparken 'İmage View' eklerken ona bir de 'Width ve Height' değerleri vermek çünkü çok büyük bir resim girildiği zaman saçma bir hal alabilir.

import UIKit
import Firebase
import FirebaseStorage

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var shareButton: UIButton!   //17 Bunu sadece action olarak değil hem 'Outlet' hem de 'Action' olarak tanımladım, çünkü resim seçilmemişken bunun inaktif olması gerekiyor. Şimdi viewDidLoad methodu içerisine gidelim
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //.17 Resim seçme işlemini yapabilmemiz için öncelikle imageView'ı tıklanabilir yapmamız lazım
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self //..17 Bu satırı yazınca hata verecek çünkü bu sınıfın başında interface etmen gereken interface'ler var(UIImagePickerControllerDelegate, UINavigationControllerDelegate)
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true  // Burada editlemeye izin verdik bu yüzden imagePickerController içerisinde de editesImage olarak seçmek zorundayız
        present(pickerController, animated: true, completion: nil)
        //...17 Şimdi bir de didFinish methody yazmalıyız
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        //....17 Şidmi 'Info' sayfasından 'Privacy - Photo Library Usage' seçelim ve 'To Choose a Photo' yazalım
        //18 Buraya kadar fotoğraf seçme işlemini falan halletik şimdi 'Share' tuşuna basınca bu fotoğrafı ve yorumu Firebase'a atma ve Firebase'den çekerek Ana sayfada göstermek var. Bunun için Firebase sitesine gidip oradan 'Stroge'a tıklayalım. Tıklayınca iki adımlı iki tane soru soruyor, birincisi bize önce uygulamamız için Security Rules'ların nasıl olsun diye soruyor(default hali=giriş yapmayan biri de bakar/okur ama bir şey kaydetmek için Authantication'dan geçmiş olması lazım yani kullanıcı adı ve şifresiyle giriş yapmış olması lazım. İkinci soru ise 'Verileri nereye Kaydedeyim', burada mantıklı olan uygulamanın hedef kitlesi neredeyse oraya yakın bir yeri seçmemiz mantıklıdır. Globalse Avrupa, türkiye ise Avrupa, Amerika için Amerika yı seçmeliyiz. Bu ikinci ayarı sonradan değiştiremiyoruz o yüzden önemli bir adım. Bu iki sorudan sonra bizim için bir depolama alanı oluşturuluyor ve artık veri kaydedebiliyoruz.
        //.18 Oluşturuldu ve biz buradan 'Create Folder' ile fotoğrafları kaydetmek için bir media adında bir dosya yapalım. Açtıktan sonra koddan bu dosyaya ulaşabiliyoruz, buna istersek sitedeki 'Guides' kısmından da oluyarak detaylarıyla yapabiliriz ama biz hemen bakmadan yapmaya başlayalım:
        //19 Öncelikle bu class'ta Firebase'i import edelim. Ve şimdi 'shareActionButton'a gidelim
    }
    
    
    @IBAction func shareActionButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference() //.19 bu referansı kullanarak hangi klasörle çalışacağımızı nereye kaydedeceğimizi falan belirtiyirouz
        
        let mediaFolder = storageReferance.child("Media") //..19 Firabase'de 'Media' dosyası aslında tüm Strorageın alt birimi. Firebase'de 'Media' adında bir dosya olmasa da sorun olmaz, bizim için kendi oluşturur. Media'nın da alt dosyaları olsaydı .child ile onlara da ulaşabilirdik
        
        //...19 Şimdi asıl olay nasıl kaydedeceğimiz. Kaydedebilmek için bizim görseli veriye çevirmemiz gerekiyor, çevirdikten sonra kaydedebiliyoruz, UIImage olarak kaydedemiyoruz:
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){ //....19 '0.5' burada bizim resmi sıkıştırma katsayımız
            
            let uuid = UUID().uuidString //.21
            //let imageReferance = mediaFolder.child("images.jpg")
            //let imageReferance = mediaFolder.child(uuid) //..21 Şimdi bu yaptığımız değişiklikten sonra kaydedilen dosyaları indirirsek 'jpg' değil de 'dms' olarak indiğini görücez, bunun için bu satırı da yorum satırına alıyorum ve düzeltilmiş halini yazalım:
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            
            
            imageReferance.putData(data, metadata: nil) { metaData, error in
                if(error != nil){
                    //print(error?.localizedDescription)  //22 şimdi error meydana gelirse alert vermek için bu satırı yorum satırına alalım ve bir tane hazır method yazıp burada kullanalım:
                    self.makeAlert(titleInput: "ERROR!", message: error?.localizedDescription ?? "Error") //..22
                    
                 }else{
                    imageReferance.downloadURL { url, error in
                        if(error==nil){
                            let imageUrl = url?.absoluteString  //20 Bu şekilde yüklediğimiz resmin url'sini alıyoruz ve aldığımız bu url'yi tarayıcıya yazarsak indirme yapar ve yükleme yaptığımız resmi indirir. İndirebilmemizin sebebi bizim firebase'imize kaydolması, bunu firebase'e gidip görebiliriz
                            //print(imageUrl)
                        
                            //21 Upload işleminin çoğu tamam ama şöyle küçük bir olay var, yüklediğimiz her fotoğrafın adı 'image.jpg' olacak bu da her defasında önceki fotoğrafın silinmesine ve sadece bir fotoğrafın kaydolmasına sebep olur. Yapmamız gereken her görsele farklı unique bir isim sağlamak. Bunun için 'images.jpg' yazdığımız satırı yorum satırına alalım ve onun hemen üst satırında uuid tanımlayalım
                            
                            
                            //23 Şimdi imageUrl'sini print'lemeyelim o yüzden yukarıdaki print(imageUrl) satırını yorum satırına alalım ve Firebase sitesinde 'Firestore Database' sekmesine girelim. Girdikten sonra 'Create database'e tıklayınca bize iki seçenek sunuyor birincisi 'locked mode' yani kimse yazıp okuma yapamaz, ikincisi ise 'Test mode' yani herkes yazma ve okuma yapabiliyor. Biz burada 'Test Mode'u seçicez. Oluşturduktan sonra Database hazır ve 'Start collection'a basalım, Id'si 'Posts' olsun, sonrasında Document ID kısmını auto-id diyelim, field kısmına 'comment' Value kısmına 'I love this photo' diyelim ve 'Save'e tıklayalım. Şimdi nasıl olduğunu anladığımıza göre 3 noktadan 'Delete Collection' ile silelim. Baştan oluşturucaz, yazmaya başlayalım:
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReferance : DocumentReference? = nil
                            let firestorePost = ["imageUrl":imageUrl! , "postedBy":Auth.auth().currentUser!.email! , "postComment":self.commentText.text! , "date":FieldValue.serverTimestamp() , "likes":0] as [String : Any]
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if(error != nil){
                                    self.makeAlert(titleInput: "Error!", message: error?.localizedDescription ?? "Error")
                                }else{
                                    //24 Eğer hata çıkmazsa postumuz başarıyla paylaşıldı demektir, yani biz paylaştıktan sonra kullanıcıyı ana menüye atabiliriz.
                                    
                                    self.imageView.image = UIImage(named: "select (1)")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0  //.24 selected index ile 0 dersek ana sayfaya 1 dersek keşfet sayfasına 3 dersek... götürecek. Yani bu çok kullanışlı aslında. Tabi geçmeden NewPost sayfasındaki resmi yazıyı falan temizlememiz lazım ki geri gelirse aynı görüntüyle kaşılaşmasın. Bu yüzden bu satırın üstünde temizleme işlemlerini yapalım
                                    
                                    //25 Şimdi Home sayfasını tasarlamak için 'HomeViewController' class'ına geçelim
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    func makeAlert(titleInput: String, message : String) {
        let alert = UIAlertController(title: titleInput, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    } //.22 Şimdi bunu kullanalım
    
    

}
 
