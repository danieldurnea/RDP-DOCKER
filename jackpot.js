function checkJackpot(digit) {
    var jackpot = {
        "9": "1",
        "8": "2",
        "7": "2",
        "6": "3",
        "5": "3",
        "4": "3",
        "3": "4",
        "2": "4",
        "1": "4",
        "0": "4"
    }
    var number = digit.toString().split('');
    var count = [];
    for (var i = 0; i < number.length; i++) {
        var j = jackpot[number[i]]
        if (count.indexOf(j) == -1)
            count.push(jackpot[number[i]])
    }
    if (count.length == 1) {
        alert("Jackpot " + count[0])

    } else {
        alert("No jackpot")
    }
}
checkJackpot(219)
checkJackpot(999)
checkJackpot(110)
