import Flutter
import UIKit
import MobileRTC

public class SwiftZoomSdkPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, MobileRTCAuthDelegate {
  var eventSink: FlutterEventSink?

  var result: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "zoom_sdk_plugin", binaryMessenger: registrar.messenger())
    let roomChannel = FlutterEventChannel(name: "zoom_sdk_plugin/room", binaryMessenger: register.messenger())
    let factory = ParticipantViewFactory()
    registrar.register(factory, withId: "zoom_sdk_plugin/views")

    let instance = SwiftZoomSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    roomChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result
    switch call.method {
    case "init":
      self.initZoom(call: call, result: result)
      break
    
    case "join":
      self.joinZoom(call: call, result: result)
      break;

    case "leave":
      self.leaveZoom(call: call, result: result)
      break
    
    case "switch_camera":
      self.switchCamera(call: call, result: result)
      break;

    case "toggle_camera":
      self.toggleCamera(call: call, result: result)
      break

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func initZoom(call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("Init Zoom")
    let pluginBundle = Bundle(for: type(of: self))
    let pluginBundlePath = pluginBundle.bundlePath
    let args = call.arguments as! Dictionary<String, String>

    let context = MobileRTCSDKInitContext()
    context.domain = "zoom.us"
    context.enableLog = true
    context.bundleResPath = pluginBundlePath
    MobileRTC.shared().initialize(context)

    let auth = MobileRTC.shared().getAuthService()
    print(MobileRTC.shared().mobileRTCVersion())
    auth?.delegate = self
    auth?.clientKey = args["zoomKey"]
    auth?.clientSecret = args["zoomSecret"]
    auth?.sdkAuth()
  }

  public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
    print("onMobileRTCAuthReturn \(returnValue)")
    if (returnValue == .success) {
      self.result?(true)
    } else {
      print("Zoom SDK Authentication failed: \(returnValue)")
      self.result?(false)
    }
  }

  public func joinZoom(call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("Join Meeting")
    let meetingService = MobileRTC.shared().getMeetingService()
    let meetingSettings = MobileRTC.shared().getMeetingSettings()

    if meetingService != nil {
      let args = call.arguments as! Dictionary<String, String>

      //================== set meeting setting ==================//
      meetingSettings?.enableCustomMeeting = true
      meetingSettings?.setMuteVideoWhenJoinMeeting(false)
      meetingSettings?.setAutoConnectInternetAudio(true)
      meetingSettings?.setMuteAudioWhenJoinMeeting(true)
      

      let joinMeetingParameters = MobileRTCMeetingJoinParam()
      joinMeetingParameters.userName = args["userName"]
      joinMeetingParameters.meetingNumber = args["meetingID"]
      joinMeetingParameters.password = args["meetingPW"]


      //================== set meeting service ==================//
      meetingService?.delegate = self
      // meetingService?.customizeMeetingTitle("")
      meetingService?.customizedUImeetingDelegate = self

      let response = meetingService?.joinMeeting(with: joinMeetingParameters)
    }
  }

  public func leaveZoom(call: FlutterMethodCall, result: FlutterResult) {
    print("Leave zoom")
    let meetingService = MobileRTC.shared().getMeetingService()
    meetingService?.leaveMeeting(with: LeaveMeetingCmd.leave)
    result(true)
  }

  public func switchCamera(call: FlutterMethodCall, result: FlutterResult) {
    print("Switch camera")
    guard let rtcService = MobileRTC.shared().getMeetingService() else { return }
    rtcService.switchMyCamera()
    result(true)
  }

  public func toggleCamera(call: FlutterMethodCall, result: FlutterResult) {
    print("Toggle camera")
    guard let rtcService = MobileRTC.shared().getMeetingService() else { return }
    if rtcService.isSendingMyVideo() ?? false {
      rtcService.muteMyVideo(true)
      LocalParticipantView.stopCamera()
      result(true)
    } else {
      rtcService.muteMyVideo(false)
      LocalParticipantView.startCamera()
      result(false)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("Zoom StreamHandler.onListen => EventChannel attached")
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("Zoom StreamHandler.onCancel => EventChannel detached")
    self.eventSink = nil
    return nil
  }

  public func meetingStatus(call: FlutterMethodCall, result: FlutterResult) {
    let meetingService = MobileRTC.shared().getMeetingService()
    if meetingService != nil {
      let meetingState = meetingService?.getMeetingState()
      result(getStateMessage(meetingState))
    } else {
      result(["MEETING_STATUS_UNKNOWN", ""])
    }
  }

  private func getStateMessage(_ state: MobileRTCMeetingState?) -> [String] {
    var message: [String]
    switch state {
    case  .idle:
        message = ["MEETING_STATUS_IDLE", "No meeting is running"]
        break
    case .connecting:
        message = ["MEETING_STATUS_CONNECTING", "Connect to the meeting server"]
        break
    case .inMeeting:
        message = ["MEETING_STATUS_INMEETING", "Meeting is ready and in process"]
        break
    case .webinarPromote:
        message = ["MEETING_STATUS_WEBINAR_PROMOTE", "Upgrade the attendees to panelist in webinar"]
        break
    case .webinarDePromote:
        message = ["MEETING_STATUS_WEBINAR_DEPROMOTE", "Demote the attendees from the panelist"]
        break
    case .disconnecting:
        message = ["MEETING_STATUS_DISCONNECTING", "Disconnect the meeting server, leave meeting status"]
        break;
    case .ended:
        message = ["MEETING_STATUS_ENDED", "Meeting ends"]
        MobileRTC.shared().getAuthService()?.logoutRTC()
        break;
    case .failed:
        message = ["MEETING_STATUS_FAILED", "Failed to connect the meeting server"]
        break;
    case .reconnecting:
        message = ["MEETING_STATUS_RECONNECTING", "Reconnecting meeting server status"]
        break;
    case .waitingForHost:
        message = ["MEETING_STATUS_WAITINGFORHOST", "Waiting for the host to start the meeting"]
        break;
    case .inWaitingRoom:
        message = ["MEETING_STATUS_IN_WAITING_ROOM", "Participants who join the meeting before the start are in the waiting room"]
        break;
    default:
        message = ["MEETING_STATUS_UNKNOWN", "'(state?.rawValue ?? 9999)'"]
    }
    return message
  }
}

extension SwiftZoomSdkPlugin: MobileRTCMeetingServiceDelegate, MobileRTCCustomizedUIMeetingDelegate {
  public func onJoinMeetingConfirmed() {
    print("onJoinMeetingConfirmed")
  }

  public func onInitMeetingView() {
    print("onInitMeetingView")
  }

  public func onMeetingReady() {
    print("onMeetingReady")
    let roomId = 1
    self.result?(roomId)
  }

  public func onDestroyMeetingView() {
    print("onDestroyMeetingView")
  }

  public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
    print("onMeetingError: \(message)")
  }

  public func onWaitingRoomUserJoin(_ userId: UInt) {
    print("onWaitingRoomUserJoin")
  }
    
  public func onWaitingRoomUserLeft(_ userId: UInt) {
    print("OnWaitingRoomUserLeft")
  }

  public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
    print("onMeetingStateChange: \(state.rawValue)")
    guard let eventSink = eventSink else {return}
    eventSink(getStateMessage(state))
  }
}
