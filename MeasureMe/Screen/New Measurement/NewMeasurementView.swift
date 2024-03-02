//
//  NewMeasurementView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct NewMeasurementView: View {
    
    @StateObject var viewModel: NewMeasurementViewModel = NewMeasurementViewModel()
    
    var body: some View {
        VStack {
            createGenderChoices()
            
            createBodyHeightSlider()
            
            createNextButton()
        }
        .blur(radius: viewModel.isShowPrivacyMeassage ? 3 : 0)
        .padding()
        .padding(.horizontal)
        .overlay {
            if viewModel.isShowPrivacyMeassage {
                showPrivacyMessagePopup()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowPhotoCaptureView) {
            PhotoCaptureView(isShow: $viewModel.isShowPhotoCaptureView)
        }
    }
    
    @ViewBuilder private func showPrivacyMessagePopup() -> some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.background)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .topTrailing) {
                            Button {
                                withAnimation {
                                    viewModel.isShowPrivacyMeassage.toggle()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(.headline, weight: .semibold))
                                    .foregroundStyle(.foreground)
                            }
                            .offset(y: -12.5)
                            .padding()
                            
                            VStack {
                                Text("We respect your pricacy")
                                    .font(.system(.headline))
                                    .foregroundStyle(.primary)
                                    .padding(.bottom, 5)
                                
                                Text("Your face will be blurred after the photos are captured 🔒")
                                    .font(.system(.subheadline))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                
                                Button {
                                    viewModel.isShowPhotoCaptureView.toggle()
                                    DispatchQueue.main.async {
                                        viewModel.isShowPrivacyMeassage.toggle()
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 53)
                                        .overlay {
                                            Text("Take Photos")
                                                .font(.system(.headline))
                                                .foregroundStyle(.white)
                                        }
                                }
                                
                            }
                            .padding(.all, 20)
                        }
                    }
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(.white.opacity(0.4))
            }
            .frame(width: 300, height: 200)
        }
    }
    
    @ViewBuilder private func createNextButton() -> some View {
        Button {
            withAnimation {
                viewModel.isShowPrivacyMeassage.toggle()
            }
        } label: {
            Text("Next")
                .foregroundStyle(.background)
                .font(.system(.subheadline, weight: .semibold))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder private func createBodyHeightSlider() -> some View {
        Text("Height")
            .font(.system(.title2, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
        
        RoundedRectangle(cornerRadius: 14)
            .stroke(lineWidth: 1)
            .fill(.primary.opacity(0.2))
            .background {
                HStack {
                    VStack {
                        Group {
                            Text("\(Int(viewModel.height)) ")
                                .font(.system(.title2, weight: .bold))
                            +
                            Text("cm")
                                .font(.system(.title3, weight: .medium))
                        }
                        .padding(.bottom, viewModel.paddingHeightImageVector)
                        
                        Image("height-vector")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                                        
                    HeightSlider(height: $viewModel.height)
                }
                .padding(.all)
            }
            .clipped()
            .padding(.bottom)
    }
    
    @ViewBuilder private func createGenderChoices() -> some View {
        Text("Gender")
            .font(.system(.title2, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            ForEach(GenderType.allCases, id: \.self) { gender in
                GenderCard(gender: gender, selectedGender: $viewModel.selectedGender)
            }
        }
    }
}

#Preview {
    NewMeasurementView()
}

struct GenderCard: View {
    
    let gender: GenderType
    @Binding var selectedGender: GenderType?
    
    var isSelectedGender: Bool {
        selectedGender == gender
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .stroke(lineWidth: isSelectedGender ? 2 : 1)
            .fill(isSelectedGender ? .blue : .primary.opacity(0.2))
            .shadow(color: isSelectedGender ? .blue.opacity(0.3) : .blue.opacity(0), radius: 0)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white)
                        .shadow(color: isSelectedGender ?
                            .blue.opacity(0.3) : .white, radius: 5)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelectedGender ? .blue.opacity(0.1) : Color(uiColor: .systemBackground))
                    
                    VStack {
                        Text(gender.name)
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(isSelectedGender ? .blue : .secondary)
                            .padding(.top)
                        
                        Image(gender.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(x: gender == GenderType.female ? 10 : 0)
                    }
                }
            }
            .padding([gender == GenderType.male ? .leading : .trailing, .bottom])
            .frame(width: 175, height: 200)
            .onTapGesture {
                withAnimation {
                    selectedGender = gender
                }
            }
    }
}

struct HeightSlider: View {
    @State private var rulerOffset: CGSize = CGSize(width: 0, height: -1660)
    @State private var previousTranslation: CGSize = .zero
    @Binding var height: Int
    
    var body: some View {
        ZStack {
            createRuler()
            
            createPointer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder private func createRuler() -> some View {
        VStack(alignment: .trailing) {
            ForEach(0..<201) { index in
                if index % 10 == 0 {
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: 50, height: 2)
                        .overlay {
                            Text("\(index)")
                                .font(.system(.caption, weight: .bold))
                                .offset(x: -45)
                        }
                } else if index % 5 == 0 {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 35, height: 1)
                        .frame(height: 2)
                    
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 25, height: 0.5)
                        .frame(height: 2)
                }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 2)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .foregroundStyle(Color.primary.opacity(0.30))
        .offset(y: 1000)
        .offset(rulerOffset)
        .gesture(
            DragGesture()
                .onChanged { currentGesture in
                    withAnimation {
                        let translation = CGSize(width: 0, height: currentGesture.translation.height - previousTranslation.height)
                        previousTranslation = currentGesture.translation
                        
                        rulerOffset.height += translation.height
                        rulerOffset.height = min(max(rulerOffset.height, -2000), 1)
                        
                        height = abs(Int(rulerOffset.height / 10))
                    }
                }
                .onEnded{ _ in
                    previousTranslation = .zero
                    height = abs(Int(rulerOffset.height / 10))
                }
        )
    }
    
    @ViewBuilder private func createPointer() -> some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.blue)
                .frame(width: 50, height: 2)
            
            Image(systemName: "arrowtriangle.left.fill")
                .foregroundStyle(.blue)
                .offset(x: 2)
        }
        .shadow(color: .blue.opacity(0.5), radius: 10)
    }
}
