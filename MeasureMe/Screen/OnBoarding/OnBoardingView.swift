//
//  OnBoardingView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 03/02/24.
//

import SwiftUI

struct OnBoardingView: View {
    
    @StateObject var viewModel: OnBoardingViewModel = OnBoardingViewModel()
    
    var body: some View {
        VStack {
            createHeaderLogo()
            
            createOnBoardingContent()
            
            HStack {
                createBackButton()
                
                Spacer()
                
                createNextButton()
            }
            .overlay {
                createCustomIndexDisplay()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.isShowLogin) {
            LoginView()
        }
    }
    
    @ViewBuilder private func createCustomIndexDisplay() -> some View {
        HStack {
            ForEach(0 ..< 3)  { circleIndex in
                Circle()
                    .fill(circleIndex == viewModel.currentPage ? .blue : .blue.opacity(0.20))
                    .frame(width: 7.5, height: 7.5)
            }
        }
    }
    
    @ViewBuilder private func createNextButton() -> some View {
        Button {
            viewModel.moveToNextPage()
        } label: {
            Text(viewModel.currentPage == 2 ? "Get Started" : "Next")
                .fontWeight(.semibold)
        }
        .padding(.trailing)
    }
    
    @ViewBuilder private func createBackButton() -> some View {
        Button {
            viewModel.moveToPreviousPage()
        } label: {
            Text("Back")
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
        .disabled(viewModel.isFirstPage)
        .opacity(viewModel.isFirstPage ? 0 : 0.75)
        .padding(.leading)
    }
    
    @ViewBuilder private func createOnBoardingContent() -> some View {
        TabView(selection: $viewModel.currentPage) {
            ForEach(viewModel.onBoardingPages.indices, id: \.self) { index in
                createOnBoardingPage(viewModel.onBoardingPages[index])
                    .tag(viewModel.onBoardingPages[index])
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder private func createOnBoardingPage(_ onBoardingPage: OnBoardingPage) -> some View {
        VStack {
            Image(onBoardingPage.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 400)
                .padding(.all, 20)
            
            HStack(alignment: .center) {
                Text(onBoardingPage.headingOne)
                    .foregroundStyle(viewModel.isFirstPage ? Color.blue : .primary)
                
                Text(onBoardingPage.headingTwo)
                    .foregroundStyle(viewModel.isFirstPage ? .primary : Color.blue)
                
            }
            .font(.system(.title, weight: .semibold))
            .padding(.bottom, 10)

            Text(onBoardingPage.subheading)
                .font(.system(.subheadline))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    @ViewBuilder private func createHeaderLogo() -> some View {
        Image(.headerLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 45)
    }
}

#Preview {
    OnBoardingView()
}
