//
//  EditNoteView.swift
//  Noter
//
//  Created by jorjyb0i on 22.01.2021.
//

import UIKit

class EditNoteView: UIView {
    
    let pickerOptions = [
        "Diploma",
        "Entry",
        "Other"
    ]
    
//    let scale = UIScreen.main.scale
    
    let noteTypePicker = UIPickerView()
    
    let textFieldName = UITextField()
    
    let noteTypeTextField: UITextField = {
        let noteTypeView = DisabledPasteboardTextField()
        return noteTypeView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    let separator1 = UIView()
    let separator2 = UIView()
    
    func setupTextView() {

        addSubview(textFieldName)
        addSubview(separator1)
        addSubview(noteTypeTextField)
        addSubview(separator2)
        addSubview(textView)

        textFieldName.placeholder = "Enter Note Title"
        
        separator1.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        noteTypeTextField.text = pickerOptions[1]
        
        separator2.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        
        textView.text = "New Note"
        textView.font = textView.font?.withSize(17)
        
        
        noteTypeTextField.tintColor = .clear
        
        NSLayoutConstraint.activate([
            textFieldName.topAnchor.constraint(equalTo: topAnchor),
            textFieldName.leftAnchor.constraint(equalTo: leftAnchor),
            textFieldName.rightAnchor.constraint(equalTo: rightAnchor),
            textFieldName.bottomAnchor.constraint(equalTo: separator1.topAnchor),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),
            
            separator1.leftAnchor.constraint(equalTo: leftAnchor),
            separator1.rightAnchor.constraint(equalTo: rightAnchor),
            separator1.bottomAnchor.constraint(equalTo: noteTypeTextField.topAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1),

            noteTypeTextField.leftAnchor.constraint(equalTo: leftAnchor),
            noteTypeTextField.rightAnchor.constraint(equalTo: rightAnchor),
            noteTypeTextField.bottomAnchor.constraint(equalTo: separator2.topAnchor),
            noteTypeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            separator2.leftAnchor.constraint(equalTo: leftAnchor),
            separator2.rightAnchor.constraint(equalTo: rightAnchor),
            separator2.bottomAnchor.constraint(equalTo: textView.topAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        separator1.translatesAutoresizingMaskIntoConstraints = false
        noteTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        separator2.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        setupTextView()
        
        
        
        noteTypePicker.delegate = self
        noteTypePicker.dataSource = self
        noteTypeTextField.inputView = noteTypePicker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditNoteView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        noteTypeTextField.text = pickerOptions[row]
        noteTypeTextField.endEditing(true)
    }
}

extension EditNoteView: UITextFieldDelegate {

}


