import Flutter
import Foundation

public class ParticipantViewFactory: NSObject, FlutterPlatformViewFactory {

  public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }

  public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    
    if let params = args as? Dictionary<String, Bool> {
      let isMyVideo = params["isLocal"] as? Bool ?? false
      if isMyVideo {
        return LocalParticipantView()
      }
    }

    return RemoteParticipantView()
  }
}