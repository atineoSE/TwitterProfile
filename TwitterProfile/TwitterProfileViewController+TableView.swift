//
//  TwitterProfileViewController+TableView.swift
//  TwitterProfile
//
//  Created by Adrian Tineo on 20.02.19.
//  Copyright © 2019 adriantineo.com. All rights reserved.
//

import Foundation
import UIKit

extension TwitterProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TweetTableViewCell.self), for: indexPath) as! TweetTableViewCell
        tweetCell.title = "Tweet " + String(describing: indexPath.row)
        
        return tweetCell
    }
    
}

extension TwitterProfileViewController: UITableViewDelegate {
    
}
