//
//  HomeCell.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 6.03.2024.
//

import UIKit
import Firebase

class HomeCell: UITableViewCell {
    //26 TableViewCell içerisindeki her şeyi bu class'da tanımlamalıyım: Öncesinde Main'de yandan Cell seçiliyken 'Identity Inspector' altında Class kısmında 'HomeCell'i seçmeliyiz
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var likeCounterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var documentIDLabel: UILabel!    //....33 şimdi bir de HomeVC içerisindeki tableView fonksiyonu içerisinde de düzenlemem lazım
    
    
    //27 Şimdi biz bağlantıyı falan yaptık ama çalıştırsak da uygulamada gözükmez çünkü bunu bir de HomeViewController ile bağlamamız lazım, bunun için HomeViewController'a gidelim
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        //33 Ben like butonuna tıklanınca Firebase'e gidilsin hangi postun like'ına tıklandıysa oradaki like sayısı alınsın bir artırılsın ve sonra tekrar kaydedilsin istiyorum. Öncelikle HomeVC içerisne gidip bir Document array'i oluşturalım
        
        //......33 ben artık gizli array sayesinde hangi postun yani dökümanın like butonuna basıldığını anlayabilicem
        
        //34 Önce Firebase'i import edelim
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCounterLabel.text!){
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)    //.34 .setData ile biz sadece Firebase'deki 'likes'ı güncelliyicez, diğerlerine karışmıyoruz
        }
        
        print(documentIDLabel.text!)
        print("clicked")
        
    }
    
}
