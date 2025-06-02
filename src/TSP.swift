import Foundation

class TSP {
    static var visitedAll: Int = 0
    static var dp: [[Int]] = []
    static var path: [[Int?]] = []

    static func initialize(n: Int) {
        visitedAll = (1 << n) - 1
        dp = Array(
            repeating: Array(repeating: -1, count: 1 << n),
            count: n
        )
        path = Array(
            repeating: Array(repeating: nil, count: 1 << n),
            count: n
        )
    }

    static func solve(pos: Int, visited: Int, dist: [[Int]]) -> Int {
        if visited == visitedAll {
            return dist[pos][0]
        }
        if dp[pos][visited] != -1 {
            return dp[pos][visited]
        }

        let n = dist.count
        var minCost = Int.max
        for city in 0..<n {
            let bit = 1 << city
            if visited & bit == 0 {
                let costToNext = dist[pos][city]
                let newVisited = visited | bit
                let subCost = solve(pos: city, visited: newVisited, dist: dist)
                let totalCost = costToNext + subCost
                if totalCost < minCost {
                    minCost = totalCost
                    path[pos][visited] = city
                }
            }
        }
        dp[pos][visited] = minCost
        return minCost
    }

    static func reconstructPath(start: Int, visited: Int) -> [Int] {
        var tour: [Int] = [start]
        var current = start
        var mask = visited

        while let nextCity = path[current][mask] {
            tour.append(nextCity)
            mask |= (1 << nextCity)
            current = nextCity
        }
        tour.append(0)
        return tour
    }
}
