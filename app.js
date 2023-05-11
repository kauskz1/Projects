function main() {

    var teamA = document.getElementById('teamA').value;
    var teamB = document.getElementById('teamB').value;
    var aScore = document.getElementById('aScore').value;
    var bScore = document.getElementById('bScore').value;
    
    if(teamA==teamB && teamA!="") {
        alert("ERROR: TEAM DUPLICATION NOT ALLOWED");
        return;
    }
    
    aScore = parseInt(aScore);
    bScore = parseInt(bScore);
    
    rowA = document.getElementById(teamA);
    rowB = document.getElementById(teamB);
    
    aMatches = rowA.cells.namedItem("M").innerHTML;
    aWin = rowA.cells.namedItem('W').innerHTML;
    aDraw = rowA.cells.namedItem('D').innerHTML;
    aLoss = rowA.cells.namedItem('L').innerHTML;
    aPoints = rowA.cells.namedItem('Pts').innerHTML;
    aGoalsFor = rowA.cells.namedItem('GF').innerHTML;
    aGoalsAgainst = rowA.cells.namedItem('GA').innerHTML;
    aGoalDiff = rowA.cells.namedItem('GD').innerHTML;
    
    bMatches = rowB.cells.namedItem('M').innerHTML;
    bWin = rowB.cells.namedItem('W').innerHTML;
    bDraw = rowB.cells.namedItem('D').innerHTML;
    bLoss = rowB.cells.namedItem('L').innerHTML;
    bPoints = rowB.cells.namedItem('Pts').innerHTML;
    bGoalsFor = rowB.cells.namedItem('GF').innerHTML;
    bGoalsAgainst = rowB.cells.namedItem('GA').innerHTML;
    bGoalDiff = rowB.cells.namedItem('GD').innerHTML;
    
    aMatches = parseInt(aMatches);
    aWin = parseInt(aWin);
    aDraw = parseInt(aDraw);
    aLoss = parseInt(aLoss); 
    aPoints = parseInt(aPoints); 
    aGoalsFor = parseInt(aGoalsFor); 
    aGoalsAgainst = parseInt(aGoalsAgainst); 
    aGoalDiff = parseInt(aGoalDiff);
    
    bMatches = parseInt(bMatches);
    bWin = parseInt(bWin);
    bDraw = parseInt(bDraw);
    bLoss = parseInt(bLoss); 
    bPoints = parseInt(bPoints); 
    bGoalsFor = parseInt(bGoalsFor); 
    bGoalsAgainst = parseInt(bGoalsAgainst); 
    bGoalDiff = parseInt(bGoalDiff);
    
    
    if(aScore>bScore) {
        // team A wins
        // team B loses
        aMatches++;
        bMatches++;
        aWin++;
        bLoss++;
        aPoints+=3;
        aGoalsFor+=aScore;
        bGoalsFor+=bScore;
        aGoalsAgainst+=bScore;
        bGoalsAgainst+=aScore;
        aGoalDiff = aGoalsFor-aGoalsAgainst;
        bGoalDiff = bGoalsFor-bGoalsAgainst;
    } else if(aScore==bScore) {
            // both teams draw
            aMatches++;
            bMatches++;
            aDraw++;
            bDraw++;
            aPoints++;
            bPoints++;
            aGoalsFor+=aScore;
            bGoalsFor+=bScore;
            aGoalsAgainst+=bScore;
            bGoalsAgainst+=aScore;
            aGoalDiff = aGoalsFor-aGoalsAgainst;
            bGoalDiff = bGoalsFor-bGoalsAgainst;
      } else {
                // team A loses
                // team B wins
                aMatches++;
                bMatches++;
                aLoss++;
                bWin++;
                bPoints+=3;
                aGoalsFor+=aScore;
                bGoalsFor+=bScore;
                aGoalsAgainst+=bScore;
                bGoalsAgainst+=aScore;
                aGoalDiff = aGoalsFor-aGoalsAgainst;
                bGoalDiff = bGoalsFor-bGoalsAgainst;     
    }
    
    rowA.cells.namedItem("M").innerHTML = aMatches;
    rowA.cells.namedItem('W').innerHTML = aWin;
    rowA.cells.namedItem('D').innerHTML = aDraw;
    rowA.cells.namedItem('L').innerHTML = aLoss;
    rowA.cells.namedItem('Pts').innerHTML = aPoints;
    rowA.cells.namedItem('GF').innerHTML = aGoalsFor;
    rowA.cells.namedItem('GA').innerHTML = aGoalsAgainst;
    rowA.cells.namedItem('GD').innerHTML = aGoalDiff;
    
    rowB.cells.namedItem('M').innerHTML = bMatches;
    rowB.cells.namedItem('W').innerHTML = bWin;
    rowB.cells.namedItem('D').innerHTML = bDraw;
    rowB.cells.namedItem('L').innerHTML = bLoss;
    rowB.cells.namedItem('Pts').innerHTML = bPoints;
    rowB.cells.namedItem('GF').innerHTML = bGoalsFor;
    rowB.cells.namedItem('GA').innerHTML = bGoalsAgainst;
    rowB.cells.namedItem('GD').innerHTML = bGoalDiff;
    
    }