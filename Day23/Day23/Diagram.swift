//
//  Diagram.swift
//  Day23
//
//  Created by Rolf Staflin on 2018-12-27.
//  Copyright © 2018 Piro AB. All rights reserved.
//

import Cocoa

enum DiagramType {
    case xy
    case xz
    case yz
}

class Diagram: NSView {

    var center = CGPoint(x: 0, y: 0)
    var type = DiagramType.xy

    fileprivate func drawXY(_ context: CGContext) {
        context.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context.setLineWidth(1.0)
        
        drawCircle(x: 177, y: 134, r: 166, in: context)
        drawCircle(x: 208, y: 98, r: 167, in: context)
        drawCircle(x: 117, y: 58, r: 173, in: context)
        drawCircle(x: 115, y: 205, r: 174, in: context)
        drawCircle(x: -55, y: 101, r: 174, in: context)
        drawCircle(x: -61, y: 98, r: 177, in: context)
        drawCircle(x: 146, y: 30, r: 177, in: context)
        drawCircle(x: 258, y: 81, r: 183, in: context)
        drawCircle(x: 177, y: -10, r: 183, in: context)
        drawCircle(x: 139, y: 149, r: 183, in: context)
        drawCircle(x: -50, y: 107, r: 183, in: context)
        drawCircle(x: 198, y: 108, r: 185, in: context)
        drawCircle(x: 27, y: 152, r: 189, in: context)
        drawCircle(x: 162, y: 58, r: 193, in: context)
        drawCircle(x: 113, y: 234, r: 195, in: context)
        drawCircle(x: 115, y: 222, r: 196, in: context)
        drawCircle(x: 276, y: 71, r: 196, in: context)
        drawCircle(x: 121, y: 189, r: 198, in: context)
        drawCircle(x: -22, y: 159, r: 199, in: context)
        drawCircle(x: -50, y: 101, r: 200, in: context)
        drawCircle(x: 106, y: 170, r: 202, in: context)
        drawCircle(x: 177, y: 60, r: 206, in: context)
        drawCircle(x: -21, y: 140, r: 208, in: context)
        drawCircle(x: 274, y: 67, r: 211, in: context)
        drawCircle(x: 281, y: 63, r: 211, in: context)
        drawCircle(x: -2, y: 190, r: 213, in: context)
        drawCircle(x: 190, y: -33, r: 216, in: context)
        drawCircle(x: 174, y: -44, r: 216, in: context)
        drawCircle(x: 279, y: 82, r: 217, in: context)
        drawCircle(x: 16, y: 154, r: 217, in: context)
        drawCircle(x: 216, y: 132, r: 217, in: context)
        drawCircle(x: 144, y: 85, r: 218, in: context)
        drawCircle(x: 153, y: 7, r: 219, in: context)
        drawCircle(x: 21, y: 168, r: 220, in: context)
        drawCircle(x: 100, y: -85, r: 227, in: context)
        drawCircle(x: 231, y: 154, r: 228, in: context)
        drawCircle(x: 56, y: 219, r: 229, in: context)
        drawCircle(x: 97, y: 294, r: 230, in: context)
        drawCircle(x: -60, y: 133, r: 231, in: context)
        drawCircle(x: 107, y: -14, r: 232, in: context)
        drawCircle(x: 187, y: 44, r: 232, in: context)
        drawCircle(x: -89, y: 107, r: 235, in: context)
        drawCircle(x: -89, y: 100, r: 235, in: context)
        drawCircle(x: 105, y: 284, r: 237, in: context)
        drawCircle(x: 256, y: 35, r: 237, in: context)
        drawCircle(x: -26, y: 163, r: 238, in: context)
        drawCircle(x: 38, y: 122, r: 238, in: context)
        drawCircle(x: -71, y: 72, r: 240, in: context)
        drawCircle(x: -83, y: 99, r: 241, in: context)
        drawCircle(x: 181, y: -16, r: 242, in: context)
        drawCircle(x: 102, y: 173, r: 247, in: context)
        drawCircle(x: 203, y: 192, r: 251, in: context)
        drawCircle(x: 299, y: 48, r: 252, in: context)
        drawCircle(x: 252, y: -5, r: 255, in: context)
        drawCircle(x: 276, y: 108, r: 257, in: context)
        drawCircle(x: 293, y: 107, r: 258, in: context)
        drawCircle(x: 120, y: 225, r: 258, in: context)
        drawCircle(x: 35, y: 275, r: 259, in: context)
        drawCircle(x: 272, y: 147, r: 261, in: context)
        drawCircle(x: 232, y: -40, r: 262, in: context)
        drawCircle(x: 210, y: 88, r: 262, in: context)
        drawCircle(x: 290, y: 20, r: 268, in: context)
        drawCircle(x: 134, y: 245, r: 269, in: context)
        drawCircle(x: 25, y: 165, r: 269, in: context)
        drawCircle(x: 156, y: 163, r: 269, in: context)
        drawCircle(x: 252, y: 37, r: 271, in: context)
        drawCircle(x: -80, y: 161, r: 272, in: context)
        drawCircle(x: -27, y: 97, r: 273, in: context)
        drawCircle(x: 218, y: 216, r: 275, in: context)
        drawCircle(x: 27, y: 80, r: 276, in: context)
        drawCircle(x: 154, y: 136, r: 277, in: context)
        drawCircle(x: 170, y: 103, r: 277, in: context)
        drawCircle(x: 57, y: 112, r: 278, in: context)
        drawCircle(x: 82, y: 247, r: 279, in: context)
        drawCircle(x: 288, y: 16, r: 280, in: context)
        drawCircle(x: 363, y: 73, r: 280, in: context)
        drawCircle(x: 100, y: -65, r: 284, in: context)
        drawCircle(x: 364, y: 71, r: 284, in: context)
        drawCircle(x: 110, y: 223, r: 285, in: context)
        drawCircle(x: -2, y: 90, r: 285, in: context)
        drawCircle(x: -82, y: 162, r: 285, in: context)
        drawCircle(x: 148, y: 180, r: 289, in: context)
        drawCircle(x: 184, y: 113, r: 290, in: context)
        drawCircle(x: 152, y: -89, r: 290, in: context)
        drawCircle(x: 297, y: 38, r: 292, in: context)
        drawCircle(x: -43, y: 96, r: 292, in: context)
        drawCircle(x: 372, y: 72, r: 293, in: context)
        drawCircle(x: 214, y: -37, r: 295, in: context)
        drawCircle(x: 308, y: 148, r: 303, in: context)
        drawCircle(x: 279, y: 181, r: 306, in: context)
        drawCircle(x: 131, y: 309, r: 309, in: context)
        drawCircle(x: 234, y: 66, r: 311, in: context)
        drawCircle(x: -30, y: 235, r: 311, in: context)
        drawCircle(x: 357, y: 59, r: 311, in: context)
        drawCircle(x: 264, y: 152, r: 316, in: context)
        drawCircle(x: 276, y: 145, r: 318, in: context)
        drawCircle(x: 113, y: 57, r: 318, in: context)
        drawCircle(x: 299, y: 179, r: 320, in: context)
        drawCircle(x: 100, y: -1, r: 322, in: context)
        drawCircle(x: 150, y: 21, r: 324, in: context)
        drawCircle(x: 131, y: 338, r: 324, in: context)
        drawCircle(x: 119, y: 277, r: 327, in: context)
        drawCircle(x: 402, y: 67, r: 327, in: context)
        drawCircle(x: -88, y: 72, r: 192, in: context)
        drawCircle(x: -105, y: 73, r: 218, in: context)
        drawCircle(x: 119, y: -104, r: 261, in: context)
        drawCircle(x: -105, y: 164, r: 287, in: context)
        drawCircle(x: -99, y: 169, r: 289, in: context)
        drawCircle(x: -133, y: 95, r: 293, in: context)
        drawCircle(x: -109, y: 98, r: 327, in: context)
        drawCircle(x: -159, y: 83, r: 264, in: context)
        drawCircle(x: -150, y: 70, r: 276, in: context)
        drawCircle(x: -175, y: 71, r: 279, in: context)
        drawCircle(x: -165, y: 81, r: 284, in: context)
        drawCircle(x: -173, y: 71, r: 306, in: context)
        drawCircle(x: -209, y: 81, r: 312, in: context)
        drawCircle(x: -183, y: 72, r: 282, in: context)
        drawCircle(x: -197, y: 71, r: 301, in: context)
        
        context.beginPath()
        context.addRect(CGRect(x: Int(center.x) + 83, y: Int(center.y) + 66, width: 154, height: 210))
        context.setStrokeColor(red: 0, green: 1, blue: 1, alpha: 1)
        context.setLineWidth(1.0)
        context.strokePath()
    }

    fileprivate func drawXZ(_ context: CGContext) {
        context.setStrokeColor(red: 0, green: 1, blue: 0, alpha: 1)
        context.setLineWidth(1.0)

        drawCircle(x: 177, y: 90, r: 166, in: context)
        drawCircle(x: 208, y: 86, r: 167, in: context)
        drawCircle(x: 117, y: 241, r: 173, in: context)
        drawCircle(x: 115, y: 133, r: 174, in: context)
        drawCircle(x: -55, y: 109, r: 174, in: context)
        drawCircle(x: -61, y: 109, r: 177, in: context)
        drawCircle(x: 146, y: 188, r: 177, in: context)
        drawCircle(x: 258, y: 103, r: 183, in: context)
        drawCircle(x: 177, y: 122, r: 183, in: context)
        drawCircle(x: 139, y: 174, r: 183, in: context)
        drawCircle(x: -50, y: 125, r: 183, in: context)
        drawCircle(x: 198, y: 68, r: 185, in: context)
        drawCircle(x: 27, y: 163, r: 189, in: context)
        drawCircle(x: 162, y: 215, r: 193, in: context)
        drawCircle(x: 113, y: 98, r: 195, in: context)
        drawCircle(x: 115, y: 87, r: 196, in: context)
        drawCircle(x: 276, y: 108, r: 196, in: context)
        drawCircle(x: 121, y: 58, r: 198, in: context)
        drawCircle(x: -22, y: 117, r: 199, in: context)
        drawCircle(x: -50, y: 146, r: 200, in: context)
        drawCircle(x: 106, y: 206, r: 202, in: context)
        drawCircle(x: 177, y: 215, r: 206, in: context)
        drawCircle(x: -21, y: 145, r: 208, in: context)
        drawCircle(x: 274, y: 130, r: 211, in: context)
        drawCircle(x: 281, y: 120, r: 211, in: context)
        drawCircle(x: -2, y: 106, r: 213, in: context)
        drawCircle(x: 190, y: 118, r: 216, in: context)
        drawCircle(x: 174, y: 123, r: 216, in: context)
        drawCircle(x: 279, y: 90, r: 217, in: context)
        drawCircle(x: 16, y: 178, r: 217, in: context)
        drawCircle(x: 216, y: 77, r: 217, in: context)
        drawCircle(x: 144, y: -42, r: 218, in: context)
        drawCircle(x: 153, y: 199, r: 219, in: context)
        drawCircle(x: 21, y: 172, r: 220, in: context)
        drawCircle(x: 100, y: 169, r: 227, in: context)
        drawCircle(x: 231, y: 103, r: 228, in: context)
        drawCircle(x: 56, y: 166, r: 229, in: context)
        drawCircle(x: 97, y: 107, r: 230, in: context)
        drawCircle(x: -60, y: 136, r: 231, in: context)
        drawCircle(x: 107, y: 237, r: 232, in: context)
        drawCircle(x: 187, y: 216, r: 232, in: context)
        drawCircle(x: -89, y: 136, r: 235, in: context)
        drawCircle(x: -89, y: 144, r: 235, in: context)
        drawCircle(x: 105, y: 98, r: 237, in: context)
        drawCircle(x: 256, y: 144, r: 237, in: context)
        drawCircle(x: -26, y: 146, r: 238, in: context)
        drawCircle(x: 38, y: 254, r: 238, in: context)
        drawCircle(x: -71, y: 186, r: 240, in: context)
        drawCircle(x: -83, y: 156, r: 241, in: context)
        drawCircle(x: 181, y: 171, r: 242, in: context)
        drawCircle(x: 102, y: -25, r: 247, in: context)
        drawCircle(x: 203, y: 89, r: 251, in: context)
        drawCircle(x: 299, y: 128, r: 252, in: context)
        drawCircle(x: 252, y: 124, r: 255, in: context)
        drawCircle(x: 276, y: 153, r: 257, in: context)
        drawCircle(x: 293, y: 88, r: 258, in: context)
        drawCircle(x: 120, y: 32, r: 258, in: context)
        drawCircle(x: 35, y: 118, r: 259, in: context)
        drawCircle(x: 272, y: 103, r: 261, in: context)
        drawCircle(x: 232, y: 109, r: 262, in: context)
        drawCircle(x: 210, y: -18, r: 262, in: context)
        drawCircle(x: 290, y: 125, r: 268, in: context)
        drawCircle(x: 134, y: 56, r: 269, in: context)
        drawCircle(x: 25, y: 228, r: 269, in: context)
        drawCircle(x: 156, y: -4, r: 269, in: context)
        drawCircle(x: 252, y: 183, r: 271, in: context)
        drawCircle(x: -80, y: 129, r: 272, in: context)
        drawCircle(x: -27, y: 247, r: 273, in: context)
        drawCircle(x: 218, y: 120, r: 275, in: context)
        drawCircle(x: 27, y: 322, r: 276, in: context)
        drawCircle(x: 154, y: 265, r: 277, in: context)
        drawCircle(x: 170, y: -57, r: 277, in: context)
        drawCircle(x: 57, y: 322, r: 278, in: context)
        drawCircle(x: 82, y: 213, r: 279, in: context)
        drawCircle(x: 288, y: 134, r: 280, in: context)
        drawCircle(x: 363, y: 116, r: 280, in: context)
        drawCircle(x: 100, y: 245, r: 284, in: context)
        drawCircle(x: 364, y: 106, r: 284, in: context)
        drawCircle(x: 110, y: -5, r: 285, in: context)
        drawCircle(x: -2, y: 292, r: 285, in: context)
        drawCircle(x: -82, y: 139, r: 285, in: context)
        drawCircle(x: 148, y: -13, r: 289, in: context)
        drawCircle(x: 184, y: -45, r: 290, in: context)
        drawCircle(x: 152, y: 175, r: 290, in: context)
        drawCircle(x: 297, y: 160, r: 292, in: context)
        drawCircle(x: -43, y: 251, r: 292, in: context)
        drawCircle(x: 372, y: 105, r: 293, in: context)
        drawCircle(x: 214, y: 170, r: 295, in: context)
        drawCircle(x: 308, y: 99, r: 303, in: context)
        drawCircle(x: 279, y: 101, r: 306, in: context)
        drawCircle(x: 131, y: 76, r: 309, in: context)
        drawCircle(x: 234, y: 270, r: 311, in: context)
        drawCircle(x: -30, y: 144, r: 311, in: context)
        drawCircle(x: 357, y: 140, r: 311, in: context)
        drawCircle(x: 264, y: 180, r: 316, in: context)
        drawCircle(x: 276, y: 48, r: 318, in: context)
        drawCircle(x: 113, y: 390, r: 318, in: context)
        drawCircle(x: 299, y: 104, r: 320, in: context)
        drawCircle(x: 100, y: 347, r: 322, in: context)
        drawCircle(x: 150, y: 321, r: 324, in: context)
        drawCircle(x: 131, y: 90, r: 324, in: context)
        drawCircle(x: 119, y: 15, r: 327, in: context)
        drawCircle(x: 402, y: 118, r: 327, in: context)
        drawCircle(x: -88, y: 122, r: 192, in: context)
        drawCircle(x: -105, y: 132, r: 218, in: context)
        drawCircle(x: 119, y: 163, r: 261, in: context)
        drawCircle(x: -105, y: 109, r: 287, in: context)
        drawCircle(x: -99, y: 106, r: 289, in: context)
        drawCircle(x: -133, y: 163, r: 293, in: context)
        drawCircle(x: -109, y: 219, r: 327, in: context)
        drawCircle(x: -159, y: 120, r: 264, in: context)
        drawCircle(x: -150, y: 142, r: 276, in: context)
        drawCircle(x: -175, y: 121, r: 279, in: context)
        drawCircle(x: -165, y: 136, r: 284, in: context)
        drawCircle(x: -173, y: 151, r: 306, in: context)
        drawCircle(x: -209, y: 121, r: 312, in: context)
        drawCircle(x: -183, y: 117, r: 282, in: context)
        drawCircle(x: -197, y: 121, r: 301, in: context)
        context.beginPath()
        context.addRect(CGRect(x: Int(center.x) + 66, y: Int(center.y) + 102, width: 154, height: 210))
        context.setStrokeColor(red: 0, green: 1, blue: 1, alpha: 1)
        context.setLineWidth(1.0)
        context.strokePath()
    }

    fileprivate func drawYZ(_ context: CGContext) {
        context.setStrokeColor(red: 1, green: 0, blue: 1, alpha: 1)
        context.setLineWidth(1.0)
        
        drawCircle(x: 134, y: 90, r: 166, in: context)
        drawCircle(x: 98, y: 86, r: 167, in: context)
        drawCircle(x: 58, y: 241, r: 173, in: context)
        drawCircle(x: 205, y: 133, r: 174, in: context)
        drawCircle(x: 101, y: 109, r: 174, in: context)
        drawCircle(x: 98, y: 109, r: 177, in: context)
        drawCircle(x: 30, y: 188, r: 177, in: context)
        drawCircle(x: 81, y: 103, r: 183, in: context)
        drawCircle(x: -10, y: 122, r: 183, in: context)
        drawCircle(x: 149, y: 174, r: 183, in: context)
        drawCircle(x: 107, y: 125, r: 183, in: context)
        drawCircle(x: 108, y: 68, r: 185, in: context)
        drawCircle(x: 152, y: 163, r: 189, in: context)
        drawCircle(x: 58, y: 215, r: 193, in: context)
        drawCircle(x: 234, y: 98, r: 195, in: context)
        drawCircle(x: 222, y: 87, r: 196, in: context)
        drawCircle(x: 71, y: 108, r: 196, in: context)
        drawCircle(x: 189, y: 58, r: 198, in: context)
        drawCircle(x: 159, y: 117, r: 199, in: context)
        drawCircle(x: 101, y: 146, r: 200, in: context)
        drawCircle(x: 170, y: 206, r: 202, in: context)
        drawCircle(x: 60, y: 215, r: 206, in: context)
        drawCircle(x: 140, y: 145, r: 208, in: context)
        drawCircle(x: 67, y: 130, r: 211, in: context)
        drawCircle(x: 63, y: 120, r: 211, in: context)
        drawCircle(x: 190, y: 106, r: 213, in: context)
        drawCircle(x: -33, y: 118, r: 216, in: context)
        drawCircle(x: -44, y: 123, r: 216, in: context)
        drawCircle(x: 82, y: 90, r: 217, in: context)
        drawCircle(x: 154, y: 178, r: 217, in: context)
        drawCircle(x: 132, y: 77, r: 217, in: context)
        drawCircle(x: 85, y: -42, r: 218, in: context)
        drawCircle(x: 7, y: 199, r: 219, in: context)
        drawCircle(x: 168, y: 172, r: 220, in: context)
        drawCircle(x: -85, y: 169, r: 227, in: context)
        drawCircle(x: 154, y: 103, r: 228, in: context)
        drawCircle(x: 219, y: 166, r: 229, in: context)
        drawCircle(x: 294, y: 107, r: 230, in: context)
        drawCircle(x: 133, y: 136, r: 231, in: context)
        drawCircle(x: -14, y: 237, r: 232, in: context)
        drawCircle(x: 44, y: 216, r: 232, in: context)
        drawCircle(x: 107, y: 136, r: 235, in: context)
        drawCircle(x: 100, y: 144, r: 235, in: context)
        drawCircle(x: 284, y: 98, r: 237, in: context)
        drawCircle(x: 35, y: 144, r: 237, in: context)
        drawCircle(x: 163, y: 146, r: 238, in: context)
        drawCircle(x: 122, y: 254, r: 238, in: context)
        drawCircle(x: 72, y: 186, r: 240, in: context)
        drawCircle(x: 99, y: 156, r: 241, in: context)
        drawCircle(x: -16, y: 171, r: 242, in: context)
        drawCircle(x: 173, y: -25, r: 247, in: context)
        drawCircle(x: 192, y: 89, r: 251, in: context)
        drawCircle(x: 48, y: 128, r: 252, in: context)
        drawCircle(x: -5, y: 124, r: 255, in: context)
        drawCircle(x: 108, y: 153, r: 257, in: context)
        drawCircle(x: 107, y: 88, r: 258, in: context)
        drawCircle(x: 225, y: 32, r: 258, in: context)
        drawCircle(x: 275, y: 118, r: 259, in: context)
        drawCircle(x: 147, y: 103, r: 261, in: context)
        drawCircle(x: -40, y: 109, r: 262, in: context)
        drawCircle(x: 88, y: -18, r: 262, in: context)
        drawCircle(x: 20, y: 125, r: 268, in: context)
        drawCircle(x: 245, y: 56, r: 269, in: context)
        drawCircle(x: 165, y: 228, r: 269, in: context)
        drawCircle(x: 163, y: -4, r: 269, in: context)
        drawCircle(x: 37, y: 183, r: 271, in: context)
        drawCircle(x: 161, y: 129, r: 272, in: context)
        drawCircle(x: 97, y: 247, r: 273, in: context)
        drawCircle(x: 216, y: 120, r: 275, in: context)
        drawCircle(x: 80, y: 322, r: 276, in: context)
        drawCircle(x: 136, y: 265, r: 277, in: context)
        drawCircle(x: 103, y: -57, r: 277, in: context)
        drawCircle(x: 112, y: 322, r: 278, in: context)
        drawCircle(x: 247, y: 213, r: 279, in: context)
        drawCircle(x: 16, y: 134, r: 280, in: context)
        drawCircle(x: 73, y: 116, r: 280, in: context)
        drawCircle(x: -65, y: 245, r: 284, in: context)
        drawCircle(x: 71, y: 106, r: 284, in: context)
        drawCircle(x: 223, y: -5, r: 285, in: context)
        drawCircle(x: 90, y: 292, r: 285, in: context)
        drawCircle(x: 162, y: 139, r: 285, in: context)
        drawCircle(x: 180, y: -13, r: 289, in: context)
        drawCircle(x: 113, y: -45, r: 290, in: context)
        drawCircle(x: -89, y: 175, r: 290, in: context)
        drawCircle(x: 38, y: 160, r: 292, in: context)
        drawCircle(x: 96, y: 251, r: 292, in: context)
        drawCircle(x: 72, y: 105, r: 293, in: context)
        drawCircle(x: -37, y: 170, r: 295, in: context)
        drawCircle(x: 148, y: 99, r: 303, in: context)
        drawCircle(x: 181, y: 101, r: 306, in: context)
        drawCircle(x: 309, y: 76, r: 309, in: context)
        drawCircle(x: 66, y: 270, r: 311, in: context)
        drawCircle(x: 235, y: 144, r: 311, in: context)
        drawCircle(x: 59, y: 140, r: 311, in: context)
        drawCircle(x: 152, y: 180, r: 316, in: context)
        drawCircle(x: 145, y: 48, r: 318, in: context)
        drawCircle(x: 57, y: 390, r: 318, in: context)
        drawCircle(x: 179, y: 104, r: 320, in: context)
        drawCircle(x: -1, y: 347, r: 322, in: context)
        drawCircle(x: 21, y: 321, r: 324, in: context)
        drawCircle(x: 338, y: 90, r: 324, in: context)
        drawCircle(x: 277, y: 15, r: 327, in: context)
        drawCircle(x: 67, y: 118, r: 327, in: context)
        drawCircle(x: 72, y: 122, r: 192, in: context)
        drawCircle(x: 73, y: 132, r: 218, in: context)
        drawCircle(x: -104, y: 163, r: 261, in: context)
        drawCircle(x: 164, y: 109, r: 287, in: context)
        drawCircle(x: 169, y: 106, r: 289, in: context)
        drawCircle(x: 95, y: 163, r: 293, in: context)
        drawCircle(x: 98, y: 219, r: 327, in: context)
        drawCircle(x: 83, y: 120, r: 264, in: context)
        drawCircle(x: 70, y: 142, r: 276, in: context)
        drawCircle(x: 71, y: 121, r: 279, in: context)
        drawCircle(x: 81, y: 136, r: 284, in: context)
        drawCircle(x: 71, y: 151, r: 306, in: context)
        drawCircle(x: 81, y: 121, r: 312, in: context)
        drawCircle(x: 72, y: 117, r: 282, in: context)
        drawCircle(x: 71, y: 121, r: 301, in: context)

        context.beginPath()
        context.addRect(CGRect(x: Int(center.x) + 66, y: Int(center.y) + 102, width: 210, height: 210))
        context.setStrokeColor(red: 0, green: 1, blue: 1, alpha: 1)
        context.setLineWidth(1.0)
        context.strokePath()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let context = NSGraphicsContext.current?.cgContext {
            center = CGPoint(x: (dirtyRect.minX + dirtyRect.maxX) / 2, y: ((dirtyRect.minY + dirtyRect.maxY) / 2) - 150)
            
            switch type {
            case .xy:
                drawXY(context)
            case .xz:
                drawXZ(context)
            case .yz:
                drawYZ(context)
            }
            context.beginPath()
            context.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
            context.setLineWidth(1.0)
            context.move(to: center)
            context.addLine(to: CGPoint(x: Int(center.x) + 800 , y: Int(center.y)))
            context.move(to: CGPoint(x: Int(center.x) + 770 , y: Int(center.y) - 20))
            context.addLine(to: CGPoint(x: Int(center.x) + 800 , y: Int(center.y)))
            context.move(to: CGPoint(x: Int(center.x) + 770 , y: Int(center.y) + 20))
            context.addLine(to: CGPoint(x: Int(center.x) + 800 , y: Int(center.y)))
            context.move(to: center)
            context.addLine(to: CGPoint(x: Int(center.x), y: Int(center.y) + 700))
            context.move(to: CGPoint(x: Int(center.x) - 20 , y: Int(center.y) + 670))
            context.addLine(to: CGPoint(x: Int(center.x), y: Int(center.y) + 700))
            context.move(to: CGPoint(x: Int(center.x) + 20 , y: Int(center.y) + 670))
            context.addLine(to: CGPoint(x: Int(center.x), y: Int(center.y) + 700))
            context.strokePath()
        }
    }
    
    func drawCircle(x: Int, y: Int, r: Int, in context: CGContext) {
        context.beginPath()
//        context.move(to: CGPoint(x: Int(center.x) + x + r , y: Int(center.y) + y))
//        context.addArc(center: CGPoint(x: Int(center.x) + x, y: Int(center.y) + y), radius: CGFloat(r), startAngle: 0, endAngle: 2 * 3.1415927, clockwise: true)
        context.move(to:    CGPoint(x: Int(center.x) + x + r , y: Int(center.y) + y))
        context.addLine(to: CGPoint(x: Int(center.x) + x , y: Int(center.y) + y + r))
        context.addLine(to: CGPoint(x: Int(center.x) + x - r, y: Int(center.y) + y))

        context.addLine(to: CGPoint(x: Int(center.x) + x , y: Int(center.y) + y - r))

        context.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context.addLine(to: CGPoint(x: Int(center.x) + x + r, y: Int(center.y) + y))
        context.strokePath()

        context.beginPath()
        context.move(to: CGPoint(x: Int(center.x) + x - r, y: Int(center.y) + y))
        context.setStrokeColor(red: 1, green: 0, blue: 1, alpha: 1)
        context.addLine(to: CGPoint(x: Int(center.x) + x , y: Int(center.y) + y - r))
        context.strokePath()

    }
}
