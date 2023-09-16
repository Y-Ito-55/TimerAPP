//
//  ViewController.swift
//  TimerAPP
//
//  Created by Yumi Ito on 2023/09/15.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var backgroundImageView: UIImageView!  // メンバ変数として背景用のUIImageViewを追加
    var haikuLabel: UILabel = UILabel()  // ラベルのインスタンスを作成
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // 1分後、3分後、...、12時間後までの選択肢
    let alarmIntervals = [1, 3, 5, 10, 30] + Array(stride(from: 60, through: 720, by: 30))
    var selectedInterval = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                    DispatchQueue.main.async {
                        if granted {
                            print("アラーム通知を許可しました")
                            
                            // 背景画像と俳句の初期設定
                            self.setupBackgroundImageView()
                            self.setupHaikuLabel()
                            self.setupHaikuLabelConstraints()
                        } else {
                            print("アラーム通知を拒否しました")
                        }
                    }
                }
            }
        
    func setupBackgroundImageView() {
        if backgroundImageView == nil {
            backgroundImageView = UIImageView(frame: self.view.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            self.view.insertSubview(backgroundImageView, at: 0) // 背景として追加
        
        }
        
        func setupHaikuLabel() {
            haikuLabel.numberOfLines = 3
            haikuLabel.textAlignment = .center
            haikuLabel.font = UIFont.systemFont(ofSize: 20)
            view.addSubview(haikuLabel)
        }
        // 俳句のラベルのAutoLayoutを設定する関数
        func setupHaikuLabelConstraints() {
            // 画面のサイズを取得（不要であれば削除しても良い）
            let screenSize = UIScreen.main.bounds.size
            
            // 俳句のラベルを画面の下部中央に配置
            haikuLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                haikuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                haikuLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)  // 20はマージンとして追加。必要に応じて変更可能。
            ])
        }
        
        
        // アクションの定義
        let returnAction = UNNotificationAction(identifier: "returnAction", title: "アプリに戻る", options: .foreground)
        
        // カテゴリの定義
        let alarmCategory = UNNotificationCategory(identifier: "alarmCategory", actions: [returnAction], intentIdentifiers: [], options: [])
        
        // カテゴリの登録
        center.setNotificationCategories([alarmCategory])
        
        pickerView.delegate = self
        pickerView.dataSource = self

    }
    
    // MARK: - UIPickerView Data Source & Delegate
    
    func updateBackgroundAndLabel() {
        setBackgroundImageRandomly()
        setRandomHaiku()
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
        // ここでbackgroundImageViewの初期化を確認して、必要な場合は初期化します。
        //            if backgroundImageView == nil {
        //                backgroundImageView = UIImageView(frame: self.view.bounds)
        //                backgroundImageView.contentMode = .scaleAspectFill
        //                view.addSubview(backgroundImageView)
        //            }
        //        let nightImage = arc4random_uniform(2) == 0 ? "夜空1" : "夜空2"
        //        backgroundImageView.image = UIImage(named: nightImage)
        
        content.title = "アラーム"
        content.body = "時間です！"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarmCategory"
        
        startButton.isHidden = true  //アラームセットSTART押したら隠れて
        stopButton.isHidden = false  //STOPボタンが出てくる
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(TimeInterval(selectedInterval * 60)))
        // triggerDateの値をログ出力
        print("Trigger Date: \(triggerDate)")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)//5秒後に通知
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // アラートを表示
        let alertController = UIAlertController(title: "アラーム", message: "アラームセット完了", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        // 背景画像の変更
        changeRandomBackground()
        
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
    
    func changeRandomBackground() {
        if backgroundImageView == nil {
            backgroundImageView = UIImageView(frame: self.view.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            self.view.insertSubview(backgroundImageView, at: 0) // 背景として追加
        }
    }
    
    func setBackgroundImageRandomly() {
        let imageNames = ["ジュエル1", "ジュエル2", "ひまわり1", "ひまわり2", "ひまわり3", "ひまわり4", "糸1", "糸2", "糸3", "糸4", "糸5", "天然石1", "天然石2", "おはじき1", "おはじき2"]
        let randomImageName = imageNames.randomElement()!
        if backgroundImageView == nil {
            backgroundImageView = UIImageView(frame: self.view.bounds)
            backgroundImageView.contentMode = .scaleAspectFill
            view.addSubview(backgroundImageView)
            view.sendSubviewToBack(backgroundImageView)
            
        }
        backgroundImageView.image = UIImage(named: randomImageName)
    }
    
    func setupHaikuLabel() {
        haikuLabel.numberOfLines = 3
        haikuLabel.textAlignment = .center
        haikuLabel.font = UIFont.systemFont(ofSize: 20)
        haikuLabel.frame = CGRect(x: 20, y: (view.frame.height - 100) / 2, width: view.frame.width - 40, height: 100)
        view.addSubview(haikuLabel)
    }
    
    // ランダムな俳句を生成して表示する関数
    func setRandomHaiku() {
        let uppers = ["風が伝える", "星が瞬く", "花びらが舞う", "遠くの雲", "朝のきらめき"]
        let middles = ["未来の囁き", "運命の糸", "空を駆ける", "まだ見ぬ光", "道は何処へ", "涙も笑顔も"]
        let lowers = ["光の先へ", "明日への道", "叶う夢", "共に流れて", "キャンバスに描く", "目覚める魔法"]
        
        let randomUpper = uppers.randomElement()!
        let randomMiddle = middles.randomElement()!
        let randomLower = lowers.randomElement()!
        
        haikuLabel.text = "\(randomUpper)\n\(randomMiddle)\n\(randomLower)"
    }
    
    func alarmEnded() {
        // 画像をランダムで設定
        setBackgroundImageRandomly()
        // 俳句をランダムで設定
        setRandomHaiku()
    }
  
}
