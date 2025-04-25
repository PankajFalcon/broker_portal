//
//  IBDesignable.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

@IBDesignable
public extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    /// Programmatically apply basic style
    func applyStyle(
        cornerRadius: CGFloat = 0,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        shadowColor: UIColor? = nil,
        shadowOpacity: Float = 0,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = 0
    ) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = shadowOffset
        self.shadowRadius = shadowRadius
    }
}

@IBDesignable
public extension UITextField {
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return leftView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var rightPadding: CGFloat {
        get {
            return rightView?.frame.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        get { return nil } // Not used for getting
        set {
            if let image = newValue {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                let containerWidth: CGFloat = 36 // image width + padding
                let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 24))
                imageView.frame = CGRect(x: 8, y: 0, width: 20, height: 24) // 8pt padding
                container.addSubview(imageView)
                
                leftView = container
                leftViewMode = .always
            } else {
                leftView = nil
            }
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        get { return nil }
        set {
            if let image = newValue {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                let containerWidth: CGFloat = 36
                let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: 24))
                imageView.frame = CGRect(x: 8, y: 0, width: 20, height: 24)
                container.addSubview(imageView)
                
                rightView = container
                rightViewMode = .always
            } else {
                rightView = nil
            }
        }
    }
    
    @IBInspectable var placeholderTextColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            guard let placeholder = placeholder, let color = newValue else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: color]
            )
        }
    }
}

@IBDesignable
public extension UITextView {
    
    // MARK: - Associated Keys
    private struct AssociatedKeys {
        static var placeholderLabel: UInt8 = 0
        static var placeholderText: UInt8 = 1
        static var placeholderColor: UInt8 = 2
    }
    
    // MARK: - Placeholder Label
    private var placeholderLabel: UILabel {
        if let label = objc_getAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderLabel)) as? UILabel {
            return label
        }
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = self.font
        label.textColor = placeholderColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        addSubview(label)
        
        objc_setAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderLabel), label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        updatePlaceholderConstraints()
        
        return label
    }
    
    // MARK: - Placeholder Text
    @IBInspectable var placeholder: String {
        get {
            return objc_getAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderText)) as? String ?? ""
        }
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderText), newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            placeholderLabel.text = newValue
            placeholderLabel.isHidden = !text.isEmpty
            
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    // MARK: - Placeholder Color
    @IBInspectable var placeholderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderColor)) as? UIColor ?? .lightGray
        }
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderColor), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            placeholderLabel.textColor = newValue
        }
    }
    
    // MARK: - Padding (textContainerInset)
    @IBInspectable var paddingTop: CGFloat {
        get { return textContainerInset.top }
        set {
            textContainerInset.top = newValue
            updatePlaceholderConstraints()
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat {
        get { return textContainerInset.left }
        set {
            textContainerInset.left = newValue
            updatePlaceholderConstraints()
        }
    }
    
    @IBInspectable var paddingBottom: CGFloat {
        get { return textContainerInset.bottom }
        set {
            textContainerInset.bottom = newValue
            updatePlaceholderConstraints()
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get { return textContainerInset.right }
        set {
            textContainerInset.right = newValue
            updatePlaceholderConstraints()
        }
    }
    
    // MARK: - Placeholder Visibility
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    // MARK: - Update Placeholder Constraints
    private func updatePlaceholderConstraints() {
        guard let label = objc_getAssociatedObject(self, UnsafeRawPointer(&AssociatedKeys.placeholderLabel)) as? UILabel else { return }
        
        label.removeFromSuperview()
        addSubview(label)
        
        NSLayoutConstraint.deactivate(label.constraints)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: textContainerInset.top),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding))
        ])
    }
}

//MARK: How to use
//stepBar.setTitles(["Applicant Info", "Coverages", "Operations", "Drivers", "Vehicles", "Eligibility Questions", "Upload", "Submit"])
//stepBar.setStep(2)
//stepBar.onStepSelected = { index in
//    print("Selected step:", index)
//}

//MARK: This Code For StepView
@IBDesignable
class ChevronStepView: UIView {
    private let label = UILabel()
    private let shapeLayer = CAShapeLayer()

    var index: Int = 0
    var tapHandler: ((Int) -> Void)?

    @IBInspectable var title: String = "" {
        didSet {
            label.text = title
            label.font = InterFontStyle.medium.with(size: 14)
            label.textColor = .AppWhiteColor
        }
    }

    var isCompleted: Bool = false {
        didSet { updateStyle() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)

        label.font = InterFontStyle.medium.with(size: 14)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(stepTapped))
        addGestureRecognizer(tap)

        updateStyle()
    }

    @objc private func stepTapped() {
        tapHandler?(index)
    }

    private func updateStyle() {
        shapeLayer.fillColor = isCompleted ? UIColor.AppYellowColor.cgColor : UIColor.AppLightGrey.cgColor
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = chevronPath(bounds: bounds).cgPath
    }

    private func chevronPath(bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let w = bounds.width + 10
        let h = bounds.height
        let cut: CGFloat = 12

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w - cut, y: 0))
        path.addLine(to: CGPoint(x: w, y: h / 2))
        path.addLine(to: CGPoint(x: w - cut, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.addLine(to: CGPoint(x: cut, y: h / 2))
        path.close()
        return path
    }
}

@IBDesignable
class ChevronProgressBar: UIView {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var stepViews: [ChevronStepView] = []

    @IBInspectable var stepHeight: CGFloat = 40 {
        didSet {
            heightConstraint?.constant = stepHeight
        }
    }

    var onStepSelected: ((Int) -> Void)?
    private var heightConstraint: NSLayoutConstraint?

    var steps: [String] = [] {
        didSet { setupSteps() }
    }

    var currentStepIndex: Int = 0 {
        didSet { updateProgress() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollStack()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollStack()
    }

    private func setupScrollStack() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = stackView.heightAnchor.constraint(equalToConstant: stepHeight)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            heightConstraint!
        ])
    }

    private func setupSteps() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stepViews.removeAll()

        for (i, title) in steps.enumerated() {
            let view = ChevronStepView()
            view.title = title
            view.index = i
            view.tapHandler = { [weak self] index in
                self?.setStep(index)
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            stepViews.append(view)
            stackView.addArrangedSubview(view)
        }

        updateProgress()
    }

    private func updateProgress() {
        for (index, step) in stepViews.enumerated() {
            step.isCompleted = index <= currentStepIndex
        }

        if currentStepIndex < stepViews.count {
            let stepView = stepViews[currentStepIndex]
            scrollView.scrollRectToVisible(stepView.frame.insetBy(dx: -8, dy: 0), animated: true)
        }
    }

    // MARK: - External Access

    func setStep(_ index: Int) {
        guard index >= 0 && index < stepViews.count else { return }
        currentStepIndex = index
        onStepSelected?(index)
    }

    func setTitles(_ titles: [String]) {
        self.steps = titles
    }
}
