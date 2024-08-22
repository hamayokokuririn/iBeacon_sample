//
//  ViewController.swift
//  iBeacon_test
//
//  Created by kengo.saito on 2024/08/22.
//

import UIKit
import CoreLocation

let macUUID = "8AEE1303-DCE9-9120-7381-2503450D3733"

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var textView: UITextView!

    var locationManager: CLLocationManager!
    let beaconUUID = UUID(uuidString: "41462998-6CEB-4511-9D46-1F7E27AA6572")!
    let beaconMajor: CLBeaconMajorValue = 18
    let beaconMinor: CLBeaconMinorValue = 5

    let sample = UUID(uuidString: macUUID)!
    let sampleMajor: CLBeaconMajorValue = 1234
    let sampleMinor: CLBeaconMinorValue = 5678

    let beaconIdentifier = "TargetBeacon"

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLog(beaconUUID.uuidString)

        // CLLocationManagerの初期化
        locationManager = CLLocationManager()
        locationManager.delegate = self

        // 位置情報の利用許可を要求
        locationManager.requestAlwaysAuthorization()

        // iBeaconのモニタリングを開始
        startMonitoringBeacon()
    }

    func startMonitoringBeacon() {
        updateLog("startMonitoringBeacon")

        let const = CLBeaconIdentityConstraint(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor)
        locationManager.startRangingBeacons(satisfying: const)
    }

    // iBeaconが検出された時の処理
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            let proximity = beacon.proximity
            let distance = beacon.accuracy // メートル単位での距離
            let distanceStr = String(format: "%.2f", distance)
            switch proximity {
            case .immediate:
                updateLog("\(distanceStr) meters away.")
            case .near:
                updateLog("\(distanceStr) meters away.")
            case .far:
                updateLog("\(distanceStr) meters away.")
            default:
                updateLog("Beacon is out of range.")
            }

        } else {
            updateLog("No beacons found.")
        }
    }

    // モニタリングに失敗した場合の処理
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        updateLog("Failed monitoring region: \(error.localizedDescription)")
    }

    // 権限が変更された時の処理
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startMonitoringBeacon()
        } else {
            updateLog("Location access not authorized.")
        }
    }

    func updateLog(_ text: String) {
        print(text)
        textView.isScrollEnabled = false
        let labelText = textView.text
        textView.text = labelText! + "\n" + text

        scrollToBottom()
    }

    func scrollToBottom() {
        textView.selectedRange = NSRange(location: textView.text.count, length: 0)
        textView.isScrollEnabled = true

        let scrollY = textView.contentSize.height - textView.bounds.height
        let scrollPoint = CGPoint(x: 0, y: scrollY > 0 ? scrollY : 0)
        textView.setContentOffset(scrollPoint, animated: true)
    }

}

