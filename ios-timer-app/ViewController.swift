//
//  ViewController.swift
//  ios-timer-app
//
//  Created by 허지인 on 2021/11/05.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // 타이머에 설정된 시간을 초로 저장하는 프로퍼티(앱 실행 시 기본적으로 1분 설정 되있기 때문)
    var duration = 60
    var timerStatus: TimerStatus = .end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
        // Do any additional setup after loading the view.
    }
    
    func setTimerInfoViewVisble(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }

    @IBAction func tapCancelButton(_ sender: UIButton) {
        print("asdf")
        switch self.timerStatus {
        case .start, .pause:
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisble(isHidden: true)
            self.datePicker.isHidden = false
            self.toggleButton.isSelected = false
            
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .end: // 기본 상태
            self.timerStatus = .start
            self.setTimerInfoViewVisble(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            
        case .start: //시작된 상태
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
        }
    }
    
}

