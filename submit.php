<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Success</title>
</head>

<body>
    <h1>You have been succesfully registered!</h1>
    <h2>Details</h2>
    Name: <?php echo $_POST["name"]; ?><br>
    Team name: <?php echo $_POST["team"]; ?><br>
    Phone: <?php echo $_POST["phone"]; ?><br>
    Email: <?php echo $_POST["email"]; ?><br>
    Seed: <?php echo $_POST["seed"]; ?><br>
    <?php
        include 'global.php';
        // Create connection
        $conn = mysqli_connect($servername, $username, $password, $dbname);

        // Check connection
        if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
        }
        //echo "Connected successfully";
        $name = $_POST["name"];
        $team = $_POST["team"];
        $phone = $_POST["phone"];
        $email = $_POST["email"];
        $seed = $_POST["seed"];

        $sql = "INSERT INTO TEAMS(`name`, `team_name`, `phone_no`, `email`, `seeding`) VALUES('$name', '$team', $phone, '$email', $seed);";

        if (mysqli_query($conn, $sql)) {
            echo "New record created successfully";
            $id++;
        }
        else{
            echo "Error: " . $sql . "<br>" . mysqli_error($conn);
        }
        mysqli_close($conn);
    ?>

</body>
</html>