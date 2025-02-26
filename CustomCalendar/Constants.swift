//
//  Constants.swift
//  CustomCalendar
//
//  Created by Tanmay Patil on 21/02/25.
//
import SwiftUI

struct Constants {
  static var barlowFontWeight: [SwiftUI.Font.Weight: String] = [
    .ultraLight: "Thin",
    .thin: "ExtraLight",
    .light: "Light",
    .regular: "Regular",
    .medium: "Medium",
    .bold: "Bold",
    .heavy: "ExtraBold",
    .black: "Black"
  ]
  static var ppNeueMontrealFontWeight: [SwiftUI.Font.Weight: String] = [
    .ultraLight: "Thin",
    .thin: "Thin",
    .light: "Book",
    .regular: "Book",
    .medium: "Medium",
    .bold: "Bold",
    .heavy: "Bold",
    .black: "Bold"
  ]
}

struct UIConstants {
    static var cellHeight: CGFloat = 44
    static var dateGridSpacing: CGFloat = 8
    static var chevronFontSize: CGFloat = 15
    static var rangeSelectBgColor = Color.colorBrandAccent.opacity(0.2)
    static var cellBgCol = Color.colorBrandPrimary
    static var selectedCellBgCol = Color.colorBrandAccent
    static var chevronCol = Color.textColoredText
    static var bgCol = Color.colorBrandPrimary
    static var todayDateCol = Color.textColoredText
    static var defaultDateCol = Color.textPrimaryText
    static var selectedDateCol = Color.primaryButtonText
}
