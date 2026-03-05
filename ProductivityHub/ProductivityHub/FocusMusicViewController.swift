//
//  FocusMusicViewController.swift
//  ios101-project7-task
//
//  Created by Harshit Aggarwal on 11/18/25.
//

import UIKit
import AVFoundation

class FocusMusicViewController: UIViewController {

    private var audioPlayer: AVAudioPlayer?
    private var currentSound: String?
    private var sounds = [
        ("Rain 🌧", "rain"),
        ("Forest 🌲", "forest"),
        ("Café ☕", "cafe"),
        ("Lo-Fi 🎧", "lofi")
    ]

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let nowPlayingLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Focus Music"
        view.backgroundColor = .systemBackground
        setupTable()
        setupNowPlayingLabel()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }

    private func setupNowPlayingLabel() {
        nowPlayingLabel.text = "🎧 No track playing"
        nowPlayingLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nowPlayingLabel.textAlignment = .center
        nowPlayingLabel.textColor = .secondaryLabel
        nowPlayingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nowPlayingLabel)

        NSLayoutConstraint.activate([
            nowPlayingLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            nowPlayingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("⚠️ Missing file:", name)
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // loop forever
            audioPlayer?.play()
            currentSound = name
            nowPlayingLabel.text = "🔊 Now playing: \(displayName(for: name))"
        } catch {
            print("Playback error:", error)
        }
    }

    private func stopSound() {
        audioPlayer?.stop()
        currentSound = nil
        nowPlayingLabel.text = "🎧 No track playing"
    }

    private func displayName(for name: String) -> String {
        return sounds.first(where: { $0.1 == name })?.0 ?? name
    }
}

extension FocusMusicViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.0
        cell.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        cell.textLabel?.textColor = .label
        cell.accessoryType = (currentSound == sound.1) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sound = sounds[indexPath.row]
        if currentSound == sound.1 {
            stopSound()
        } else {
            playSound(named: sound.1)
        }
        tableView.reloadData()
    }
}
