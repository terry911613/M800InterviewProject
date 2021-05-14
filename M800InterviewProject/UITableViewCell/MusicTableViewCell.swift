//
//  MusicTableViewCell.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    private var isPlay: Bool = false
    public var togglePlay: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setPlayButton(isPlay: Bool) {
        self.isPlay = isPlay
        let image = UIImage(named: isPlay ? "stop" : "play")
        image?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(image, for: .normal)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        setPlayButton(isPlay: !isPlay)
        togglePlay?()
    }
}
