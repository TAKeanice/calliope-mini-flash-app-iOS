//
//  MainContainerViewController.swift
//  Calliope
//
//  Created by Tassilo Karge on 02.06.19.
//

import UIKit
import SnapKit

class MainContainerViewController: UITabBarController, UITabBarControllerDelegate {

	@IBOutlet weak var matrixConnectionView: UIView!

	weak var connectionViewController: MatrixConnectionViewController!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		let window = (UIApplication.shared.delegate!.window!)!

		let connectionVC = UIStoryboard(name: "ConnectionView", bundle: nil).instantiateInitialViewController() as! MatrixConnectionViewController
		connectionVC.view.translatesAutoresizingMaskIntoConstraints = false

		window.addSubview(connectionVC.view)

		NSLayoutConstraint.activate([
			connectionVC.view.rightAnchor.constraint(equalTo: window.safeAreaLayoutGuide.rightAnchor, constant: -8.0),
			connectionVC.view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 8.0)
			])

		connectionViewController = connectionVC
	}
}