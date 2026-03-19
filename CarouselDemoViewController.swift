import UIKit
import SnapKit

class CarouselDemoViewController: UIViewController {
    
    private lazy var carouselView: CarouselView = {
        let carousel = CarouselView()
        carousel.isAutoScrollEnabled = true
        carousel.autoScrollInterval = 3.0
        carousel.delegate = self
        return carousel
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("停止自动滚动", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(toggleAutoScroll), for: .touchUpInside)
        return button
    }()
    
    private let colors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemGreen,
        .systemOrange,
        .systemPurple
    ]
    
    private let titles = ["第一页", "第二页", "第三页", "第四页", "第五页"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureCarousel()
    }
    
    private func setupUI() {
        title = "轮播图Demo"
        view.backgroundColor = .white
        
        view.addSubview(carouselView)
        view.addSubview(toggleButton)
        
        carouselView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        toggleButton.snp.makeConstraints {
            $0.top.equalTo(carouselView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureCarousel() {
        carouselView.configure(itemCount: colors.count) { [weak self] index in
            guard let self = self else { return UIView() }
            
            let container = UIView()
            container.backgroundColor = self.colors[index]
            container.layer.cornerRadius = 12
            container.clipsToBounds = true
            
            let label = UILabel()
            label.text = self.titles[index]
            label.textColor = .white
            label.font = .systemFont(ofSize: 24, weight: .bold)
            label.textAlignment = .center
            
            container.addSubview(label)
            label.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            return container
        }
    }
    
    @objc private func toggleAutoScroll() {
        carouselView.isAutoScrollEnabled.toggle()
        let title = carouselView.isAutoScrollEnabled ? "停止自动滚动" : "开始自动滚动"
        toggleButton.setTitle(title, for: .normal)
    }
}

extension CarouselDemoViewController: CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int) {
        let alert = UIAlertController(title: "点击事件", message: "你点击了\(titles[index])", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    func carouselView(_ carouselView: CarouselView, didScrollTo index: Int) {
        print("当前页: \(index)")
    }
}