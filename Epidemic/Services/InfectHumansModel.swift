//
//  InfectHumansModel.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 10.05.2023.
//

import Foundation

class InfectHumansModel {
    let humans: Int
    var humansMatrix: [[Int]] = [[]]
    var suddenlyInfected: [Point] = []
    var infected: Int = 0
    var healthy: Int
    
    init(humans: Int) {
        self.humans = humans
        let edge = self.humans % 6 > 0 ? self.humans / 6 + 1 : self.humans / 6
        humansMatrix = Array(repeating: Array(repeating: 0, count: 6), count: edge)
        healthy = humans
        fillWithHumans(edge: edge)
    }
    
    func fillWithHumans(edge: Int) {
        var count = 0
        for i in 0...(edge - 1) {
            for j in 0...5 {
                count += 1
                if count > self.humans {
                    humansMatrix[i][j] = 2
                }
            }
        }
    }
    
    func updateModel(index: Int) {
        let i = index / 6
        let j = index % 6
        updateModel(i: i, j: j)
    }
    
    func extractSuddenlyInfected() -> [Point] {
        let result = suddenlyInfected
        suddenlyInfected = []
        return result
    }
    
    func updateAfterImitation(newPoints: [Point]) {
        for point in newPoints {
            if humansMatrix[point.x][point.y] == 0 {
                humansMatrix[point.x][point.y] = 1
                healthy -= 1
                infected += 1
            }
        }
    }
    
    func updateModel(i: Int, j: Int) {
        if humansMatrix[i][j] == 0 {
            humansMatrix[i][j] = 1
            suddenlyInfected.append(Point(x: i,y: j))
            healthy -= 1
            infected += 1
        }
    }
    
    func getCellValue(index: Int) -> TypeOfPeople {
        let i = index / 6
        let j = index % 6
        return getCellValue(i: i, j: j)
    }
    
    func getCellValue(i: Int, j: Int) -> TypeOfPeople {
        let state = humansMatrix[i][j]
        switch state {
        case 0:
            return .healthy
        case 1:
            return .sick
        default:
            return .invisible
        }
    }
    
}
