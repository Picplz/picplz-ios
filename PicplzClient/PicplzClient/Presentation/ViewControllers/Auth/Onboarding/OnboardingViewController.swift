//
//  OnboardingViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/9/25.
//

import UIKit
import Combine

final class OnboardingViewController: UIViewController {
    let contentView = OnboardingContentView()
    var viewModel: OnboardingViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = []

    private var datasource: UICollectionViewDiffableDataSource<Section, OnboardingPage>!
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    var pageChangedHandler: (Int?) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupStyle()
        setupLayout()
        contentView.pageControl.numberOfPages = viewModel.onboardingPages.count

        collectionViewHeightConstraint = contentView.collectionView.heightAnchor.constraint(equalToConstant: 600) // initial height
        collectionViewHeightConstraint.isActive = true
        updateCollectionViewHeight()

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func bind() {
        viewModel.currentPageIndexPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] page in
                self?.contentView.pageControl.currentPage = page
            }
            .store(in: &subscriptions)

        viewModel.showLoginButtonPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] showLoginButton in
                self?.contentView.loginButton.isHidden = !showLoginButton
            }
            .store(in: &subscriptions)

        viewModel.errorMessagePublisher
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showAlert(title: "오류가 발생했습니다.", message: errorMessage)
            }
            .store(in: &subscriptions)
    }

    private func setupCollectionView() {
        // MARK: CollectionView - init, setup layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        contentView.collectionView = collectionView

        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")

        // MARK: CollectionView - setup dataSource
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "OnboardingCollectionViewCell",
                for: indexPath
            ) as? OnboardingCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(page: item)

            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, OnboardingPage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.onboardingPages)
        datasource.apply(snapshot)

        // MARK: CollectionView Page Handler
        pageChangedHandler = { [weak self] index in
            guard let index = index else { return }
            self?.viewModel.currentPageChanged(pageIndex: index)
        }

        // MARK: Kakao Login Handler
        contentView.loginButton.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
    }

    private func setupStyle() {
        view.backgroundColor = .ppWhite

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.setupStyle()

        contentView.collectionView.isScrollEnabled = false // disable vertical scroll

        contentView.loginButton.isHidden = true
    }

    private func setupLayout() {
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.setupLayout()
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(600))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            self?.pageChangedHandler(visibleItems.last?.indexPath.item)
        }

        return UICollectionViewCompositionalLayout(section: section)
    }

    func updateCollectionViewHeight() {
        DispatchQueue.main.async { // 메인 쓰레드 동기 작업 종료 후 실행
            let maxHeight = self.contentView.collectionView.visibleCells
                        .map { $0.frame.maxY }
                        .max() ?? 0
            self.collectionViewHeightConstraint.constant = maxHeight
            self.view.layoutIfNeeded()
        }
    }

    @objc private func kakaoLoginTapped() {
        viewModel.kakaoLoginButtonTapped()
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }

    enum Section {
        case main
    }
}
