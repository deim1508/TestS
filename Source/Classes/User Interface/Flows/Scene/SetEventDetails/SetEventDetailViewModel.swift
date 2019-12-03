//
//  SetEventDetailViewModel.swift
//  events
//
//  Created by halcyon on 1/9/19.
//  Copyright © 2019 halcyon. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

enum EventType {
    case conference
    case privateEvent
    case party
    case none

    var name: String {
        switch self {
        case .conference:
            return "Conference"
        case .privateEvent:
            return "Private"
        case .party:
            return "Party"
        case .none:
            return "None"
        }
    }
}

protocol SetEventDetailViewModel {
    var viewDelegate: SetEventDetailViewDelegate? { get set }
    var eventTypes: [EventType] { get }
    var selectedEventTypeIndex: Int { get }
    func didSelectEventType(at index: Int)
    func didFinishSettings(on viewController: SetEventDetailViewController, name: String, addmission: String, description: String)
    func uploadImage(image: UIImage)
}

protocol SetEventDetailViewDelegate: class {
    func shouldReloadData()
    func addImageDecorator(image: UIImage)
}

protocol SetEventDetailViewModelFlowDelegate: class {
    func showMissingDataAlert(on viewController: SetEventDetailViewController)
    func didFinish(_ viewController: SetEventDetailViewController)
}

class SetEventDetailViewModelImpl: SetEventDetailViewModel {
    weak var flowDelegate: SetEventDetailViewModelFlowDelegate?
    weak var viewDelegate: SetEventDetailViewDelegate?
    var eventTypes: [EventType] = [EventType.conference, EventType.privateEvent, EventType.party]
    var eventTypesImage: [UIImage] = [#imageLiteral(resourceName: "icon_conference"), #imageLiteral(resourceName: "icon_private"), #imageLiteral(resourceName: "icon_party")]
    var selectedEventTypeIndex: Int = -1
    var imageUrl: String? = ""
    let event: Event

    init(event: Event) {
        self.event = event
    }

    func didSelectEventType(at index: Int) {
        selectedEventTypeIndex = index
        viewDelegate?.shouldReloadData()
    }

    func uploadImage(image: UIImage) {
        let storageRef = Storage.storage().reference().child("images/\(randomString(length: 20))")
        guard let imageData: Data = UIImagePNGRepresentation(image) else { return }
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else { return }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                self.imageUrl = downloadURL.absoluteString
            }
        }
    }

    func didFinishSettings(on viewController: SetEventDetailViewController, name: String, addmission: String, description: String) {
        if name.isEmpty || addmission.isEmpty {
            flowDelegate?.showMissingDataAlert(on: viewController)
        } else {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let event = Event(location: self.event.location, date: self.event.date, name: name, addmission: addmission, description: description, eventType: eventTypes[selectedEventTypeIndex].name, imageUrl: imageUrl, addedByUser: userId)
            let databaseRef = Database.database().reference()
            databaseRef.child("events").childByAutoId().setValue(event.toAnyObject())
            flowDelegate?.didFinish(viewController)
        }
    }

    private func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}
