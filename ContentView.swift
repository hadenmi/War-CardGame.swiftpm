import SwiftUI

struct Card {
    var name:String;
    var value:String;
}

var suits:[String] = ["Hearts", "Diamonds", "Clubs", "Spades"];
var values:[String] = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Q", "K", "A", "J"];

func GetValueName(value: Int) -> String {
    return values[value - 1];
}

func GetValueFromName(name: String) -> Int {
    for index in 0...values.count - 1 {
        if (values[index] == name) {
            return index;
        }
    }
    return -1;
}

func GetRandomCard() -> Card {
    let suitIndex = Int.random(in: 0...suits.count - 1);
    let valueIndex = Int.random(in: 0...values.count - 1);

    return Card(name: suits[suitIndex], value: values[valueIndex]);
}

func Deal() -> (Int, Int, Card, Card) {
    var scorePlayer1 = 0;
    var scorePlayer2 = 0;

    let cardPlayer1 = GetRandomCard();
    let cardPlayer2 = GetRandomCard();
    let cardValue1 = GetValueFromName(name: cardPlayer1.value);
    let cardValue2 = GetValueFromName(name: cardPlayer2.value);
    print("-- Player 1: --");
    print(cardPlayer1.name, cardPlayer1.value);
    print("-- Player 2: --");
    print(cardPlayer2.name, cardPlayer2.value);
    
    if (cardValue1 > cardValue2) {
      print("Player 1 won the round!");
      scorePlayer1 += 1;
    } else if (cardValue1 < cardValue2) {
      print("Player 2 won the round!");
      scorePlayer2 += 1;
    } else {
      print("Both players tied!");
    }
    
    if (scorePlayer1 == scorePlayer2) {
        print("Both players tied with a score of \(scorePlayer1)!");
    } else if (scorePlayer1 > scorePlayer2) {
        print("Player 1 won with a score of \(scorePlayer1)!");
        print("Player 2 lost with a score of \(scorePlayer2).");
    } else {
        print("Player 2 won with a score of \(scorePlayer2)!");
        print("Player 1 lost with a score of \(scorePlayer1).");
    }
    
    return (scorePlayer1, scorePlayer2, cardPlayer1, cardPlayer2);
}

func GetImage(name:String) -> String {
    if (name == "Hearts") {
        return "suit.heart";
    } else if (name == "Diamonds") {
        return "suit.diamond";
    } else if (name == "Spades") {
        return "suit.spade";
    } else {
        return "suit.club";
    }
}

func GetHandDisplay(computer:Card, player:Card) -> (String, String) {
    let imageNameComputer:String = GetImage(name: computer.name);
    let imageNamePlayer:String = GetImage(name: player.name);
    return (imageNameComputer, imageNamePlayer);
}

struct ContentView: View {
    @State var myScore:Int = 0;
    @State var computerScore:Int = 0;
    @State var deals:Int = 0;
    @State var lastResult:Int = 0;
    var body: some View {
        VStack {
            if (deals >= 26) {
                Text("Game complete!")
            } else {
                if (deals > 0) {
                    let result = Deal();
                    Button("Click to flip!") {
                        let myResult = result.0;
                        let computerResult = result.1;
                        myScore += myResult;
                        computerScore += computerResult;
                        deals += 1;
                        if (myResult == computerResult) {
                            lastResult = 0;
                        } else if (computerResult > myResult) {
                            lastResult = 1;
                        } else {
                            lastResult = 2;
                        }
                    };
                    let computerCard:Card = result.2;
                    let playerCard:Card = result.3;
                    let images = GetHandDisplay(computer: computerCard, player: playerCard);
                    Text("Computer Hand").bold();
                    Label(computerCard.value, systemImage: images.0).symbolVariant(.fill).symbolRenderingMode(.multicolor);
                    Text("Player Hand").bold();
                    Label(playerCard.value, systemImage: images.1).symbolVariant(.fill).symbolRenderingMode(.multicolor);
                } else {
                    Button("Start game") {
                        deals += 1;
                    }
                }
            }
            if (deals > 0) {
                if (deals > 1) {
                    switch lastResult {
                        case 1:
                            Text("Computer won the round!");
                        case 2:
                            Text("You won the round!");
                        default:
                            Text("It was a tie!");
                    }
                }
                Text("Score - Computer: \(computerScore) Player: \(myScore)");
            }
        }
    }
}
