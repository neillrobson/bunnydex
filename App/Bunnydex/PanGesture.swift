//
//  PanGesture.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/9/25.
//

import SwiftUI

// REFERENCE: https://stackoverflow.com/questions/76001888/how-to-detect-2-finger-pan-gesture-in-swiftui

struct PanGestureValue {
    var location: CGPoint
    var startLocation: CGPoint
    var translation: CGSize
    var magnification: Double

    static let zero = PanGestureValue(location: .zero, startLocation: .zero, translation: .zero, magnification: 1)
}

class GestureObserver: ObservableObject {
    @Published var value: PanGestureValue = .zero

    private var touches = [[CGPoint]]()

    func update(_ points: [CGPoint]) {
        if points.isEmpty {
            touches.removeAll()
            return
        }

        touches.append(points)

        guard let firstTwoFingerTouch = touches.first(where: { $0.count == 2 }),
              let lastTwoFingerTouch = touches.last(where: { $0.count == 2 }) else {
                  return
              }

        let startDist = CGPointDistance(from: firstTwoFingerTouch[0], to: firstTwoFingerTouch[1])
        let currentDist = CGPointDistance(from: lastTwoFingerTouch[0], to: lastTwoFingerTouch[1])

        let zoom = currentDist / startDist

        let startLocationX = -(firstTwoFingerTouch[0].x + firstTwoFingerTouch[1].x) / 2
        let startLocationY = -(firstTwoFingerTouch[0].y + firstTwoFingerTouch[1].y) / 2

        let locationX = (lastTwoFingerTouch[0].x + lastTwoFingerTouch[1].x) / 2
        let locationY = (lastTwoFingerTouch[0].y + lastTwoFingerTouch[1].y) / 2

        let offsetX = startLocationX + locationX
        let offsetY = startLocationY + locationY

        let startLocation = CGPoint(x: startLocationX, y: startLocationY)
        let location = CGPoint(x: locationX, y: locationY)
        let offset = CGSize(width: offsetX, height: offsetY)

        self.value.location = location
        self.value.startLocation = startLocation
        self.value.magnification = zoom
        self.value.translation = offset
    }
}

private func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    CGFloat(hypotf(Float(to.x - from.x), Float(to.y - from.y)))
}

struct PanGestureView: UIViewRepresentable {
    var onTouch: ([CGPoint]) -> Void

    func makeUIView(context: Context) -> PanGestureUIView {
        let view = PanGestureUIView()
        view.onTouch = onTouch
        view.isMultipleTouchEnabled = true
        return view
    }

    func updateUIView(_ uiView: PanGestureUIView, context: Context) {}
}

class PanGestureUIView: UIView {
    var onTouch: (([CGPoint]) -> Void)?
    private var activeTouches: [UITouch: CGPoint] = [:]

    private func updateTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            activeTouches[touch] = touch.location(in: self)
        }
        onTouch?(Array(activeTouches.values))
    }

    private func removeTouches(_ touches: Set<UITouch>) {
        for touch in touches {
            activeTouches.removeValue(forKey: touch)
        }
        onTouch?(Array(activeTouches.values))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        updateTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        removeTouches(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        removeTouches(touches)
    }
}

struct PanGestureModifier: ViewModifier {
    var onGesture: (PanGestureValue) -> Void
    @StateObject private var gestureObserver = GestureObserver()

    func body(content: Content) -> some View {
        content
            .overlay {
                PanGestureView { touches in
                    gestureObserver.update(touches)
                    onGesture(gestureObserver.value)
                }
            }
    }
}

extension View {
    func panGesture(_ onGesture: @escaping (PanGestureValue) -> Void) -> some View {
        self.modifier(PanGestureModifier(onGesture: onGesture))
    }
}
