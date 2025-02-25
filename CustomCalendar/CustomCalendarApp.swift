//
//  CustomCalendarApp.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 07/02/25.
//

import SwiftUI
import DVThemeKit

@main
struct CustomCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        ThemeManager.shared.currentThemes = LightDefaultThemes()
        ThemeManager.shared.currentTypography = DefaultTypography()
        configureTheme()
    }
    
    func configureTheme() {
        FontAttributes.mapWeightToString = { weight, family in
          guard let weight else { return nil }
          let swiftUIFontWeight = self.mapFontWeight(from: weight)
          if family.caseCompare("Barlow Condensed") {
            return Constants.barlowFontWeight[swiftUIFontWeight]
          } else if family.caseCompare("PP Neue Montreal") {
            return Constants.ppNeueMontrealFontWeight[swiftUIFontWeight]
          }
          return nil
        }
      }

      func mapFontWeight(from weight: Double) -> Font.Weight {
        switch weight {
        case ...100: return .ultraLight
        case 101...200: return .thin
        case 201...300: return .light
        case 301...400: return .regular
        case 401...500: return .medium
        case 501...600: return .semibold
        case 601...700: return .bold
        case 701...800: return .heavy
        default: return .black
        }
      }
}

#Preview {
    ContentView()
}
