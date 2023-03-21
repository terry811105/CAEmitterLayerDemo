//
//  ViewController.swift
//  CAEmitterLayerDemo
//
//  Created by CM0749 on 2023/1/11.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("開始下雪", for: .normal)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("停止下雪", for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var snowEmitterLayer: CAEmitterLayer = {
        return CAEmitterLayer()
    }()
    
    private lazy var fireworkEmitterLayer: CAEmitterLayer = {
        return CAEmitterLayer()
    }()
    
    private lazy var sparkEmitterLayer: CAEmitterLayer = {
        return CAEmitterLayer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        snowAnimate()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [startButton, closeButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(fireWork(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    private func snowAnimate() {
        // 要發射的粒子
        let flakeEmitterCell = CAEmitterCell()
        // 粒子的內容
        flakeEmitterCell.contents = UIImage(named: "snowflake")?.cgImage
        // 粒子的大小
        flakeEmitterCell.scale = 0.012
        // 粒子的大小範圍0.005(0.015 - 0.01) ~ 0.025(0.015+0.01)
        flakeEmitterCell.scaleRange = 0.01
        // 發射的角度範圍
        flakeEmitterCell.emissionRange = .pi
        // 粒子存活時間15秒
        flakeEmitterCell.lifetime = 15.0
        // 粒子創建速度每秒30個
        flakeEmitterCell.birthRate = 50
        // 粒子的速度
        flakeEmitterCell.velocity = -30
        // 粒子速度的容差
        flakeEmitterCell.velocityRange = -20
        // y 軸加速度
        flakeEmitterCell.yAcceleration = 30
        // x 軸加速度
        flakeEmitterCell.xAcceleration = 5
        // 旋轉度數
        flakeEmitterCell.spin = -0.5
        // 旋轉度數範圍
        flakeEmitterCell.spinRange = 1.0
        // 透明度每秒鐘的變化，比如寫 – 0.1 就是每秒透明度減少 0.1 這樣就會有慢慢消失的效果
        flakeEmitterCell.alphaSpeed = 0
        // 建立好 CAEmitterCell 之後，需要通過 CAEmitterLayer 顯示內容。
        // 發射位置
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
        // 發射器的尺寸
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        // 發射形狀
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        // 粒子產生的係數(CAEmitterCell 的 birthRate * CAEmitterLayer 的 birthRate)
        snowEmitterLayer.birthRate = 1
        //
        //snowEmitterLayer.beginTime = CACurrentMediaTime()
        // 設置 timeOffset 允許動畫以偏移量開始，以便使用者從一開始就自動看到雪花覆蓋整個螢幕
        snowEmitterLayer.timeOffset = 10
        // 發射模式
        snowEmitterLayer.emitterMode = .volume
        // 裝進layer
        snowEmitterLayer.emitterCells = [flakeEmitterCell]
        // 加入動畫子圖層
        view.layer.addSublayer(snowEmitterLayer)
    }
    
    @objc private func didTapCloseButton() {
        // snowEmitterLayer.birthRate = 0
        snowEmitterLayer.removeFromSuperlayer()
    }
    
    @objc private func didTapStartButton() {
        // snowEmitterLayer.birthRate = 1
        print("view.layer \(view.layer.sublayers?.count)")
        view.layer.addSublayer(snowEmitterLayer)
        // snowAnimate()
    }
    
}

extension ViewController {
    
    @objc private func fireWork(_ recognizer: UITapGestureRecognizer) {
        fireworkEmitterLayer.removeFromSuperlayer()

        view.layer.addSublayer(fireworkEmitterLayer)

        fireworkEmitterLayer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        fireworkEmitterLayer.emitterShape = .point
        fireworkEmitterLayer.emitterPosition = recognizer.location(in: view)
        fireworkEmitterLayer.emitterSize = CGSize(width: 0.0, height: 0.0)
        fireworkEmitterLayer.emitterMode = .outline
        fireworkEmitterLayer.renderMode = .additive

        let cell1 = CAEmitterCell()

        cell1.name = "Parent"
        cell1.birthRate = 5.0
        cell1.lifetime = 2.5
        cell1.velocity = 300.0
        cell1.velocityRange = 100.0
        cell1.yAcceleration = -100.0
        cell1.emissionLongitude = -90.0 * (.pi / 180.0)
        cell1.emissionRange = 45.0 * (.pi / 180.0)
        cell1.scale = 0.001
        cell1.scaleRange = 0.001
        cell1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        cell1.redRange = 0.9
        cell1.greenRange = 0.9
        cell1.blueRange = 0.9

        let image1_1 = UIImage(named: "Ellipse-261")?.cgImage

        let subcell1_1 = CAEmitterCell()
        subcell1_1.contents = image1_1
        subcell1_1.name = "Trail"
        subcell1_1.birthRate = 45.0
        subcell1_1.lifetime = 0.5
        subcell1_1.beginTime = 0.01
        subcell1_1.duration = 1.7
        subcell1_1.velocity = 80.0
        subcell1_1.velocityRange = 100.0
        subcell1_1.xAcceleration = 100.0
        subcell1_1.yAcceleration = 350.0
        subcell1_1.emissionLongitude = -360.0 * (.pi / 180.0)
        subcell1_1.emissionRange = 22.5 * (.pi / 180.0)
        subcell1_1.scale = 0.0005
        subcell1_1.scaleRange = 0.0001
        subcell1_1.scaleSpeed = 0.05
        subcell1_1.alphaSpeed = -0.7
        subcell1_1.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        let image1_2 = UIImage(named: "Ellipse-261")?.cgImage

        let subcell1_2 = CAEmitterCell()
        subcell1_2.contents = image1_2
        subcell1_2.name = "Firework"
        subcell1_2.birthRate = 1500.0
        subcell1_2.lifetime = 15.0
        subcell1_2.beginTime = 1.6
        subcell1_2.duration = 0.1
        subcell1_2.velocity = 190.0
        subcell1_2.yAcceleration = 80.0
        subcell1_2.emissionRange = 360.0 * (.pi / 180.0)
        subcell1_2.spin = 114.6 * (.pi / 180.0)
        subcell1_2.scale = 0.0001
        subcell1_2.scaleRange = 0.0001
        subcell1_2.scaleSpeed = 0.05
        subcell1_2.alphaSpeed = -0.7
        subcell1_2.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

        cell1.emitterCells = [subcell1_1, subcell1_2]

        fireworkEmitterLayer.emitterCells = [cell1]

    }
    
    @objc private func spark(_ recognizer: UITapGestureRecognizer) {

        sparkEmitterLayer.removeFromSuperlayer()
        
        sparkEmitterLayer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        sparkEmitterLayer.emitterShape = .point
        sparkEmitterLayer.emitterPosition = recognizer.location(in: view)
        sparkEmitterLayer.emitterSize = CGSize(width: 0.0, height: 0.0)
        sparkEmitterLayer.emitterMode = .surface
        sparkEmitterLayer.renderMode = .additive
        
        let image1 = UIImage(named: "Ellipse-261")?.cgImage

        let cell1 = CAEmitterCell()
        cell1.contents = image1
        cell1.name = "Spark"
        cell1.birthRate = 1000.0
        cell1.lifetime = 1.1
        cell1.velocity = 95.0
        cell1.velocityRange = 490.0
        cell1.xAcceleration = 181.0
        cell1.yAcceleration = 223.0
        cell1.emissionLatitude = 164.0 * (.pi / 180.0)
        cell1.emissionLongitude = 44.0 * (.pi / 180.0)
        cell1.emissionRange = 360.0 * (.pi / 180.0)
        cell1.spin = 65.0 * (.pi / 180.0)
        cell1.spinRange = 314.0 * (.pi / 180.0)
        cell1.scale = 0.013
        cell1.scaleRange = 0.002
        //cell1.scaleSpeed = -0.077
        cell1.alphaSpeed = 0.42
        cell1.color = UIColor(red: 255.0/255.0, green: 182.0/255.0, blue: 0.0/255.0, alpha: 0.39).cgColor
        cell1.redRange = 0.3
        cell1.greenRange = 0.21
        cell1.blueRange = 0.6

        sparkEmitterLayer.emitterCells = [cell1]
        
        view.layer.addSublayer(sparkEmitterLayer)
    }
    
}

