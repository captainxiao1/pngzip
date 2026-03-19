import UIKit
import SnapKit

protocol CarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Int)
    func carouselView(_ carouselView: CarouselView, didScrollTo index: Int)
}

final class CarouselView: UIView {
    
    weak var delegate: CarouselViewDelegate?
    
    private var itemCount: Int = 0
    private var timer: Timer?
    private var currentIndex: Int = 0
    private var viewForItem: ((Int) -> UIView)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CarouselContainerCell.self, forCellWithReuseIdentifier: CarouselContainerCell.identifier)
        return cv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        pc.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pc
    }()
    
    var autoScrollInterval: TimeInterval = 3.0 {
        didSet { startTimer() }
    }
    
    var isAutoScrollEnabled: Bool = true {
        didSet { isAutoScrollEnabled ? startTimer() : stopTimer() }
    }
    
    var itemSize: CGSize = .zero {
        didSet {
            guard itemSize != .zero else { return }
            guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.itemSize = itemSize
            layout.invalidateLayout()
        }
    }
    
    var pageControlHidden: Bool = false {
        didSet { pageControl.isHidden = pageControlHidden }
    }
    
    var currentPageIndicatorTintColor: UIColor = .white {
        didSet { pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor }
    }
    
    var pageIndicatorTintColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet { pageControl.pageIndicatorTintColor = pageIndicatorTintColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    deinit { stopTimer() }
    
    private func setupUI() {
        backgroundColor = .clear
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func configure(itemCount: Int, viewForItem: @escaping (Int) -> UIView) {
        self.itemCount = itemCount
        self.viewForItem = viewForItem
        pageControl.numberOfPages = itemCount
        pageControl.currentPage = 0
        currentIndex = 0
        
        collectionView.reloadData()
        
        guard itemCount > 1 else {
            stopTimer()
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.scrollToIndex(0, animated: false)
        }
        startTimer()
    }
    
    private func startTimer() {
        stopTimer()
        guard isAutoScrollEnabled, itemCount > 1 else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { [weak self] _ in
            self?.scrollToNext()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func scrollToNext() {
        guard itemCount > 1, currentIndex >= 0, currentIndex < itemCount else { return }
        let nextIndex = (currentIndex + 1) % itemCount
        scrollToIndex(nextIndex, animated: true)
    }
    
    private func scrollToIndex(_ index: Int, animated: Bool) {
        guard index >= 0, index < itemCount else { return }
        currentIndex = index
        pageControl.currentPage = index
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    @objc private func pageControlValueChanged() {
        scrollToIndex(pageControl.currentPage, animated: true)
        startTimer()
    }
    
    func scrollToItem(at index: Int, animated: Bool) {
        scrollToIndex(index, animated: animated)
    }
}

extension CarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselContainerCell.identifier, for: indexPath) as? CarouselContainerCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewForItem?(indexPath.item))
        return cell
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize != .zero ? itemSize : collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView(self, didSelectItemAt: indexPath.item)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentIndex()
            startTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentIndex()
        startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentIndex()
    }
    
    private func updateCurrentIndex() {
        let pageWidth = collectionView.bounds.width
        guard pageWidth > 0 else { return }
        let currentPage = Int(collectionView.contentOffset.x / pageWidth)
        currentIndex = currentPage
        pageControl.currentPage = currentPage
        delegate?.carouselView(self, didScrollTo: currentPage)
    }
}

final class CarouselContainerCell: UICollectionViewCell {
    static let identifier = "CarouselContainerCell"
    
    private var customView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with view: UIView?) {
        if customView === view { return }
        customView?.removeFromSuperview()
        customView = view
        guard let view = view else { return }
        contentView.addSubview(view)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customView?.removeFromSuperview()
        customView = nil
    }
}
