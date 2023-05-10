//
//  EpidemicService.swift
//  Epidemic
//
//  Created by Евгения Шарамет on 08.05.2023.
//

import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

class EpidemicService {
  //  var points = Set<Point>()
    let infectiousness: Int
    let time: Double
    var humans: [[Int]] = [[]]
    var effective: [Point] = []
    let count: Int
    
    init(count: Int, m_infectiousness: Int, time: Int) {
        self.count = count
        self.infectiousness = m_infectiousness
        self.time = time < 1 ? Double(0.25) : Double(time)
        let edge = self.count % 6 > 0 ? self.count / 6 + 1 : self.count / 6
        allocate(edge: edge)
        fillWithHumans(edge: edge)
    }
    
    func printMatrix() {
        for i in (0...humans.count - 1) {
            for j in (0...humans[i].count - 1) {
                print(humans[i][j], terminator: "")
            }
            print("")
        }
    }
    
    func update(position : Point) {
        let pos : Point = Point(x:position.x + 1, y: position.y + 1)
        humans[pos.x][pos.y] = 2
        effective.append(pos)
    }
    
    func next() -> Set<Point> {
        let start = DispatchTime.now()
        let result = run()
        let end = DispatchTime.now()
        let timeInterval = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / Double(NSEC_PER_SEC)
        let sleepTime = time - timeInterval
        if sleepTime > 0 {
            Thread.sleep(forTimeInterval: Double(sleepTime))
        }
        return result
    }
    
    
    func infect(position : Point) -> [Point] {
        let neighbours = [
            Point(x:position.x - 1, y:position.y - 1),
            Point(x:position.x - 1, y:position.y),
            Point(x:position.x - 1, y:position.y + 1),
            Point(x:position.x, y:position.y - 1),
            Point(x:position.x, y:position.y + 1),
            Point(x:position.x + 1, y:position.y - 1),
            Point(x:position.x + 1, y:position.y),
            Point(x:position.x + 1, y:position.y + 1)
        ]
        
        var possiblyInfected : [Point] = []
        for i in neighbours {
            if humans[i.x][i.y] == 0 {
                possiblyInfected.append(i)
            }
        }
        
        possiblyInfected.shuffle()
        
        if possiblyInfected.count < infectiousness {
            return possiblyInfected
        }
        
        return Array(possiblyInfected[..<infectiousness])
    }
    
    func run() -> Set<Point> {
        var newInfected : Set<Point> = []
        var oldInfected : [Point] = []
        
        for position in effective {
            let infected = infect(position: position)
            
            if !infected.isEmpty {
                oldInfected.append(position)
            }
            
            for i in infected {
                newInfected.insert(i)
            }
        }
        
        if newInfected.isEmpty {
            return []
        }
        
        for i in newInfected {
            humans[i.x][i.y] = 2;
            oldInfected.append(i)
        }
        
        effective = oldInfected
        
        return newInfected
    }
    
    func fillGridWithWrap(height: Int, width: Int) -> [[Int]] {
        var gridWithWrap = Array(repeating: Array(repeating: 2, count: width + 2), count: height + 2)
        
        for i in (0...height - 1) {
            for j in (0...width  - 1) {
                gridWithWrap[i + 1][j + 1] = 0
            }
        }
        return gridWithWrap
    }
    
    func allocate(edge: Int) {
        humans = fillGridWithWrap(height: edge, width: 6)
    }
    
    func fillWithHumans(edge: Int) {
        var count = 0
        for i in 0...(edge - 1) {
            for j in 0...5 {
                count += 1
                if count > self.count {
                    humans[i + 1][j + 1] = 2
                }
            }
        }
    }
}
