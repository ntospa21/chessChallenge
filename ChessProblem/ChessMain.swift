//
//  ChessMain.swift
//  ChessProblem
//
//  Created by Pantos, Thomas on 6/8/23.
//

import SwiftUI

struct ChessMain: View {
    var body: some View {
     
        VStack{
            Checkerboard(rows: 8, columns: 8)
           
        }
    }
    
   
}

struct ChessMain_Previews: PreviewProvider {
    static var previews: some View {
        ChessMain()
    }
}
