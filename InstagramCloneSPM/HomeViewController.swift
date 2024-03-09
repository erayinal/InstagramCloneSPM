//
//  HomeViewController.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 25.02.2024.
//

import UIKit
import Firebase
import SDWebImage

//.25 Şimdiye kadar sadece String yazılan tableView'lar yaptık, şimdi ise özelleştirebileceğimiz özel tableView yapmayı öğreneceğiz
//..25 Öncelikle 'Main' içerisine gidip her zaman kullandığımız normal TableView ekleyelim ve bu class içerisinde tanımlayalım. Sonra main içerisine geri dönüp tableView'a tıklıyoruz ve yanda 'Attributes Inspector' altında 'Prototype Cells' kısındaki sayıyı 1 yapalım ve çıkan şekli büyüttükten sonra imageView falan ekleyerek özelleştirelim.
//...25 Şimdi 1 tanesi için Protatype Cell tasarımı yaptık ama bunu alıp bütün cell'lerde kullanmamız lazım. Öncelikle 'Main'de yandan 'Table View Cell' seçili iken 'identifier' kısmından id vermemiz lazım biz buna 'Cell' diyelim. Table View Cell'lerin kendi CocoTouch sınıfı oluyor ve bu tasarımdaki her şeyi(UIimage'ı, labelları butonları) oluşturacağımız class içerisinde tanımlamamız lazım. Bunun için yandan 'InstagramCloneSPM' üzerine sağ tık yapalım ve 'New File..' ile CocoTouch Class'a tıklayalım, çıkan ekranda 'Subclass of' kısmı 'UITableViewCell' OLMALI ve adınada 'HomeCell' diyelim adın zaten çok bir önemi yok. Oluşturduktan sonra 'Main'deki table view üzerindeki Table View Cell içerisindeki her şeyi oluşan class'a tanımlamalıyım. Geçip tanımlayalım


//.27 öncelikle UITableViewDelegate, UITableViewDataSource bunları interface olarak implement edelim
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()  //.29 Resimleri de String olarak kaydetmiştik yani URL olarak
    var documentIDArray = [String]() //.33
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self //..27 Bunları yazalım sonrasdına gerekli fonksiyonları da çağıralım
        
        getDataFromFirestore()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeCell //...27 Bu 'cell' variable'ı ile tanımladığımız tasarım içerisindeki butonlara labellara falan ulaşabiliyoruz
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeCounterLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //cell.userImageView.image = UIImage(named: "select (1)")
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row])) //.31 Burada normalde 'complated' de yer alıyor bunu ilk çağırdığımızda ama CDWebImage o olmadan da kabul ediyor o yüzden sildim
        
        cell.documentIDLabel.text = documentIDArray[indexPath.row] //.....33
        
        return cell
        
        //28 Buraya kadar her şey tamam şimdi Firebase'den veri nasıl çekilir ona bakalım. Veri çekmek için iki yol vardır: birincisi bir kerelik veri çekme, ikincisi ise değişiklik olursa çat diye veri çekme. Bizim kullanacağımız ikincisi çünkü beğeni olduğunda beğenideki artışı falan direkt çekmemiz lazım. Bunun için 'getDataFromFirestore' adında bir method oluşturalım:
    }
    
    
    func getDataFromFirestore(){
        //.28 başlamadan önce Firebase'i import etmeliyiz
        let fireStoreDatabase = Firestore.firestore()
        
        //..28 Fotoğrafı paylaşırken tarih kaydetmenin bir olumsuz yönü var bunun için bir ayar yapmamız lazım
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            //32 Şimdi tarihe göre postlar nasıl dizilir onu öğrenicez aslında sadece tarih değil istediğimiz şekilde de dizebiliriz. Bunun için hemen bu üst satırda yazılı kod satırında 'fireStoreDatabase.collection("Posts")'dan sonra 'order(by: "date", descending: true)' ekliyoruz ve tarihe göre AZALARAK bunları gösterecek, azalarak göstermesini descending'i true yaparak ayarladım.
            
            if(error != nil){
                print(error?.localizedDescription)
            }
            else{
                
                if(snapshot?.isEmpty != true && snapshot != nil){ //...28 snapshot sayesinde bana postların içinde bulunduğu bir array verecek, ben de bu arraydeki elemanları loop içine alıcam ve Home sayfasında göstericem
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false) //..31
                    self.documentIDArray.removeAll(keepingCapacity: false) //..33
                    
                    for document in snapshot!.documents{
                        
                        //....28 Biz burada 'document' variable'ı ile bir postun kim tarafınfan atıldığına beğeni sayısına falan hepsine ulaşabiliriz, mesela kim tarafından atıldığını print ettirelim:
                        //print(document.get("postedBy")!)
                        
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID) //...33 Şimdi main içerisine gidip gizli bir label oluşturalım. Gizli yapmak için yandan Attributes sekmesinden aşağıda 'Hidden' yapıcaz, sonrasında 'HomeCell' class'ı içerisinde tanımlayalım
                        //29 Yukarıda sınıfın başında sonradan kullanacğımız Array'ler tanımlayalım
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageURL)
                        }
                        //.29 Bunları yazdıktan sonra hemen altta table.reloadData yapmamız lazım
                    }
                    self.tableView.reloadData()
                    
                    
                    //30 Buraya kadar yazıklarımızı çalıştırırsak resimlerin gelmesi ve like butonu dışında her şey sorunsuz çalışır, tabi bir de post'ları tarihe göre sıralamamız lazım. Şimdi öcelikle resim eklemeye bakalım, bunun için çok farklı kütüphaneler var. Bizim kullanacağımız şey için google'a 'github.com/SDWebImage' yazarak gidelim ve kullanabilmek için indirelim. İndirmek için Click File -> Swift Packages -> Add Package Dependency, enter SDWebImage repo's URL girerek indiriyoruz
                    //31 Öncelikle SDWebImage'ı import edelim ve sonrasında 'cellForRowAt' fonksiyonunun içine gidip userImageView kısmında önceki kodu yorum satırına alıp yeni kodu yazalım
                    
                }
            }
        }
        //.....28 Bu methodu viewDidLoad altında çağıralım
        
    }
    

    
   

}
