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
        maxYOffset: CGFloat,
        minYOffset: CGFloat,
        backgroundColor: UIColor?
    ) {
        self.contentView = contentView
        self.cornerRadius = cornerRadius
        self.handleSize = handleSize
        self.getRatioByMode = getRatioByMode
        self.currentMode = currentMode
        self.maxYOffset = maxYOffset
        self.minYOffset = minYOffset
        self.contentViewWrapperViewBackgroundColor = backgroundColor
        
        super.init(frame: frame)
        setup()
    }
    
    convenience init(contentView: UIView, prefereces: Preferences) {
        self.init(
            frame: .zero,
            contentView: contentView,
            cornerRadius: prefereces.cornerRadius,
            handleSize: prefereces.handleSize,
            getRatioByMode: prefereces.getRatioByMode,
            maxYOffset: prefereces.maxYOffset,
            minYOffset: prefereces.minYOffset,
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
    var maxYOffset: CGFloat
    var minYOffset: CGFloat
    
    private var contentWrapperViewTopConstraint: NSLayoutConstraint?
    
    private func setup() {
        handleView = UIView()
        
        // MARK: Style
        contentViewWrapperView.layer.cornerRadius = cornerRadius
        contentViewWrapperView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
        
//        print("nextOffset \(yOffset + recognizer.translation(in: self).y)")
//        print("maxOffset \(maxYOffset)")
//        print("minOffset \(minYOffset)")
        if yOffset + recognizer.translation(in: self).y < maxYOffset {
            yOffset = maxYOffset
        } else if yOffset + recognizer.translation(in: self).y > minYOffset {
            yOffset = minYOffset
        } else {
            yOffset += recognizer.translation(in: self).y
        }
        self.contentWrapperViewTopConstraint?.constant = yOffset
        
        let velocity = recognizer.velocity(in: self)
        let isDraggingDown: Bool = velocity.y > 0
        
        // MARK: 패닝이 멈추면 인접한 모드로 고정
        if recognizer.state == .ended {
            if yOffset <= minYOffset && yOffset > getHeight(by: .defaultMode) {
                if isDraggingDown {
                    currentMode = .minimum
                } else {
                    currentMode = .defaultMode
                }
            } else if yOffset <= getHeight(by: .defaultMode) && yOffset > getHeight(by: .medium) {
                if isDraggingDown {
                    currentMode = .defaultMode
                } else {
                    currentMode = .medium
                }
            } else if yOffset <= getHeight(by: .medium) && yOffset > getHeight(by: .large) {
                if isDraggingDown {
                    currentMode = .medium
                } else {
                    currentMode = .large
                }
            } else if yOffset <= getHeight(by: .large) {
                currentMode = .large
            }
        }
        
        recognizer.setTranslation(.zero, in: self) // Recognizer 초기화
    }
    
    private func getHeight(by mode: Mode) -> CGFloat {
        let ratio = 1.0 - getRatioByMode(mode)
        return UIScreen.main.bounds.height * ratio
    }
    
    private func updateYOffset(by mode: Mode) {
        let yOffset = mode == .minimum ? minYOffset : getHeight(by: mode)
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
        static func getBasicPreferences(maxYOffset: CGFloat, minYOffset: CGFloat) -> Preferences {
            return .init(
                maxYOffset: maxYOffset,
                minYOffset: minYOffset,
                backgroundColor: .picplzWhite,
                cornerRadius: 20,
                handleSize: .init(width: 50, height: 4)
            ) { mode in
                switch mode {
                case .defaultMode:
                    return 0.22
                case .medium:
                    return 0.5
                case .large:
                    return 0.8
                default:
                    return 0.0
                }
            }
        }
        
        var maxYOffset: CGFloat // ex> 바텀시트 최대 y 오프셋 (최대 확장)
        var minYOffset: CGFloat // ex> 바텀시트 최소 y 오프셋 (최소 확장)
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
