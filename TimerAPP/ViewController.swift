//
//  ViewController.swift
//  TimerAPP
//
//  Created by Yumi Ito on 2023/09/15.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var backgroundImageView: UIImageView!
    var haikuLabel: UILabel = UILabel()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let alarmIntervals = [0, 1, 3, 5, 10, 30] + Array(stride(from: 60, through: 720, by: 30))
    var selectedInterval = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(alarmIntervals)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    print("アラーム通知を許可しました")
                    
                    self.setupBackgroundImageView()
                    self.setupHaikuLabel()
                    self.setupHaikuLabelConstraints()
                    
                    let returnAction = UNNotificationAction(identifier: "returnAction", title: "アプリに戻る", options: .foreground)
                    let alarmCategory = UNNotificationCategory(identifier: "alarmCategory", actions: [returnAction], intentIdentifiers: [], options: [])
                    center.setNotificationCategories([alarmCategory])
                } else {
                    print("アラーム通知を拒否しました")
                }
            }
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // UIPickerViewとUIButtonのデザインを変更する
        styleUIElements()
        }

        func styleUIElements() {
            // PickerViewのスタイル設定
            pickerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            pickerView.layer.cornerRadius = 15
            pickerView.layer.masksToBounds = true

            // startButtonのスタイル設定
            startButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            startButton.layer.cornerRadius = 15
            startButton.layer.masksToBounds = true
            
            // stopButtonのスタイル設定
            stopButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            stopButton.layer.cornerRadius = 15
            stopButton.layer.masksToBounds = true
            
            // haikuLabelのデザインを変更
            haikuLabel.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            haikuLabel.layer.cornerRadius = 10
            haikuLabel.clipsToBounds = true
    }
 
    // 通知に対するアクションで呼び出されるメソッドを追加
    func alarmEnded() {
        // このメソッドが呼び出されたときに背景画像と俳句を更新する
                setBackgroundImageRandomly()
                setRandomHaiku()
        }

        // 背景画像とラベルを更新するメソッドを追加
    func updateBackgroundAndLabel() {
            setBackgroundImageRandomly()
            setRandomHaiku()
        }
    
    func setupBackgroundImageView() {
        if backgroundImageView == nil {
            backgroundImageView = UIImageView(frame: self.view.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            self.view.insertSubview(backgroundImageView, at: 0)
        }
    }
    
    func setupHaikuLabel() {
        haikuLabel.numberOfLines = 3
        haikuLabel.textAlignment = .center
        haikuLabel.font = UIFont(name: "uzurafont.ttf", size: 20)
        view.addSubview(haikuLabel)
    }
    
    func setupHaikuLabelConstraints() {
        haikuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            haikuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            haikuLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120)
        ])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alarmIntervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if alarmIntervals[row] < 60 {
            return "\(alarmIntervals[row])分後"
        } else {
            return "\(alarmIntervals[row]/60)時間後"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedInterval = alarmIntervals[row]
    }
    
    @IBAction func setAlarm(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "アラーム"
        content.body = "時間です！"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarmCategory"
        
        startButton.isHidden = true
        stopButton.isHidden = false
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(TimeInterval(selectedInterval * 60)))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let alertController = UIAlertController(title: "アラーム", message: "アラームセット完了", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        // アラームをセットした際の背景画像を「夜空1」に設定
        backgroundImageView.image = UIImage(named: "夜空1")
        
        center.add(request) { (error) in
            if let error = error {
                print("アラームセット失敗: \(error.localizedDescription)")
            } else {
                print("アラームをセットしました")
            }
        }
    }
    
    @IBAction func STOP(_ sender: Any) {
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    func setBackgroundImageRandomly() {
        let imageNames = ["ジュエル1", "ジュエル2", "ひまわり1", "ひまわり2", "ひまわり3", "ひまわり4", "糸1", "糸2", "糸3", "糸4", "糸5", "天然石1", "天然石2", "おはじき1", "おはじき2"]
        let randomImageName = imageNames.randomElement()!
        backgroundImageView.image = UIImage(named: randomImageName)
    }
    
    func setRandomHaiku() {
        let uppers = ["風が伝える", "星が瞬く", "花びらが舞う", "遠くの雲", "朝のきらめき"]
        let middles = ["未来の囁き", "運命の糸", "空を駆ける", "まだ見ぬ景色", "流れる時の中で"]
        let lowers = ["心の奥深く", "指先に触れる", "夢と現の境界", "希望の彼方へ", "瞳を閉じて感じる"]
        
        let upper = uppers.randomElement()!
        let middle = middles.randomElement()!
        let lower = lowers.randomElement()!
        
        haikuLabel.text = "\(upper)\n\(middle)\n\(lower)"
    }

}

