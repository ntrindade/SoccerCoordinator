
/******************************************************
 Helper Functions
 ******************************************************/

//Horror code. Hardcoded values to retrieve Guardian Names.
func getPlayerGuardianNames(player: String) -> String {
    switch player {
    case "Joe Smith": return "Jim and Jan Smith"
    case "Jill Tanner": return "Clara Tanner"
    case "Bill Bon": return "Sara and Jenny Bon"
    case "Eva Gordon": return "Wendy and Mike Gordon"
    case "Matt Gill": return "Charles and Sylvia Gill"
    case "Kimmy Stein": return "Bill and Hillary Stein"
    case "Sammy Adams": return "Jeff Adams"
    case "Karl Saygan": return "Heather Bledsoe"
    case "Suzane Greenberg": return "Henrietta Dumas"
    case "Sal Dali": return "Gala Dali"
    case "Joe Kavalier": return "Sam and Elaine Kavalier"
    case "Ben Finkelstein": return "Aaron and Jill Finkelstein"
    case "Diego Soto": return "Robin and Sarika Soto"
    case "Chloe Alaska": return "David and Jamie Alaska"
    case "Arnold Willis": return "Claire Willis"
    case "Phillip Helm": return "Thomas Helm and Eva Jones"
    case "Les Clay": return "Wynonna Brown"
    case "Herschel Krustofski": return "Hyman and Rachel Krustofski"
    default:
        return "Unknown"
    }
}

//Horror code. Hardcoded values to retrieve Players Heights.
func getPlayerHeight(player: String) -> Int {
    switch player {
    case "Joe Smith": return 42
    case "Jill Tanner": return 36
    case "Bill Bon": return 43
    case "Eva Gordon": return 45
    case "Matt Gill": return 40
    case "Kimmy Stein": return 41
    case "Sammy Adams": return 45
    case "Karl Saygan": return 42
    case "Suzane Greenberg": return 44
    case "Sal Dali": return 41
    case "Joe Kavalier": return 39
    case "Ben Finkelstein": return 44
    case "Diego Soto": return 41
    case "Chloe Alaska": return 47
    case "Arnold Willis": return 43
    case "Phillip Helm": return 44
    case "Les Clay": return 42
    case "Herschel Krustofski": return 45
    default:
        return 0
    }
}

func getPlayersTotalHeight(players: [String: Int]) -> Double {
    
    var totalHeight = 0
    for (playerName, _) in players {
        totalHeight += getPlayerHeight(playerName)
    }
    
    return Double(totalHeight)
}

func getPlayersTotalExperience(players: [String: Int]) -> Int {
    
    var totalExperience = 0
    for (_, playerExperience) in players {
        totalExperience += playerExperience
    }
    
    return totalExperience
}

/******************************************************
 Global Variable and Constants
 ******************************************************/
var league: [String: [String: Int]] = [:]

let teams: [String: String] =
    [
        "Dragons": "March 17, 1pm",
        "Sharks": "March 17, 3pm",
        "Raptors": "March 18, 1pm"
    ]

let playersAndExperience: [String: Int] =
    [
        "Joe Smith": 1,
        "Jill Tanner": 1,
        "Bill Bon": 1,
        "Eva Gordon": 0,
        "Matt Gill": 0,
        "Kimmy Stein": 0,
        "Sammy Adams": 0,
        "Karl Saygan": 1,
        "Sal Dali": 0,
        "Joe Kavalier": 0,
        "Ben Finkelstein": 0,
        "Diego Soto": 1,
        "Chloe Alaska": 0,
        "Arnold Willis": 0,
        "Phillip Helm": 1,
        "Les Clay": 1,
        "Herschel Krustofski": 1,
        "Suzane Greenberg": 1
    ]

let maxPlayersPerTeam: Int = playersAndExperience.count / teams.count

let totalExperience = getPlayersTotalExperience(playersAndExperience)
let maxExperiencePerTeam = totalExperience / teams.count

let totalHeight: Double = getPlayersTotalHeight(playersAndExperience)
let maxAverageHeight: Double = totalHeight / Double(playersAndExperience.count)
let maxAllowedHeightDifference: Double = 1.5

/******************************************************
 Calculation functions
 ******************************************************/

func assignPlayersToLeague(var players: [String: Int]) {

    var remainderPlayers: Int = players.count % teams.count
   
    //Safety counter to avoid infinitive loops
    var maxNumberOfCalculationRounds = teams.count
    
    while (maxNumberOfCalculationRounds > 0 && (players.count > 0 || remainderPlayers > 0)){

        playersLoop: for (playerName, playerExperience) in players {
            teamsLoop: for (teamName, _) in teams {
                
                if league[teamName] == nil {
                    league[teamName] = [:]
                }

                let teamTotalExperience = getPlayersTotalExperience(league[teamName]!)
                let teamCurrentPlayers = league[teamName]!.count
                let teamTotalHeight = getPlayersTotalHeight(league[teamName]!)
                let teamAverageHeight = teamTotalHeight / Double(teamCurrentPlayers)
                
                //First criteria of Assignment: Experience / Height / NumberOfTeamPlayers
                if teamTotalExperience < maxExperiencePerTeam
                && teamAverageHeight < maxAverageHeight
                && teamCurrentPlayers < maxPlayersPerTeam {

                    league[teamName]!.updateValue(playerExperience, forKey: playerName)
                    players.removeValueForKey(playerName)
                    break teamsLoop
                }

                //Second criteria of Assignment: Remainder of odd number of max players per team
                if teamCurrentPlayers == maxPlayersPerTeam
                && remainderPlayers > 0 {
                    
                    league[teamName]!.updateValue(playerExperience, forKey: playerName)
                    players.removeValueForKey(playerName)
                    remainderPlayers -= 1
                    break teamsLoop
                }
                
                //Third criteria of Assignment: "leftovers"
                if teamCurrentPlayers < maxPlayersPerTeam {
                    league[teamName]!.updateValue(playerExperience, forKey: playerName)
                    players.removeValueForKey(playerName)
                    break teamsLoop
                }
            }
        }

        maxNumberOfCalculationRounds -= 1
    }
    
    printPlayersMissingAssignment(players)
}

func calculateHeightCriteria(teamAverageHeight: [Double]) -> String {
    
    let sortedTeamAverageHeight = teamAverageHeight.sort()
    let maxAverageHeight = sortedTeamAverageHeight[sortedTeamAverageHeight.count - 1]
    let minAverageHeight = sortedTeamAverageHeight[0]
    
    if (maxAverageHeight - minAverageHeight < maxAllowedHeightDifference) {
        return "OK"
    } else {
        return "NOT OK"
    }
}

/******************************************************
 Print functions
*******************************************************/

func printPlayersMissingAssignment(players: [String: Int]) {
    print("Players missing assignment: \(players.count)")
    if players.count > 0 {
        for (playerName, playerExperience) in players {
            print("Player: \(playerName); Experience: \(playerExperience); Height: \(getPlayerHeight(playerName))")
        }
    }
}

func printLetterToGuardianOfPlayer(player: String, team: String, firstPractice: String) {
    
    print("Dear [\(getPlayerGuardianNames(player))], [\(player)] has been assigned to the [\(team)] team. The first practice is on [\(firstPractice)].")
}

func printTeamsStats() {
    var teamsAverageHeights: [Double] = []
    for (team, players) in league {
        let teamTotalHeight = getPlayersTotalHeight(players)
        let teamAverageHeight = teamTotalHeight / Double(players.count)
        teamsAverageHeights.append(teamAverageHeight)
        
        let teamExperience = getPlayersTotalExperience(players)
        
        print("\(team) => Players: \(players.count); Experience: \(teamExperience); Team Total Height: \(teamTotalHeight); Team Average Height: \(teamAverageHeight); Experience Criteria = \(teamExperience == maxExperiencePerTeam ? "OK": "NOT OK")")
    }
    print("Height Criteria: \(calculateHeightCriteria(teamsAverageHeights))")
}

func printAllLettersToGuardians() {
    for (team, players) in league {
        print("\nTeam \(team)")
        for (playerName, _) in players {
            printLetterToGuardianOfPlayer(playerName, team: team, firstPractice: teams[team]!)
        }
    }
}

/******************************************************
 Main execution
*******************************************************/

assignPlayersToLeague(playersAndExperience)
printTeamsStats()
printAllLettersToGuardians()





