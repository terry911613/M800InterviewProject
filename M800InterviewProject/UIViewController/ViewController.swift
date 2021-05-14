//
//  ViewController.swift
//  M800InterviewProject
//
//  Created by 李泰儀 on 2021/5/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let musicViewModel = MusicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerCell()
        addNotification()
        configureUI()
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "musicCell")
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            if let previousIndexPath = self.musicViewModel.currentPlayIndexPath {
                self.resetPlayButtonImageToDefault(indexPath: previousIndexPath)
                self.musicViewModel.resetCurrentPlayIndexPath()
            }
        }
    }
    
    private func configureUI() {
        searchBar.placeholder = "藝人、歌曲、歌詞或其他內容"
    }
    
    private func resetPlayButtonImageToDefault(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MusicTableViewCell {
            cell.setPlayButton(isPlay: false)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicViewModel.musicCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell {
            if let data = musicViewModel.imageData(for: indexPath) {
                cell.musicImageView.load(data: data)
            }
            else {
                cell.musicImageView.load(urlString: musicViewModel.imageUrl(for: indexPath),
                                         getImageData: { [weak self] in self?.musicViewModel.setImageData(for: indexPath, urlString: $0, data: $1) })
            }
            cell.trackNameLabel.text = musicViewModel.trackName(for: indexPath)
            cell.artistLabel.text = musicViewModel.artistName(for: indexPath)
            cell.setPlayButton(isPlay: musicViewModel.isPlaying(for: indexPath))
            cell.togglePlay = { [weak self] in
                guard let self = self else { return }
                
                if let previousIndexPath = self.musicViewModel.currentPlayIndexPath {
                    if previousIndexPath != indexPath {
                        self.resetPlayButtonImageToDefault(indexPath: previousIndexPath)
                    }
                }
                
                self.musicViewModel.play(indexPath: indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
}

// MARK: - SearchBar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange, searchText = \(searchText)")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        musicViewModel.clickCancel()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            musicViewModel.searchMusic(text: text) { [weak self] (result) in
                switch result {
                case .success(_):
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("error = \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        searchBar.resignFirstResponder()
    }
}
