import Flutter
import MobileRTC

public class RemoteParticipantView: NSObject, FlutterPlatformView {
  let remoteView: MobileRTCVideoView

  override init() {
    let videoView = MobileRTCActiveVideoView()
    videoView.setVideoAspect(MobileRTCVideoAspect_Original)

    self.remoteView = videoView

    super.init()
    self.delay()
  }

  public func view() -> UIView {
    return remoteView
  }

  public func delay() {
    let delayTime = DispatchTime.now() + 1.0
    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
      if let activeUserId = MobileRTC.shared().getMeetingService()?.activeUserID() {
        self.remoteView.stopAttendeeVideo()
        self.remoteView.showAttendeeVideo(withUserID: activeUserId)
      }
    })
  }
}