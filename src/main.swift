import Foundation

func readLineTrimmed() -> String {
    if let s = readLine() {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    return ""
}

func readMatrix(size: Int) -> [[Int]] {
    var matrix: [[Int]] = []
    for _ in 0..<size {
        let inputLine = readLineTrimmed()
        let row = inputLine
            .split(separator: " ")
            .compactMap { Int($0) }
        matrix.append(row)
    }
    return matrix
}

func main() {
    print("=== TSP Solver ===")
    print("Solve the Traveling Salesman Problem effortlessly.")
    
    while true {
        print()
        print("Please choose how to provide input:")
        print("[1] Enter distances manually")
        print("[2] Load distances from a file")
        print("[0] Exit program")
        print("→ ", terminator: "")
        let choice = readLineTrimmed()
        
        var cityCount: Int = 0
        var distMatrix: [[Int]] = []
        
        if choice == "0" {
            print("Thank you for using TSP Solver. Goodbye!")
            exit(0)
        }
        else if choice == "1" {
            print("Enter the number of cities:")
            print("→ ", terminator: "")
            if let count = Int(readLineTrimmed()) {
                cityCount = count
            } else {
                print("Invalid input. Please enter a valid integer.")
                continue
            }
            print("Now, enter each row of the distance matrix (space-separated integers):")
            distMatrix = readMatrix(size: cityCount)
        }
        else if choice == "2" {
            print("Enter the filename (from the \"test/\" directory, e.g., distances.txt):")
            print("→ ", terminator: "")
            let filenameInput = readLineTrimmed()
            let filePath = "test/\(filenameInput)"
            guard let fileContent = try? String(contentsOfFile: filePath, encoding: .utf8) else {
                print("Could not read the file. Please check the filename and try again.")
                continue
            }
            let lines = fileContent
                .split(separator: "\n", omittingEmptySubsequences: true)
                .map { String($0) }
            guard let firstLine = lines.first, let count = Int(firstLine) else {
                print("File format error: first line must be the number of cities.")
                continue
            }
            cityCount = count
            distMatrix = lines
                .dropFirst()
                .map { row in
                    row
                        .split(separator: " ")
                        .compactMap { Int($0) }
                }
            if distMatrix.count != cityCount {
                print("Error: the number of matrix rows (\(distMatrix.count)) does not match the city count (\(cityCount)).")
                continue
            }
        }
        else {
            print("Unrecognized option. Please select 0, 1, or 2.")
            continue
        }
        
        print()
        print("Number of cities: \(cityCount)")
        print("Distance matrix:")
        for row in distMatrix {
            print(row.map { String($0) }.joined(separator: " "))
        }
        print()
        
        print("Computing the optimal TSP route…")
        let startTime = DispatchTime.now()
        TSP.initialize(n: cityCount)
        let bestCost = TSP.solve(pos: 0, visited: 1, dist: distMatrix)
        let bestTour = TSP.reconstructPath(start: 0, visited: 1)
        let endTime = DispatchTime.now()
        let elapsedMs = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
        let formattedTime = String(format: "%.3f", elapsedMs)
        
        print()
        print("Optimal route found with cost: \(bestCost)")
        print("Route sequence: \(bestTour.map { String($0) }.joined(separator: " → "))")
        print("Calculation time: \(formattedTime) ms")
        
        while true {
            print()
            print("Would you like to save the results to a file? (y/n)")
            print("→ ", terminator: "")
            let saveInput = readLineTrimmed().lowercased()
            if saveInput == "y" {
                print("Enter an output filename (e.g., result.txt):")
                print("→ ", terminator: "")
                let outName = readLineTrimmed()
                let outPath = "test/\(outName)"
                
                var fileLines: [String] = []
                fileLines.append("Number of cities: \(cityCount)")
                fileLines.append("Distance matrix:")
                for row in distMatrix {
                    fileLines.append(row.map { String($0) }.joined(separator: " "))
                }
                fileLines.append("")
                fileLines.append("Optimal route cost: \(bestCost)")
                fileLines.append("Route: \(bestTour.map { String($0) }.joined(separator: " → "))")
                fileLines.append("Calculation time: \(formattedTime) ms")
                
                let outputData = fileLines.joined(separator: "\n")
                
                do {
                    try outputData.write(toFile: outPath, atomically: true, encoding: .utf8)
                    print("Results successfully saved to \"\(outPath)\".")
                } catch {
                    print("Error writing to file: \(error.localizedDescription)")
                }
                break
            }
            else if saveInput == "n" {
                break
            }
            else {
                print("Invalid choice. Please type 'y' or 'n'.")
            }
        }
        
        while true {
            print()
            print("Do you want to solve another TSP instance? (y/n)")
            print("→ ", terminator: "")
            let againInput = readLineTrimmed().lowercased()
            if againInput == "y" {
                break
            }
            else if againInput == "n" {
                print()
                print("Thank you for using TSP Solver. Farewell!")
                exit(0)
            }
            else {
                print("Invalid response. Please answer 'y' or 'n'.")
            }
        }
    }
}

main()
