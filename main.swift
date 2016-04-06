//
//  main.swift
//  ShieldingCalculation
//
//  Created by ZHEXUAN ZHANG on 4/6/16.
//  Copyright © 2016 ZHEXUAN ZHANG. All rights reserved.
//

import Foundation

struct DiagnosticSecondaryAirKerma {
    var leakage: Double = 0
    var sideScatter: Double = 0
    var forwardBackscatter: Double = 0
    var leakageAndSideScatter: Double {
        return leakage + sideScatter
    }
    var leakageAndForwardBackscatter: Double {
        return leakage + forwardBackscatter
    }
}

let RadRoomAllBarrier = DiagnosticSecondaryAirKerma(leakage: 0.00054, sideScatter: 0.034, forwardBackscatter: 0.048)

let RadRoomChestBucky = DiagnosticSecondaryAirKerma(leakage: 0.00039, sideScatter: 0.0049, forwardBackscatter: 0.0069)

let RadRoomFloorOrOtherBarriers = DiagnosticSecondaryAirKerma(leakage: 0.00014, sideScatter: 0.023, forwardBackscatter: 0.033)

let FluoroscopyTube = DiagnosticSecondaryAirKerma(leakage: 0.012, sideScatter: 0.31, forwardBackscatter: 0.44)

let RadTube = DiagnosticSecondaryAirKerma(leakage: 0.00094, sideScatter: 0.028, forwardBackscatter: 0.039)

let ChestRoom = DiagnosticSecondaryAirKerma(leakage: 0.00038, sideScatter: 0.0023, forwardBackscatter: 0.0032)

let MammographyRoom = DiagnosticSecondaryAirKerma(leakage: 0.000011, sideScatter: 0.011, forwardBackscatter: 0.049)

let CardiacAngiography = DiagnosticSecondaryAirKerma(leakage: 0.088, sideScatter: 2.6, forwardBackscatter: 3.7)

let PeripheralAngiography = DiagnosticSecondaryAirKerma(leakage: 0.0034, sideScatter: 0.66, forwardBackscatter: 0.95)

let NotApplicableRoom = DiagnosticSecondaryAirKerma(leakage: 0, sideScatter: 0, forwardBackscatter: 0)



func controlledArea(controlledAreaOrNot: String) -> Double {
    var designGoal: Double = 0
    switch controlledAreaOrNot {
    case "Y":
        designGoal = 0.1
    case "y":
        designGoal = 0.1
    case "N":
        designGoal = 0.02
    case "n":
        designGoal = 0.02
    default:
        print("N/A")
    }
    return designGoal
}

func typeOfArea(area: Int) -> Double {
    // T = occupancy factor
    var T: Double = 0
    switch area {
    case 1:
        T = 1
    case 2:
        T = 0.5
    case 3:
        T = 0.2
    case 4:
        T = 0.125
    case 5:
        T = 0.05
    case 6:
        T = 0.025
    default:
        T = 0
    }
    return T
}


let shieldingRoomDictionary = [0: NotApplicableRoom, 1: RadRoomAllBarrier, 2: RadRoomChestBucky,
                               3: RadRoomFloorOrOtherBarriers, 4: FluoroscopyTube, 5: RadTube,
                               6: ChestRoom, 7: MammographyRoom, 8: CardiacAngiography,
                               9: PeripheralAngiography]

let shieldingRoomDictionaryText = [0: "N/A", 1: "Rad Room(All Barrier)", 2: "Rad Room(Chest Bucky)",
                               3: "Rad Room(Floor Or Other Barriers)", 4: "Fluoroscopy Tube", 5: "Rad Tube",
                               6: "Chest Room", 7: "Mammography Room", 8: "Cardiac Angiography",
                               9: "Peripheral Angiography"]


func secondaryShieldingCalc(shieldingRoomIndex room: Int, typeOfSecondaryRadiationIndex type: Int,
                                               isControlArea: String, locationIndex location: Int, patientsPerWeek ppw: Int,
                                               distance d: Double) -> Double {
    let rm = shieldingRoomDictionary[room]
    var Ks1: Double = 0
    switch type {
    case 1:
        Ks1 = rm!.leakage
    case 2:
        Ks1 = rm!.sideScatter
    case 3:
        Ks1 = rm!.leakageAndSideScatter
    case 4:
        Ks1 = rm!.forwardBackscatter
    case 5:
        Ks1 = rm!.leakageAndForwardBackscatter
    default:
        Ks1 = 0
    }
    let Ks0 = Double(ppw) * Ks1 / (d * d)
    let p = controlledArea(isControlArea)
    let T = typeOfArea(location)
    let B = p / T * (1 / Ks0)
    return B
}


// let example = secondaryShieldingCalc(shieldingRoomIndex: 8, typeOfSecondaryRadiationIndex: 3, isControlArea: 1, locationIndex: 1, patientsPerWeek: 25, distance: 4)
var continueProgram = true
while continueProgram {
print("Secondary Shielding Calculation\n\n")

print("Shielding Room Index: ")
for i in 0..<shieldingRoomDictionaryText.count {
    print("\(i)...\(shieldingRoomDictionaryText[i]!)")
}
print("\nShielding room index(number from the above index): ")
var response = readLine(stripNewline: true)
let roomIndex = Int(response!)!

print("\n\nType of Secondary Radiation Index: ")
print("1...Leakage")
print("2...Side Scatter")
print("3...Leakage and side scatter")
print("4...Forward/Backscatter")
print("5...Leakage and forward/backscatter\n")
print("Index of radiation type(number from the above index): ")
response = readLine(stripNewline: true)
let radiationIndex = Int(response!)!

print("\n\nIs it controlled area? (Y/N): ")
response = readLine(stripNewline: true)
let isControlArea = response!

print("\n\nnLocation Index")
print("1...Administrative or clerical offices; laboratories, pharmacies, and other ")
print("    work areas fully occupied by an individual; receptionist areas, attended ")
print("    waiting rooms, children's indoor play areas, adjacent x-ray rooms, film ")
print("    reading areas, nurse's stations, x-ray control rooms \n")
print("2...Rooms used for patient examinations and treatments\n")
print("3...Corridors, patient rooms, employee lounge, staff rest rooms\n")
print("4...Corridor doors\n")
print("5...public toilets, unattended vending areas, storage rooms, outdoor areas")
print("    with seating, unattended waiting rooms, patient holding areas \n")
print("6...Outdoor areas with only transient pedestrian or vehicular traffic,  ")
print("    unattended parking lots, vehicular drop off areas (unattended), attics ")
print("    stairways, unattended elevators, janitor's closets \n")

print("Index of location(number from the above index): ")
response = readLine(stripNewline: true)
let locationIndex = Int(response!)!

print("\n\nPatients per week: ")
response = readLine(stripNewline: true)
let ptsPerWeek = Int(response!)!

print("\n\nDistance from source to protected point: ")
response = readLine(stripNewline: true)
let distance = Double(response!)!

let result = secondaryShieldingCalc(shieldingRoomIndex: roomIndex, typeOfSecondaryRadiationIndex: radiationIndex, isControlArea: isControlArea, locationIndex: locationIndex, patientsPerWeek: ptsPerWeek, distance: distance)

print("\n\nThe transmission rate B = \(result)")

print("\n\nAnother calculation? (Y/N) ")

response = readLine(stripNewline: true)
let endOrRun = response!
    switch endOrRun {
    case "Y":
        continueProgram = true
    case "y":
        continueProgram = true
    case "N":
        continueProgram = false
    case "n":
        continueProgram = false
    default:
        continue
}
}