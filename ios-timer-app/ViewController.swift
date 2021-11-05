//
//  ViewController.swift
//  ios-timer-app
//
//  Created by 허지인 on 2021/11/05.
//

import UIKit
import AudioToolbox

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
    @IBOutlet weak var imageView: UIImageView!
    
    // 타이머에 설정된 시간을 초로 저장하는 프로퍼티(앱 실행 시 기본적으로 1분 설정 되있기 때문)
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    
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
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            //queue : 어떤 스레드큐에서 반복동작 할건지..
            //타이머가 돌때마다 ui관련 작업을 해줘야하기 때문에 main스레드에서 반복동작 할 수 있게
            //main 스레드는 오직 한개만 존재
            self.timer?.schedule(deadline: .now() + 1, repeating: 1)
            // deadline : 어떤 주기로 실행할지, now는 즉시 실행, +1 은 1초 후에 실행
            // repeating : 몇초마다 반복되도록 할껀지
            self.timer?.setEventHandler(handler: {
                [weak self] in
                guard let self = self else {return}
                self.currentSeconds -= 1 //1씩 감소
                let hour = self.currentSeconds / 3600 //시간
                let minutes = (self.currentSeconds % 3600) / 60 //분
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour,minutes,seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                UIView.animate(withDuration: 0.5, delay:0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi) //180도로 회전시킴
                    //CGAffineTransform 뷰의 프레임을 계산하지 않고 2d 그래픽을 그릴 수 있음
                })
                UIView.animate(withDuration: 0.5, delay:0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2) //360
                })
                //1에서 0으로 갈수록 줄어듦
                
                if self.currentSeconds <= 0 {
                    // 타이머 종료
                    self.stopTimer()
                    //iphonedev.wiki 에서 번호를 확인하 수 있음
                    AudioServicesPlaySystemSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    
    func stopTimer() {
        if self.timerStatus == .pause {
            //일시정지의 경우 resume 메서드를 호출해야함
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil // 메모리 해제 꼭
    }
    

    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
 
        switch self.timerStatus {
        case .end: // 기본 상태
            self.currentSeconds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start: //시작된 상태
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }
    
}

