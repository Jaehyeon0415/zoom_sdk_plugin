import Flutter
import UIKit
import MobileRTC

public class LocalParticipantView: NSObject, FlutterPlatformView {
  static var localView = MobileRTCVideoView()

  override init() {
    // MobileRTCVideoAspect_Original, MobileRTCVideoAspect_PanAndScan
    LocalParticipantView.localView.setVideoAspect(MobileRTCVideoAspect_Original)

    super.init()
    self.delay()
  }

  public func view() -> UIView {
    return LocalParticipantView.localView
  }

  public func delay() {
    let delayTime = DispatchTime.now() + 1.0
    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
      if let localUserID = MobileRTC.shared().getMeetingService()?.myselfUserID() {
        LocalParticipantView.localView.showAttendeeVideo(withUserID: localUserID)
        LocalParticipantView.localView.setVideoAspect(MobileRTCVideoAspect_Original)
      }
    })
  }

  static func stopCamera() {
    print("STOP CAMERA")
    LocalParticipantView.localView.stopAttendeeVideo()
  }

  static func startCamera() {
    let rtcService = MobileRTC.shared().getMeetingService()
    if let localUserID = rtcService?.myselfUserID() {
      print("START CAMERA")
      LocalParticipantView.localView.showAttendeeVideo(withUserID: localUserID)
      LocalParticipantView.localView.setVideoAspect(MobileRTCVideoAspect_Original)
    }
  }
}