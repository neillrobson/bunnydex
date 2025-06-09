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

    static let zero = PanGestureValue(location: .zero, startLocation: .zero, translation: .zero, magnification: 0)
}

class GestureObserver: ObservableObject {
    @Published var value: PanGestureValue = .zero

    private var touches = [[CGPoint]]()

    func update(_ points: [CGPoint]) {
        if points.isEmpty {
            touches.removeAll()
            return
        }

        // TODO: The remainder of this fn
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

    // TODO: The override fucntions
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
