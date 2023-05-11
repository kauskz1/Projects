<html>
<head>
    <title>Standings</title>
</head>

<body>
    <?php
        include 'global.php';

        $conn = mysqli_connect($servername, $username, $password, $dbname);

        if($conn->connect_error){
            die("Connection failed: " . $conn->connect_error);
        }

        $sql = "SELECT * FROM Standings ORDER BY Standing DESC;";
        $result = $conn->query($sql);

        echo "<table><tr><th>Rank</th><th>Team</th><th>Win</th><th>Draw</th><th>Lose</th><th>Points</th><th>Net Run Rate</th></tr>";
        while($row = $result->fetch_assoc()){
            echo $row["rank"] . " " . $row["team_name"] . " " . $row["win"]."-".$row["draw"]."-".$row["lose"] . " " . $row["points"] . " " . $row["net_runrate"]. "<br>";
        }
        echo "</table>";

        $conn->close();
    ?>

</body>
</html>