//
//  OnBoardingViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/02/24.
//

import SwiftUI

final class OnBoardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isShowLogin: Bool = false
    var isFirstPage: Bool { currentPage == 0 }
    
    let onBoardingPages: [OnBoardingPage] = [
        OnBoardingPage(image: OnBoardingContent.pageOne.imageVector,
                       headingOne: OnBoardingContent.pageOne.headingOne,
                       headingTwo: OnBoardingContent.pageOne.headingTwo,
                       subheading: OnBoardingContent.pageOne.subheading),
        
        OnBoardingPage(image: OnBoardingContent.pageTwo.imageVector,
                       headingOne: OnBoardingContent.pageTwo.headingOne,
                       headingTwo: OnBoardingContent.pageTwo.headingTwo,
                       subheading: OnBoardingContent.pageTwo.subheading),
        
        OnBoardingPage(image: OnBoardingContent.pageThree.imageVector,
                       headingOne: OnBoardingContent.pageThree.headingOne,
                       headingTwo: OnBoardingContent.pageThree.headingTwo,
                       subheading: OnBoardingContent.pageThree.subheading)
    ]
    
    func moveToNextPage() {
        withAnimation {
            if currentPage >= 2 {
                isShowLogin = true
            } else {
                currentPage += 1
            }
        }
    }
    
    func moveToPreviousPage() {
        withAnimation {
            currentPage -= 1
        }
    }
}
