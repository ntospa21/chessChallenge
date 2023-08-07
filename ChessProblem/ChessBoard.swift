//
//  ChessProblemApp.swift
//  ChessProblem
//
//  Created by Pantos, Thomas on 6/8/23.
//

import SwiftUI




struct Checkerboard: View {
    let rows: Int
    let columns: Int
    
    @State private var startingPoint: Point? = nil
    @State private var endingPoint: Point? = nil
    @State private var nextPossibleMoves: Set<Point> = []
    @State private var isEndingPointReachable = false
    @State var showAlert = false
    @State private var path: [Point] = []

    
    
    var body: some View {
        VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<columns, id: \.self) { column in
                            Rectangle()
                                .fill((row + column).isMultiple(of: 2) ? Color.white : Color.black)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    GeometryReader { innerGeometry in
                                        if let startPoint = startingPoint, startPoint == Point(x: row, y: column) {
                                            Knight()
                                                .position(x: innerGeometry.frame(in: .local).midX, y: innerGeometry.frame(in: .local).midY)
                                        } else if endingPoint == Point(x: row, y: column) {
                                            Circle()
                                                .fill(Color.blue)
                                                .frame(width: 30, height: 30)
                                                .position(x: innerGeometry.frame(in: .local).midX, y: innerGeometry.frame(in: .local).midY)
                                        } else if isEndingPointReachable {
                                            let cellPoint = Point(x: row, y: column)
                                            if nextPossibleMoves.contains(cellPoint) {
                                                Circle()
                                                    .fill(nextPossibleMoves.contains(cellPoint) ? Color.yellow : Color.green.opacity(0.5))
                                                    .frame(width: 30, height: 30)
                                                    .position(x: innerGeometry.frame(in: .local).midX, y: innerGeometry.frame(in: .local).midY)
                                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                                            }
                                        }
                                    }
                                
                                       )
                                  .onTapGesture {
                                handleTap(row: row, col: column)
                                
                            }
                    }
                }
            }
        }
        HStack{
            Button("reset"){
                resetChessBoard()
            }
            Button("Find Path") {
                findPath()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ending Point Unreachable"), message: Text("The ending point cannot be reached in 3 moves."), dismissButton: .default(Text("OK")))
            }
            
        }

    }
    
    func handleTap(row: Int, col: Int) {
           if startingPoint == nil {
               startingPoint = Point(x: row, y: col)
               nextPossibleMoves = calculateNextPossibleMoves(from: Point(x: row, y: col))
           } else if endingPoint == nil {
               endingPoint = Point(x: row, y: col)
           } else {
               startingPoint = nil
               endingPoint = nil
               nextPossibleMoves = []
           }
       }
    
    private func calculateNextPossibleMoves(from point: Point) -> Set<Point> {
           let dx = [-2, -1, 1, 2, 2, 1, -1, -2]
           let dy = [1, 2, 2, 1, -1, -2, -2, -1]

           var possibleMoves = Set<Point>()

           for i in 0..<8 {
               let nextX = point.x + dx[i]
               let nextY = point.y + dy[i]
               let nextPoint = Point(x: nextX, y: nextY)

               if isValid(nextPoint) {
                   possibleMoves.insert(nextPoint)
               }
           }

           return possibleMoves
       }
    func findPath() {
        guard let startPoint = startingPoint, let endPoint = endingPoint else {
            showAlert = true
            return
        }

        let minimumMoves = knightMoves(start: startPoint, end: endPoint)

        if minimumMoves != -1 && minimumMoves <= 3 {
            print("The minimum number of moves to reach the destination is \(minimumMoves).")
            isEndingPointReachable = true
            showAlert = false
        } else {
            showAlert = true
            isEndingPointReachable = false
        }
    }

    func isValid(_ point: Point) -> Bool {
        return point.x >= 0 && point.y >= 0 && point.x < 8 && point.y < 8
    }
    
    func knightMoves(start: Point, end: Point) -> Int {
        let dx = [-2, -1, 1, 2, 2, 1, -1, -2]
        let dy = [1, 2, 2, 1, -1, -2, -2, -1]
        
        var queue = [start]
        var visited = Set<Point>()
        var moves = 0
        
        while !queue.isEmpty {
            let count = queue.count
            
            for _ in 0..<count {
                let current = queue.removeFirst()
                
                if current == end {
                    return moves
                }
                
                for i in 0..<8 {
                    let nextX = current.x + dx[i]
                    let nextY = current.y + dy[i]
                    let nextPoint = Point(x: nextX, y: nextY)
                    
                    if isValid(nextPoint) && !visited.contains(nextPoint) {
                        visited.insert(nextPoint)
                        queue.append(nextPoint)
                    }
                }
            }
            
            moves += 1
        }
        
        return -1
    }
    
    func resetChessBoard() {
        startingPoint = nil
        endingPoint = nil
        nextPossibleMoves = []
        isEndingPointReachable = false
        showAlert = false
    }
    
}

struct Knight: View {
    var body: some View {
        Image(systemName: "person.fill")
            .foregroundColor(.red)
            .font(.system(size: 20))
    }
}
