import ReplayKit
import WebRTC
import os

open class BBBSampleHandler : RPBroadcastSampleHandler {
    // Logger (these messages are displayed in the console application)
    private var logger = os.Logger(subsystem: "BigBlueButtonMobileSDK", category: "BBBSampleHandler")
    private let defaults = UserDefaults.init(suiteName: Constants.appGroup)
    
    private var webRTCClient = WebRTCClient(iceServers: STUNServers.defaultServers)
    private var isWebRTCConnected: Bool = false
    
    open override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        logger.info("ReplayKit2 event - broadcastStarted")
        webRTCClient.delegate = self
        sendSdpOffer()
    }
    
    open override func broadcastPaused() {
        logger.info("ReplayKit2 event - broadcastPaused")
    }
    
    open override func broadcastResumed() {
        logger.info("ReplayKit2 event - broadcastResumed")
    }
    
    open override func broadcastFinished() {
        logger.info("ReplayKit2 event - broadcastFinished")
    }
    
    open override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            logger.trace("ReplayKit2 event - processSampleBuffer(video)")
            pushVideo(sampleBuffer)
            break
        case RPSampleBufferType.audioApp:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioApp)")
            break
        case RPSampleBufferType.audioMic:
            logger.trace("ReplayKit2 event - processSampleBuffer(audioMic)")
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
    
    private func sendSdpOffer() {
        webRTCClient.offer { [weak self] (localSdpOffer) in
            guard let `self` = self else { return }
            self.defaults?.set(localSdpOffer.sdp, forKey: UserDefaults.Key.sdpOffer)
            print("✅ Sent local sdp offer: \(localSdpOffer)")
        }
    }
    
    private func setSdpAnswer(_ sdpAnswer: RTCSessionDescription) {
        webRTCClient.set(remoteSdp: sdpAnswer) { (error) in
            if error != nil {
                print("⚡️☠️ Error setting remote sdp answer: \(error!.localizedDescription)")
            } else {
                print("✅ Set remote SDP answer: \(sdpAnswer.sdp)")
            }
        }
    }
    
    private func pushVideo(_ sampleBuffer: CMSampleBuffer) {
        guard isWebRTCConnected else { return }
        guard let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timeStampNs: Int64 = Int64(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000000000)
        let rtcPixlBuffer = RTCCVPixelBuffer(pixelBuffer: imageBuffer)
        let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixlBuffer, rotation: ._0, timeStampNs: timeStampNs)
        webRTCClient.push(videoFrame: rtcVideoFrame)
        print("Pushed webRTC video frame")
    }
}

// MARK: - WebRTCClient Delegate Methods

extension BBBSampleHandler: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("✅ Discovered local candidate \(candidate).")
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        switch state {
        case .connected, .completed:
            isWebRTCConnected = true
            print("✅ WebRTC connected")
        case .disconnected:
            isWebRTCConnected = false
            print("⚡️ WebRTC disconnected")
        case .failed, .closed:
            isWebRTCConnected = false
        case .new, .checking, .count:
           break
        @unknown default:
            print("Unknown connection state.")
        }
    }
}
