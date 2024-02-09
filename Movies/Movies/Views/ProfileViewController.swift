//
//  ProfileViewController.swift
//  Movies
//
//  Created by Olga Sabadina on 05.01.2024.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    private let userImage = UIImageView()
    private let userName = UITextField()
    private let deleteProfileButton = UIButton(type: .system)
    private let logOutProfileButton = UIButton(type: .system)
    private let editProfileButton = UIButton(type: .system)
    private var stackButtons = UIStackView()
    private let authManager = AuthorizedManager.shared
    private var isEditable: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setStackButtons()
        setUserName()
        setUserImage()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userImage.setBorderLayer(backgroundColor: .clear, borderColor: .gray, borderWidth: 2, cornerRadius: userImage.frame.height/2, tintColor: nil)
    }
    
    @objc private func alertWhenTapOnImage() {
        let alert = UIAlertController(title: "choose Image Menu", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Gallary", style: .default, handler: { _ in
            self.openGallery() }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
    
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = userImage
            alert.popoverPresentationController?.sourceRect = userImage.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - private Functions:
    
    private func setView() {
        view.gradientBackgroundHorizontal(leftColor: ColorConstans.leftColorSegment, rightColor: ColorConstans.rightColorSegment)
    }
    
    private func setProfileData() {
        userName.text = authManager.userProfile?.login
        userImage.image = .getPersonImage()
    }
    
    private func setUserName() {
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        userName.delegate = self
        userName.textAlignment = .center
    }
    
    private func setUserImage() {
        userImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImage)
        userImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alertWhenTapOnImage))
        userImage.addGestureRecognizer(tapGesture)
        userImage.clipsToBounds = true
    }
    
    private func setStackButtons() {
        let buttons = [editProfileButton, logOutProfileButton, deleteProfileButton]
        let titleArr = ["Edit profile", "Log Out", "Delete profile"]
       
        buttons.enumerated().forEach { index, button in
            button.setTitle(titleArr[index], for: .normal)
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.setBorderLayer(backgroundColor: .link, borderColor: ColorConstans.borderColorSegment, borderWidth: 2, cornerRadius: 20, tintColor: .white)
            button.titleLabel?.font = .boldSystemFont(ofSize: 18)
            
            let action = UIAction { _ in
                self.tapButton(EventProfile.allCases[index])
            }
            button.addAction(action, for: .touchUpInside)
        }
        
        editProfileButton.isEnabled = true
        stackButtons = UIStackView(arrangedSubviews: buttons)
        stackButtons.axis = .vertical
        stackButtons.spacing = 20
        stackButtons.distribution = .fillEqually
        stackButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackButtons)
    }
    
    private func tapButton(_ event: EventProfile) {
        switch event {
        case .editProfile:
            isEditable = true
            userName.becomeFirstResponder()
        case .logOut:
            authManager.logOut()
        case .deleteProfile:
            authManager.deleteUser { self.alertError($0) }
        }
    }
    
    //MARK: - constraints:
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 120),
            
            userName.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 15),
            userName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            userName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}

extension ProfileViewController {
    enum EventProfile: CaseIterable {
        case editProfile
        case logOut
        case deleteProfile
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerController.SourceType.camera
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Attention", message: "You haven't camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imgPicker.allowsEditing = true
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var userImage = UIImage()
        if let picImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage = picImage
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = originImage
        }
        self.userImage.image = userImage
        
        UserDefaults.standard.set(userImage.pngData(), forKey: TitleConstants.userImage)
        
        tabBarController?.tabBar.items?.last?.image = userImage.prepareImageToTabBar()
        
        dismiss(animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        guard var userProfile = authManager.userProfile else {return true}
        
        if textField.text != userProfile.login, let login = textField.text {
            userProfile.login = login
            authManager.userProfile?.login = login
            DatabaseService.shared.sendProfileToServer(uid: userProfile.uid, profile: userProfile) { self.alertError($0) }
        }
        isEditable = false
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditable
    }
}


