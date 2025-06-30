//
//  Zoomable.swift
//  Bunnydex
//
//  Created by Neill Robson on 6/16/25.
//
//  Source: https://github.com/ryohey/Zoomable/blob/main/Sources/Zoomable/Zoomable.swift

#if os(iOS)

import SwiftUI

struct ZoomableModifier: ViewModifier {
    let minZoomScale: CGFloat
    let doubleTapZoomScale: CGFloat

    @State private var lastTransform: CGAffineTransform = .identity
    @State private var transform: CGAffineTransform = .identity
    @State private var contentSize: CGSize = .zero
    @State private var frameSize: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .background(alignment: .topLeading) {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            contentSize = proxy.size
                        }
                }
            }
            .animatableTransformEffect(transform)
            .gesture(dragGesture, including: transform == .identity ? .none : .all)
            .gesture(maginficationGesture)
            .gesture(doubleTapGesture)
            .frame(maxWidth: .infinity, maxHeight: 200)
            .background(alignment: .topLeading) {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            frameSize = proxy.size
                        }
                }
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring) {
                    transform = lastTransform.translatedBy(x: value.translation.width / transform.scaleX, y: value.translation.height / transform.scaleY)
                }
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    private var maginficationGesture: some Gesture {
        MagnifyGesture(minimumScaleDelta: 0)
            .onChanged { value in
                let newTransform = CGAffineTransform.anchoredScale(scale: value.magnification, anchor: value.startAnchor.scaledBy(contentSize))

                withAnimation(.interactiveSpring) {
                    transform = lastTransform.concatenating(newTransform)
                }
            }
            .onEnded { _ in
                onEndGesture()
            }
    }

    private var doubleTapGesture: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { value in
                let newTransform: CGAffineTransform =
                if transform.isIdentity {
                    limitTransform(CGAffineTransform.anchoredScale(scale: doubleTapZoomScale, anchor: value.location))
                } else {
                    .identity
                }

                withAnimation(.linear(duration: 0.15)) {
                    transform = newTransform
                    lastTransform = newTransform
                }
            }
    }

    private func onEndGesture() {
        let newTransform = limitTransform(transform)

        withAnimation(.snappy(duration: 0.1)) {
            transform = newTransform
            lastTransform = newTransform
        }
    }

    private func limitTransform(_ transform: CGAffineTransform) -> CGAffineTransform {
        let scaleX = transform.scaleX
        let scaleY = transform.scaleY

        if scaleX < minZoomScale || scaleY < minZoomScale {
            return .identity
        }

        let marginX = (frameSize.width - contentSize.width) / 2
        let marginY = (frameSize.height - contentSize.height) / 2
        let extraMarginX = ((1 - scaleX) * contentSize.width)
        let extraMarginY = ((1 - scaleY) * contentSize.height)

        let minX = min(-marginX, marginX + extraMarginX)
        let minY = min(-marginY, marginY + extraMarginY)
        let maxX = max(-marginX, marginX + extraMarginX)
        let maxY = max(-marginY, marginY + extraMarginY)

        if transform.tx > maxX
            || transform.tx < minX
            || transform.ty > maxY
            || transform.ty < minY {
            let tx = min(max(transform.tx, minX), maxX)
            let ty = min(max(transform.ty, minY), maxY)
            var transform = transform
            transform.tx = tx
            transform.ty = ty
            return transform
        }

        return transform
    }
}

public extension View {
    @ViewBuilder
    func zoomable(minZoomScale: CGFloat = 1, doubleTapZoomScale: CGFloat = 3) -> some View {
        modifier(ZoomableModifier(minZoomScale: minZoomScale, doubleTapZoomScale: doubleTapZoomScale))
    }

    @ViewBuilder
    func zoomable(minZoomScale: CGFloat = 1, doubleTapZoomScale: CGFloat = 3, outOfBoundsColor: Color = .clear) -> some View {
        GeometryReader { proxy in
            ZStack {
                outOfBoundsColor
                self.zoomable(minZoomScale: minZoomScale, doubleTapZoomScale: doubleTapZoomScale)
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func modify(@ViewBuilder _ fn: (Self) -> some View) -> some View {
        fn(self)
    }

    @ViewBuilder
    func animatableTransformEffect(_ transform: CGAffineTransform) -> some View {
        scaleEffect(x: transform.scaleX, y: transform.scaleY, anchor: .zero)
            .offset(x: transform.tx, y: transform.ty)
    }
}

private extension UnitPoint {
    func scaledBy(_ size: CGSize) -> CGPoint {
        .init(x: x * size.width, y: y * size.height)
    }
}

private extension CGAffineTransform {
    static func anchoredScale(scale: CGFloat, anchor: CGPoint) -> CGAffineTransform {
        CGAffineTransform(translationX: anchor.x, y: anchor.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -anchor.x, y: -anchor.y)
    }

    var scaleX: CGFloat {
        sqrt(a * a + c * c)
    }

    var scaleY: CGFloat {
        sqrt(b * b + d * d)
    }
}

#endif
