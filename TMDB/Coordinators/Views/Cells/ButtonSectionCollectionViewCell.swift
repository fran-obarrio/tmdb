
import UIKit
import SnapKit

protocol ButtonSectionDelegate: AnyObject {
    func didTapNowPlaying()
    func didTapUpcoming()
    func didTapTopRated()
}

class ButtonSectionCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ButtonSectionDelegate?
    
    private  let nowPlayingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Now playing", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let upcomingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upcoming", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Top rated", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 58/255, green: 63/255, blue: 71/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        selectButton(nowPlayingButton)  // Botón inicial seleccionado
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor(red: 36/255, green: 42/255, blue: 50/255, alpha: 1.0)
        
        contentView.addSubview(nowPlayingButton)
        contentView.addSubview(upcomingButton)
        contentView.addSubview(topRatedButton)
        contentView.addSubview(selectionIndicator)
        
        nowPlayingButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        nowPlayingButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.equalTo(contentView).offset(24)
        }
        
        upcomingButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
        }
        
        topRatedButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView.snp.centerX).multipliedBy(1.62)  // Mueve el botón al 1/3 de la derecha
        }
        
        selectionIndicator.snp.makeConstraints { make in
            make.top.equalTo(nowPlayingButton.snp.bottom).offset(3)
            make.height.equalTo(4)
            make.centerX.equalTo(nowPlayingButton.snp.centerX)
            make.width.equalTo(nowPlayingButton.titleLabel!.snp.width)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectButton(sender)
        
        if sender == nowPlayingButton {
            delegate?.didTapNowPlaying()
        } else if sender == upcomingButton {
            delegate?.didTapUpcoming()
        } else if sender == topRatedButton {
            delegate?.didTapTopRated()
        }
    }
    
    private func selectButton(_ button: UIButton) {
        selectedButton?.setTitleColor(.white, for: .normal)
        selectedButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold) 
        selectedButton = button
        
        UIView.animate(withDuration: 0.3) {
            self.selectionIndicator.snp.remakeConstraints { make in
                make.top.equalTo(button.snp.bottom).offset(4)
                make.height.equalTo(4)
                make.centerX.equalTo(button.snp.centerX)
                make.width.equalTo(button.titleLabel!.snp.width)
            }
            self.layoutIfNeeded()
        }
    }
}
