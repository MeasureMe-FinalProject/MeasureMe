//
//  ARSCNViewVC.swift
//  BodyTrackingBlueprint
//
//  Created by Diki Dwi Diro on 20/01/24.
//

import UIKit
import ARKit
import SceneKit

// MARK: - ARSCNViewViewControllerDelegate

protocol ARViewVCDelegate: AnyObject {
    func didFind(distance: String)
    func didCoachingOverlay(enabled: Bool)
    func shouldPlusButton(disabled: Bool)
    func didShowRecommendation(message: String)
}

class ARSCNViewVC: UIViewController {
    
    // MARK: - ARSCNView Properties
    
    private let sceneView = ARSCNView(frame: .zero)
    private let coachingOverlay = ARCoachingOverlayView()
    private weak var arSceneViewVCDelegate: ARViewVCDelegate?
    
    // MARK: - UI Values Properties
    
    private var isMeasuring = false
    private var startValue = SCNVector3()
    private var endValue = SCNVector3()
    private let initialValue = SCNVector3()
    private var currentLine: Line?
    private var lines: [Line] = []
    
    // MARK: - Initializer
    
    init(aRViewVCDelegate: ARViewVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.arSceneViewVCDelegate = aRViewVCDelegate
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSCNView()
        setupCoachingOverlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        setupARSCNView()
    }
}

// MARK: - Public Functions

extension ARSCNViewVC {
    func startMeasuring() {
        isMeasuring = true
    }
    
    func stopMeasuring() {
        isMeasuring = false
        if let line = currentLine {
            lines.append(line)
            currentLine = nil
        }
        resetValues()
    }
    
    func clearAllLines(_ sender: Any) {
        for line in lines {
            line.removeFromParentNode()
        }
        lines.removeAll()
        DispatchQueue.main.async {
            self.arSceneViewVCDelegate?.didFind(distance: "0cm")
        }
    }
}


// MARK: - Private Functions

private extension ARSCNViewVC {
    private func setupARSCNView() {
        sceneView.delegate = self
        sceneView.frame = view.layer.bounds
        view.addSubview(sceneView)
    
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        checkLiDARSupport(configuration: configuration)
        
        sceneView.debugOptions = .showFeaturePoints
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors, .stopTrackedRaycasts])
        resetValues()
    }
    
    private func checkLiDARSupport(configuration: ARWorldTrackingConfiguration) {
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
    }
    
    private func setupCoachingOverlay() {
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.activatesAutomatically = true
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    private func resetValues() {
        isMeasuring = false
        startValue = SCNVector3()
        endValue =  SCNVector3()
    }
    
    private func showRecommendationMessage(of camera: ARCamera.TrackingState) {
        switch camera {
        case .notAvailable:
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Camera isn't available\nPlease check device compatibility")
            return
        case .limited(.excessiveMotion):
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Slow down")
            return
        case .limited(.insufficientFeatures):
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "More light required")
            return
        case .limited(.initializing):
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Initializing")
            return
        case .limited(.relocalizing):
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Recovering from interruption")
            return
        case .normal:
            arSceneViewVCDelegate?.shouldPlusButton(disabled: false)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Find a surface")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.arSceneViewVCDelegate?.didShowRecommendation(message: "")
            }
            return
        @unknown default:
            arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
            arSceneViewVCDelegate?.didShowRecommendation(message: "Unknown tracking state.")
            return
        }
        
    }
}

// MARK: - ARSCNViewVC for Perform Raycasting

extension ARSCNViewVC {
    private func detectSurface() {
        let tapLocation = view.center
        if isMeasuring {
            guard let realWorldPosition = getRealWorldPosition(from: tapLocation) else {
//                handleMeasurementFailure()
                return
            }
            handleMeasurementSuccess(realWorldPosition: realWorldPosition)
        }
    }

    private func handleMeasurementFailure() {
        arSceneViewVCDelegate?.shouldPlusButton(disabled: true)
        arSceneViewVCDelegate?.didShowRecommendation(message: "Find a contrast surface")
    }

    private func handleMeasurementSuccess(realWorldPosition: SCNVector3) {
        arSceneViewVCDelegate?.shouldPlusButton(disabled: false)
        arSceneViewVCDelegate?.didShowRecommendation(message: "")
        if startValue == initialValue {
            startValue = realWorldPosition
            currentLine = Line(sceneView: sceneView, startVector: startValue)
        }
        endValue = realWorldPosition
        currentLine?.update(to: endValue)
        arSceneViewVCDelegate?.didFind(distance: currentLine?.distanceInString ?? "")
    }

    /** Gets the real-world position from a tap location using raycasting. Returns SCNVector3. */
    private func getRealWorldPosition(from tapLocation: CGPoint) -> SCNVector3? {
        guard let raycastResult = performRaycasting(from: tapLocation) else { return nil }
        return extractPosition(from: raycastResult.worldTransform)
    }
    
    /** Extracts the position (coordinates) from a 3D transformation matrix. */
    private func extractPosition(from matrix: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
    }

    /** Performs raycasting from a screen location to estimate planes in AR environment. */
    private func performRaycasting(from location: CGPoint) -> ARRaycastResult? {
        guard let raycastQueryResults = sceneView.raycastQuery(from: location,
                                                               allowing: .estimatedPlane,
                                                               alignment: .any) else { return nil }

        let raycastResults = sceneView.session.raycast(raycastQueryResults)
        return raycastResults.first
    }

}

// MARK: - Extension ARSCNViewDelegate

extension ARSCNViewVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectSurface()
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        showRecommendationMessage(of: camera.trackingState)
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
}

// MARK: - Extension ARCoachingOverlayViewDelegate

extension ARSCNViewVC: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        arSceneViewVCDelegate?.didCoachingOverlay(enabled: true)
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        arSceneViewVCDelegate?.didCoachingOverlay(enabled: false)
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        setupARSCNView()
    }
}

final class Line {
    var distanceInString = ""
    private var color: UIColor = .white
    
    private var startNode: SCNNode!
    private var endNode: SCNNode!
    private var text: SCNText!
    private var textNode: SCNNode!
    private var lineNode: SCNNode?
    
    private let sceneView: ARSCNView
    private let startVector: SCNVector3
    
    init(sceneView: ARSCNView, startVector: SCNVector3) {
        self.sceneView = sceneView
        self.startVector = startVector
        
        // Initialize startNode
        let dot = SCNSphere(radius: 0.5)
        dot.firstMaterial?.diffuse.contents = color
        dot.firstMaterial?.lightingModel = .constant
        dot.firstMaterial?.isDoubleSided = true
        startNode = SCNNode(geometry: dot)
        startNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        startNode.position = startVector
        sceneView.scene.rootNode.addChildNode(startNode)
        
        // Initialize endNode
        endNode = SCNNode(geometry: dot)
        endNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        // Initialize text for showing the distance
        text = SCNText(string: "", extrusionDepth: 0.1)
        text.font = .systemFont(ofSize: 10)
        text.firstMaterial?.diffuse.contents = color
        text.alignmentMode  = CATextLayerAlignmentMode.center.rawValue
        text.truncationMode = CATextLayerTruncationMode.middle.rawValue
        text.firstMaterial?.isDoubleSided = true
        
        let textWrapperNode = SCNNode(geometry: text)
        textWrapperNode.eulerAngles = SCNVector3Make(0, .pi, 0)
        textWrapperNode.scale = SCNVector3(1/500.0, 1/500.0, 1/500.0)
        
        // Initialize textNode
        textNode = SCNNode()
        textNode.addChildNode(textWrapperNode)
        
        // Set the constraints to always look at the camera
        let constraint = SCNLookAtConstraint(target: sceneView.pointOfView)
        constraint.isGimbalLockEnabled = true
        textNode.constraints = [constraint]
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    func update(to endVector: SCNVector3) {
        lineNode?.removeFromParentNode()
        lineNode = drawLine(from: startVector, to: endVector)
        sceneView.scene.rootNode.addChildNode(lineNode!)
        
        // Get distance between startVector to endVector
        distanceInString = getDistanceValueInString(from: startVector, to: endVector)
        text.string = distanceInString
        textNode.position = SCNVector3((startVector.x+endVector.x)/2.0,
                                       (startVector.y+endVector.y)/2.0,
                                       (startVector.z+endVector.z)/2.0)
        
        endNode.position = endVector
        if endNode.parent == nil {
            sceneView.scene.rootNode.addChildNode(endNode)
        }
    }
    
    func removeFromParentNode() {
        startNode.removeFromParentNode()
        lineNode?.removeFromParentNode()
        endNode.removeFromParentNode()
        textNode.removeFromParentNode()
    }
    
    private func drawLine(from vectorOne: SCNVector3, to secondVector: SCNVector3, color: UIColor = .white) -> SCNNode {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vectorOne, secondVector])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geometry = SCNGeometry(sources: [source], elements: [element])
        geometry.firstMaterial?.diffuse.contents = color
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    private func getDistanceValueInString(from vectorOne: SCNVector3, to vectorTwo: SCNVector3) -> String {
        let distanceX = vectorOne.x - vectorTwo.x
        let distanceY = vectorOne.y - vectorTwo.y
        let distanceZ = vectorOne.z - vectorTwo.z
        let distance = sqrtf((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
        let distanceInString = String(format: "%.0fcm", distance * 100)
        return distanceInString
    }
}

// MARK: - Extension for comparing between two types of SCNVector3

extension SCNVector3: Equatable {
    public static func ==(lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

