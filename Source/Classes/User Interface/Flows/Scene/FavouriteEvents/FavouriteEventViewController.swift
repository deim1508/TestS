//
//  FavouriteEventsViewController.swift
//  events
//
//  Created by halcyon on 1/11/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit
import MapKit

class FavouriteEventViewController: BaseViewController {
    var viewModel: FavouriteEventViewModel! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    //Kolozsvar kozpontja
    let initialLocation = CLLocation(latitude: 46.771324, longitude: 23.598671)
    let regionRadius: CLLocationDistance = 3000
    private let mapView: MKMapView = MKMapView(frame: CGRect.zero)
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.layer.cornerRadius = Radius.small
        view.backgroundColor = Color.pampas
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let resetFavouriteButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle(Strings.reset, for: .normal)
        button.titleLabel?.font = Font.regular(size: .moreThanMedium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.viewControllerViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetFavouriteButton.setTitleColor(Theme.current.textColor, for: .normal)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.actualizeFavouriteInUserDefaults()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        resetFavouriteButton.addTarget(self, action: #selector(didTappResetFavourites), for: .touchUpInside)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: resetFavouriteButton), animated: true)
    }

    internal override func setupView() {
        view.backgroundColor = Color.pampas
        mapView.translatesAutoresizingMaskIntoConstraints = false
        centerMapOnLocation(location: initialLocation)
        view.addSubview(mapView)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: FavouriteCell.cellId)
        view.addSubview(collectionView)

        setupConstraints()
    }

    internal override func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            mapView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc private func didTappResetFavourites() {
        viewModel.resetFavourites()
    }
}

extension FavouriteEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.eventsCollectionCell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCell.cellId, for: indexPath) as? FavouriteCell else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.eventsCollectionCell[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 + Paddings.small, height: view.frame.width / 2 + Paddings.small)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Paddings.big, left: Paddings.big, bottom: Paddings.big, right: Paddings.big)
    }
}

extension FavouriteEventViewController: FavouriteEventViewDelegate {
    func shouldChangeLocationOnMap(name: String, latitude: Double, longitude: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = name
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius / 4, regionRadius / 4)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setResetButtonVisible(setHidden: Bool) {
        resetFavouriteButton.isHidden = setHidden
    }
    
    func shouldReloadData() {
        collectionView.reloadData()
    }
}

extension UICollectionView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
