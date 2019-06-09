//
//  ProgramCollectionViewCell.swift
//  Calliope
//
//  Created by Tassilo Karge on 08.06.19.
//

import UIKit

protocol ProgramCellDelegate {
	func share(cell: ProgramCollectionViewCell)
	func renameFailed(_ cell: ProgramCollectionViewCell, to newName: String)
	func programCellSizeDidChange(_ cell: ProgramCollectionViewCell)
	func uploadProgram(of cell: ProgramCollectionViewCell)
}

class ProgramCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var descriptionText: UITextView! {
		didSet {
			descriptionText.delegate = self
		}
	}
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var nameEditField: UITextField!
	@IBOutlet weak var buttonContainer: UIView!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var shareButton: UIButton!

	var observations: [NSKeyValueObservation] = []

	lazy var widthConstraint: NSLayoutConstraint = {
		let c = NSLayoutConstraint(item: self.contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300)
		c.priority = UILayoutPriority(rawValue: 999)
		self.addConstraint(c)
		return c
	}()

	public var program: HexFile! {
		didSet {
			name.text = program.name
			nameEditField.text = program.name
			descriptionText.text = program.descriptionText
		}
	}

	public var delegate: ProgramCellDelegate!

	public var editing = false {
		didSet {
			//changed from editing to not editing
			if oldValue && !editing {
				let newDescription = (descriptionText.text != nil && descriptionText.text != "") ? descriptionText.text! : program.dateString
				let newName = nameEditField.text ?? ""
				setProgramName(newName)
				setProgramDescription(newDescription)
			}

			if (!editing) {
				editButton.setTitle("Edit", for: .normal)
				descriptionText.backgroundColor = nil
			} else {
				editButton.setTitle("Finished", for: .normal)
				descriptionText.backgroundColor = UIColor.white
			}
			descriptionText.isEditable = editing
			name.isHidden = editing
			shareButton.isHidden = editing
			nameEditField.isHidden = !editing
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		contentView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			contentView.leftAnchor.constraint(equalTo: leftAnchor),
			contentView.rightAnchor.constraint(equalTo: rightAnchor),
			contentView.topAnchor.constraint(equalTo: topAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
			])
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		descriptionText.textContainerInset = UIEdgeInsets.zero
		self.changeTextExclusion()
	}

	private func setProgramName(_ newName: String) {
		program.name = newName
		if program.name != newName {
			//rename was not successful
			delegate.renameFailed(self, to: newName)
		}
		name.text = program.name
		nameEditField.text = program.name
	}

	private func setProgramDescription(_ newDescription: String) {
		program.descriptionText = newDescription
		descriptionText.text = program.descriptionText
	}

	func changeTextExclusion() {
		descriptionText.textContainer.exclusionPaths = [
			UIBezierPath(rect: self.convert(image.frame.intersection(descriptionText.frame), to: descriptionText)),
			UIBezierPath(rect: self.convert(buttonContainer.frame.intersection(descriptionText.frame), to: descriptionText))]
	}

	@IBAction func editButtonClicked(_ sender: Any) {
		editing = !editing
	}

	@IBAction func shareButtonClicked(_ sender: Any) {
		self.delegate.share(cell: self)
	}

	@IBAction func uploadButtonClicked(_ sender: Any) {
		delegate.uploadProgram(of: self)
	}

	// MARK: UITextViewDelegate

	func textViewDidChange(_ textView: UITextView) {
		delegate.programCellSizeDidChange(self)
	}

}