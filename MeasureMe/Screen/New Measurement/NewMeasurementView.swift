//
//  NewMeasurementView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct NewMeasurementView: View {
    
    @StateObject var viewModel: NewMeasurementViewModel = NewMeasurementViewModel()
    @Binding var isShow: Bool
    
    var body: some View {
        ZStack {
            createNavigationBar()
            
            VStack {
                createGenderChoices()
                
                createBodyHeightSlider()
                
                createNextButton()
            }
        }
        .overlay {
            if viewModel.isShowPrivacyMeassage {
                showPrivacyMessagePopup()
            }
        }
        .alert("Empty Field", isPresented: $viewModel.isShowMessageAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please input your gender and \nbody height properly")
        }
        .fullScreenCover(isPresented: $viewModel.isShowPhotoCaptureView) {
            PhotoCaptureView(isShow: $viewModel.isShowPhotoCaptureView)
        }
    }
    
    @ViewBuilder private func showPrivacyMessagePopup() -> some View {
        ZStack {
            Color.black.opacity(0.6)
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
                            .padding()
                            
                            VStack {
                                Text("We respect your privacy")
                                    .font(.system(.headline))
                                    .foregroundStyle(.primary)
                                    .padding(.bottom, 5)
                                    .padding(.top)
                                
                                Text("Your face will be blurred while the photos are being process 🔒")
                                    .font(.system(.subheadline))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                
                                Spacer()
                                
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
                            .padding(.all)
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

            guard viewModel.isValidToCreateNewMeasurement() else { 
                viewModel.isShowMessageAlert = true
                return
            }
            withAnimation {
                viewModel.isShowPrivacyMeassage.toggle()
            }
        } label: {
            Text("Next")
                .foregroundStyle(.background)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    @ViewBuilder private func createBodyHeightSlider() -> some View {
        VStack {
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
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    @ViewBuilder private func createGenderChoices() -> some View {
        Text("Gender")
            .font(.system(.title2, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.top, 65)
        
        HStack {
            ForEach(GenderType.allCases, id: \.self) { gender in
                GenderCard(gender: gender, selectedGender: $viewModel.selectedGender)
            }
        }
    }
    
    @ViewBuilder private func createDismissButton() -> some View {
        Button {
            withAnimation {
                isShow.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.system(.headline, weight: .semibold))
                .foregroundStyle(.foreground)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing)
        .padding(.bottom)
    }
    
    @ViewBuilder private func createNavigationBar() -> some View {
        Rectangle()
            .foregroundStyle(.background)
            .shadow(color: .black.opacity(0.075), radius: 3, y: 4)
            .frame(height: 100)
            .overlay(alignment: .bottom) {
                Text("New Measurement")
                    .font(.system(.body, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .overlay(alignment: .trailing) {
                        Button {
                            withAnimation {
                                isShow.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(.headline, weight: .semibold))
                                .foregroundStyle(.foreground)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom)
                    }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NewMeasurementView(isShow: .constant(true))
        .environmentObject(SharedProfileData(user: User.dummyUser))
}

struct GenderCard: View {
    
    let gender: GenderType
    @Binding var selectedGender: GenderType?
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
    var isSelectedGender: Bool {
        selectedGender == gender
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .stroke(lineWidth: isSelectedGender ? 2 : 1)
            .fill(isSelectedGender ? .appPrimary : .primary.opacity(0.2))
            .shadow(color: isSelectedGender ? .appPrimary.opacity(0.3) : .appPrimary.opacity(0), radius: 0)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white)
                        .shadow(color: isSelectedGender ?
                            .appPrimary.opacity(0.3) : .white, radius: 5)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isSelectedGender ? .appPrimary.opacity(0.1) : Color(uiColor: .systemBackground))
                    
                    VStack {
                        Text(gender.name)
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(isSelectedGender ? .appPrimary : .secondary)
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
                sharedProfileData.gender = gender
                withAnimation {
                    selectedGender = gender
                }
            }
    }
}

struct HeightSlider: View {
    @State private var rulerOffset: CGSize = CGSize(width: 0, height: 0)
    @State private var previousTranslation: CGSize = .zero
    @Binding var height: Int
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
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
                        DispatchQueue.main.async {
                            sharedProfileData.height = height
                        }
                    }
                }
                .onEnded{ _ in
                    previousTranslation = .zero
                    height = abs(Int(rulerOffset.height / 10))
                    DispatchQueue.main.async {
                        sharedProfileData.height = height
                    }
                }
        )
    }
    
    @ViewBuilder private func createPointer() -> some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.appPrimary)
                .frame(width: 50, height: 2)
            
            Image(systemName: "arrowtriangle.left.fill")
                .foregroundStyle(.appPrimary)
                .offset(x: 2)
        }
        .shadow(color: .appPrimary.opacity(0.5), radius: 10)
    }
}
