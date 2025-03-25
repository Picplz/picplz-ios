//
//  BottomSheetView.swift
//  PicplzClient
//
//  Created by 임영택 on 3/24/25.
//

import UIKit

class BottomSheetView: PassThroughView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        frame: CGRect,
        contentView: UIView,
        cornerRadius: CGFloat,
        handleSize: CGSize,
        getRatioByMode: @escaping (Mode) -> CGFloat,
        currentMode: Mode = .defaultMode,
        maxYOffsetRatio: CGFloat,
        minYOffsetRatio: CGFloat,
        backgroundColor: UIColor?
    ) {
        self.contentView = contentView
        self.cornerRadius = cornerRadius
        self.handleSize = handleSize
        self.getRatioByMode = getRatioByMode
        self.currentMode = currentMode
        self.maxYOffsetRatio = maxYOffsetRatio
        self.minYOffsetRatio = minYOffsetRatio
        self.contentViewWrapperViewBackgroundColor = backgroundColor
        
        super.init(frame: frame)
        setup()
    }
    
    convenience init(contentView: UIView, prefereces: Preferences = .basic) {
        self.init(
            frame: .zero,
            contentView: contentView,
            cornerRadius: prefereces.cornerRadius,
            handleSize: prefereces.handleSize,
            getRatioByMode: prefereces.getRatioByMode,
            maxYOffsetRatio: prefereces.maxYOffsetRatio,
            minYOffsetRatio: prefereces.minYOffsetRatio,
            backgroundColor: prefereces.backgroundColor
        )
    }
    
    private let contentViewWrapperView: UIView = UIView()
    private let contentViewWrapperViewBackgroundColor: UIColor?
    private let contentView: UIView
    private let barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .picplzBlack
        barView.layer.cornerRadius = 4.0
        return barView
    }()
    private var handleView: UIView!
    
    private let cornerRadius: CGFloat
    private let handleSize: CGSize
    private let getRatioByMode: (Mode) -> CGFloat
    private var currentMode: Mode {
        didSet {
            updateYOffset(by: currentMode)
        }
    }
    private var heightByMode: CGFloat {
        let ratio = 1.0 - getRatioByMode(currentMode)
        return UIScreen.main.bounds.height * ratio
    }
    private let maxYOffsetRatio: CGFloat
    private var maxYOffset: CGFloat {
        UIScreen.main.bounds.height * (1.0 - maxYOffsetRatio)
    }
    private let minYOffsetRatio: CGFloat
    private var minYOffset: CGFloat {
        UIScreen.main.bounds.height * (1.0 - minYOffsetRatio)
    }
    
    private var contentWrapperViewTopConstraint: NSLayoutConstraint?
    
    private func setup() {
        handleView = UIView()
        
        // MARK: Style
        contentViewWrapperView.layer.cornerRadius = cornerRadius
        contentViewWrapperView.clipsToBounds = true
        contentViewWrapperView.layer.borderColor = UIColor.grey2.cgColor
        contentViewWrapperView.layer.borderWidth = 1
        contentViewWrapperView.backgroundColor = contentViewWrapperViewBackgroundColor
        
        // MARK: Layout
        translatesAutoresizingMaskIntoConstraints = false
        contentViewWrapperView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        handleView.translatesAutoresizingMaskIntoConstraints = false
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Layout - ContentView
        addSubview(contentViewWrapperView)
        
        NSLayoutConstraint.activate([
            contentViewWrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentViewWrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentViewWrapperView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        contentWrapperViewTopConstraint = contentViewWrapperView.topAnchor.constraint(equalTo: topAnchor, constant: heightByMode)
        contentWrapperViewTopConstraint?.isActive = true
        
        contentViewWrapperView.addSubview(handleView)
        contentViewWrapperView.addSubview(contentView)
        handleView.addSubview(barView)
        
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: contentViewWrapperView.topAnchor, constant: 4),
            handleView.centerXAnchor.constraint(equalTo: contentViewWrapperView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: handleSize.width),
        ])
        let handleViewHeightConstraint = handleView.heightAnchor.constraint(equalToConstant: max(handleSize.height, 16))
        handleViewHeightConstraint.priority = .defaultLow
        handleViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            barView.centerYAnchor.constraint(equalTo: handleView.centerYAnchor),
            barView.centerXAnchor.constraint(equalTo: handleView.centerXAnchor),
            barView.widthAnchor.constraint(equalToConstant: handleSize.width),
            barView.heightAnchor.constraint(equalToConstant: handleSize.height),
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: contentViewWrapperView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentViewWrapperView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentViewWrapperView.bottomAnchor),
        ])
        
        // MARK: Pan Gesture
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        handleView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        var yOffset = contentWrapperViewTopConstraint?.constant ?? 0.0
        
        if yOffset + recognizer.translation(in: self).y < maxYOffset {
            yOffset = maxYOffset
        } else if yOffset + recognizer.translation(in: self).y > minYOffset {
            yOffset = minYOffset
        } else {
            yOffset += recognizer.translation(in: self).y
        }
        
        let velocity = recognizer.velocity(in: self)
        let isDraggingDown: Bool = velocity.y > 0
        
        guard recognizer.state == .ended else {
//            contentWrapperViewTopConstraint?.constant = yOffset
//            self.layoutIfNeeded()
            return
        }
        
        // MARK:
        if yOffset <= getHeight(by: .minimum) && yOffset > getHeight(by: .defaultMode) {
            if isDraggingDown {
                updateYOffset(by: .minimum)
            } else {
                updateYOffset(by: .defaultMode)
            }
        } else if yOffset <= getHeight(by: .defaultMode) && yOffset > getHeight(by: .medium) {
            if isDraggingDown {
                updateYOffset(by: .defaultMode)
            } else {
                updateYOffset(by: .medium)
            }
        } else if yOffset <= getHeight(by: .medium) && yOffset > getHeight(by: .large) {
            if isDraggingDown {
                updateYOffset(by: .medium)
            } else {
                updateYOffset(by: .large)
            }
        }
        
        recognizer.setTranslation(.zero, in: self)
    }
    
    private func getHeight(by mode: Mode) -> CGFloat {
        let ratio = 1.0 - getRatioByMode(mode)
        return UIScreen.main.bounds.height * ratio
    }
    
    private func updateYOffset(by mode: Mode) {
        let yOffset = getHeight(by: mode)
        UIView.animate(withDuration: 0.5) {
            self.contentWrapperViewTopConstraint?.constant = yOffset
            self.layoutIfNeeded()
        }
        
        if mode == .minimum {
            contentView.removeFromSuperview()
        } else {
            let added = contentViewWrapperView.subviews.contains { view in
                view === contentView
            }
            
            if !added {
                contentViewWrapperView.addSubview(contentView)
                NSLayoutConstraint.activate([
                    contentView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 8),
                    contentView.leadingAnchor.constraint(equalTo: contentViewWrapperView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: contentViewWrapperView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: contentViewWrapperView.bottomAnchor),
                ])
            }
        }
    }
    
    enum Mode {
        case minimum
        case defaultMode
        case medium
        case large
    }
    
    struct Preferences {
        static var basic: Preferences {
            return .init(maxYOffsetRatio: 0.8, minYOffsetRatio: 0.13, backgroundColor: .picplzWhite, cornerRadius: 8, handleSize: .init(width: 50, height: 4)) { mode in
                switch mode {
                case .minimum:
                    return 0.12
                case .defaultMode:
                    return 0.3
                case .medium:
                    return 0.5
                case .large:
                    return 0.8
                }
            }
        }
        
        var maxYOffsetRatio: CGFloat // ex> 0.9이면 최상단으로부터 0.9 비율까지 바텀시트를 확장할 수 있음
        var minYOffsetRatio: CGFloat // ex> 0.1이면 최상단으로부터 0.1 비율까지 바텀시트를 축소할 수 있음
        var backgroundColor: UIColor
        var cornerRadius: CGFloat
        var handleSize: CGSize
        var getRatioByMode: (Mode) -> CGFloat
    }
}

class PassThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            return nil // 자신이 탭된 경우 nil을 반환해 리스폰더를 넘긴다
        }
        return hitView
    }
}
