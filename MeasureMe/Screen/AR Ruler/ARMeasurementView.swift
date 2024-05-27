//
//  ARMeasurementView.swift
//  BodyTrackingBlueprint
//
//  Created by Diki Dwi Diro on 20/01/24.
//

import SwiftUI

struct ARMeasurementView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel = ARMeasurementViewModel()
    @Environment(\.dismiss) var dismiss
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            ARViewVCRepresentable(viewModel: viewModel)
            .ignoresSafeArea()
            
            Image(systemName: "smallcircle.filled.circle")
                .foregroundStyle(.thinMaterial)
                .offset(y: -5)
                .isCoachingOverlay($viewModel.isCoachingOverlayEnabled)
            
            VStack {
                TopBarOverlayButtons(viewModel: viewModel)
                
                Spacer()
                
                PlusButton(viewModel: viewModel)
            }
            .isCoachingOverlay($viewModel.isCoachingOverlayEnabled)
        }
        .animation(.interpolatingSpring, value: viewModel.isCoachingOverlayEnabled)
        .statusBar(hidden: true)
    }
}

// MARK: - Preview

#Preview {
    ARMeasurementView()
}

// MARK: - Extension

struct CoachingOverlay: ViewModifier {
    
    @Binding var isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(isEnabled)
            .opacity(isEnabled ? 0 : 1)
    }
}

extension View {
    func isCoachingOverlay(_ enabled: Binding<Bool>) -> some View {
        self.modifier(CoachingOverlay(isEnabled: enabled))
    }
}


// MARK: - UI Components

struct TopBarOverlayButtons: View {
    
    @ObservedObject var viewModel: ARMeasurementViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.clearButtonTapped()
                    Haptics.shared.play(.medium)
                } label: {
                    Label(
                        title: {
                            Text("Clear")
                                .font(.system(.caption2, design: .rounded))
                                .fontWeight(.bold)
                        },
                        icon: {
                            Image(systemName: "trash")
                        }
                    )
                    .frame(width: 60, height: 28)
                    .foregroundStyle(.primary.opacity(0.75))
                    .padding()
                    .tint(.primary.opacity(0.75))
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.thinMaterial)
                    }
                    .padding(.horizontal)
                }
//                .sensoryFeedback(.selection, trigger: viewModel.isClearButtonTapped)
                .opacity(withAnimation { viewModel.isPlusButtonTapped ? 0.5 : 1 })
                .disabled(viewModel.isPlusButtonTapped)
                
                Spacer()
                
                Button {
                    viewModel.isShowCloseAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 28, height: 28)
                        .bold()
                        .foregroundStyle(.primary.opacity(0.75))
                        .padding()
                        .tint(.primary.opacity(0.75))
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.thinMaterial)
                        }
                        .padding(.horizontal)
                }
                .opacity(withAnimation { viewModel.isPlusButtonTapped ? 0.5 : 1 })
                .disabled(viewModel.isPlusButtonTapped)
            }
            .padding()
            
            Text(viewModel.recommendationString)
                .font(.system(.footnote, weight: .semibold))
                .foregroundStyle(.white.opacity(1))
                .padding()
                .background {
                    Color(uiColor: .darkText).cornerRadius(15).opacity(0.75)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)                       
                }
                .opacity(viewModel.recommendationString.isEmpty ? 0 : 1)
                .animation(.interpolatingSpring, value: viewModel.shouldButtonDisabled)
        }
        .alert(isPresented: $viewModel.isShowCloseAlert) { createAlert() }

    }
    private func createAlert() -> Alert {
        Alert(title: Text("Close AR Ruler"),
              message: Text("You will go back to main menu."),
              primaryButton: .cancel(Text("No")),
              secondaryButton: .destructive(Text("Yes")) { dismiss() })
    }
}

struct PlusButton: View {
    
    @ObservedObject var viewModel: ARMeasurementViewModel
    
    var body: some View {
        Button {
            viewModel.isPlusButtonTapped.toggle()
            Haptics.shared.play(.heavy)
        } label: {
            Image(systemName: "plus")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.semibold)
                .tint(.primary.opacity(0.5))
                .padding()
                .background {
                    Circle()
                        .fill(Material.ultraThin)
                }
        }
//        .sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.isPlusButtonTapped)
        .shadow(radius: 2)
        .disabled(viewModel.shouldButtonDisabled)
        .opacity(viewModel.shouldButtonDisabled ? 0.5 : 1)
        .animation(.interactiveSpring, value: viewModel.shouldButtonDisabled)
        .padding(.bottom)
    }
}
