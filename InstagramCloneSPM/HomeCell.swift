//
//  HomeCell.swift
//  InstagramCloneSPM
//
//  Created by Eray İnal on 6.03.2024.
//

import UIKit

class HomeCell: UITableViewCell {
    //26 TableViewCell içerisindeki her şeyi bu class'da tanımlamalıyım: Öncesinde Main'de yandan Cell seçiliyken 'Identity Inspector' altında Class kısmında 'HomeCell'i seçmeliyiz
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var likeCounterLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //27 Şimdi biz bağlantıyı falan yaptık ama çalıştırsak da uygulamada gözükmez çünkü bunu bir de HomeViewController ile bağlamamız lazım, bunun için HomeViewController'a gidelim
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
    }
    
    
    

}
