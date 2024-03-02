<?php
session_start();
require_once('../Config/db_connection.php');

// Sprawdź, czy użytkownik jest zalogowany jako admin
if (!isset($_SESSION['user_id'])) {
    header('Location: ../Users/login.php');
    exit();
}

if ($_SESSION['role'] == 'Admin') {
    $panel = "../Admins/admin_panel.php";
}


if ($_SESSION['role'] == 'Uzytkownik') {
    $panel = "../Users/user_panel.php";
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['generate_report'])) {
    // Pobierz dane z formularza
    $start_date = $_POST["start_date"];
    $end_date = $_POST["end_date"];
    $selected_shops = $_POST["selected_shops"];
    $start_year_month = date('Y-m', strtotime($start_date));
    $end_year_month = date('Y-m', strtotime($end_date));

    $_SESSION['start_year_month'] = date('Y-m', strtotime($start_date));
    $_SESSION['end_year_month'] = date('Y-m', strtotime($end_date));
    $_SESSION['selected_shops'] = $_POST["selected_shops"];

    if (!empty($selected_shops)) {
        $lokalizacja_selected_shops_condition = "AND l.IDLokalizacji IN ('" . implode("','", $selected_shops) . "')";
        $naprawy_selected_shops_condition = "AND np.IDLokalizacji IN ('" . implode("','", $selected_shops) . "')";
        $tonery_selected_shops_condition = "AND tn.IDLokalizacji IN ('" . implode("','", $selected_shops) . "')";
        $_SESSION['lokalizacja_selected_shops_condition']= "AND l.IDLokalizacji IN ('" . implode("','", $_SESSION['selected_shops']) . "')";
        $_SESSION['naprawy_selected_shops_condition'] = "AND np.IDLokalizacji IN ('" . implode("','", $_SESSION['selected_shops']) . "')";
        $_SESSION['tonery_selected_shops_condition'] = "AND tn.IDLokalizacji IN ('" . implode("','", $_SESSION['selected_shops']) . "')";
        file_put_contents('session_debug.txt', print_r($_SESSION, true));
    }

    // Zapytanie SQL z warunkami
    $dzierzawa_sql = "SELECT 
                        l.IDLokalizacji, dz.KwotaJedNetto, dz.Ilosc, dz.StanNaDzisiaj, dz.KwotaDzierzawy, dz.Suma, DATE_FORMAT(dz.Data,'%Y-%m') AS DataDzierzawy, CONCAT(dm.Producent, ' ', dm.Model) AS ModelDrukarki, 
                        do.Nazwa, CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja
                    FROM 
                        Dzierzawa dz
                    JOIN 
                        DrukarkiInwentaryzacja di ON dz.IDDrukarki = di.IDDrukarki
                    JOIN
                        DrukarkiModele dm ON di.IDModeluDrukarki = dm.IDDrukarki
                    INNER JOIN 
                        Lokalizacja l ON di.IDLokalizacji = l.IDLokalizacji
                    INNER JOIN
                        Dostawca do ON dz.IDDostawcy = do.IDDostawcy
                    WHERE 
                        DATE_FORMAT(dz.Data,'%Y-%m') BETWEEN '$start_year_month' AND '$end_year_month'
                        $lokalizacja_selected_shops_condition
                    ORDER BY DataDzierzawy ASC, l.IDLokalizacji ASC";
                    
    $naprawy_sql = "SELECT 
                        do.Nazwa, CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja, CONCAT(dm.Producent, ' ', dm.Model) AS ModelDrukarki, np.Kwota, DATE_FORMAT(np.DataNaprawy,'%Y-%m') AS DataNaprawy
                    FROM 
                        Naprawy np
                    JOIN 
                        Dostawca do ON np.IDDostawcy = do.IDDostawcy
                    JOIN
                        Lokalizacja l ON np.IDLokalizacji = l.IDLokalizacji
                    JOIN
                        DrukarkiModele dm ON np.IDModeluDrukarki = dm.IDDrukarki
                    WHERE 
                        DATE_FORMAT(np.DataNaprawy,'%Y-%m') BETWEEN '$start_year_month' AND '$end_year_month'
                        $naprawy_selected_shops_condition
                    ORDER BY DataNaprawy ASC, np.IDLokalizacji ASC";
    $tonery_sql = "SELECT 
                        tn.Kwota, tn.Ilosc, tn.Suma, DATE_FORMAT(tn.Data,'%Y-%m') AS DataTonerow, CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja
                    FROM 
                        Tonery tn
                    JOIN
                        Lokalizacja l ON tn.IDLokalizacji = l.IDLokalizacji
                    WHERE 
                        DATE_FORMAT(tn.Data,'%Y-%m') BETWEEN '$start_year_month' AND '$end_year_month'
                        $tonery_selected_shops_condition
                    ORDER BY tn.Data ASC, tn.IDLokalizacji ASC";
                    // Zapytanie SQL z warunkami
    $podsumowanie_sql = "SELECT 
                            CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja,
                            COALESCE(SUM(tn.Suma), 0) AS SumaTonerow, 
                            COALESCE(SUM(np.Kwota), 0) AS SumaNapraw, 
                            COALESCE(SUM(dz.Suma), 0) AS SumaKosztowDzierzawy, 
                            DATE_FORMAT(dz.Data,'%Y-%m') AS DataDzierzaw, 
                            SUM(COALESCE(tn.Suma, 0) + COALESCE(np.Kwota, 0) + COALESCE(dz.Suma, 0)) AS SumaWszystkiego
                        FROM 
                            Lokalizacja l
                        LEFT JOIN
                            Tonery tn ON tn.IDLokalizacji = l.IDLokalizacji
                        LEFT JOIN
                            Naprawy np ON np.IDLokalizacji = l.IDLokalizacji
                        LEFT JOIN
                            DrukarkiInwentaryzacja di ON di.IDLokalizacji = l.IDLokalizacji
                        LEFT JOIN
                            Dzierzawa dz ON di.IDDrukarki = dz.IDDrukarki
                        WHERE 
                            l.IDLokalizacji = 1047
                        GROUP BY
                            Lokalizacja, DataDzierzaw";
    
    
}
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Raporty Kosztów</title>
    <link rel="stylesheet" href="../Style/styles.css">
</head>
<body>
    <div id="holder">
        <header><a href="<?php echo $panel ?>" class="button">Powrót do panelu administracyjnego</a></header>
        <header><h2>Raporty Kosztów</h2></header>
        <div id="body">
            <div id="sekcja">
                <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                    <label for="start_date">Data początkowa:</label>
                    <input type="date" id="start_date" name="start_date" required>
                    <label for="end_date">Data końcowa:</label>
                    <input type="date" id="end_date" name="end_date" required><br>
                    <label for="selected_shops">Wybierz sklepy:</label>
                    <select id="selected_shops" name="selected_shops[]" multiple required>
                        <?php
                            $sql = "SELECT IDLokalizacji, CONCAT(Kod, ' - ', Nazwa_Lokalizacji) AS Nazwa FROM Lokalizacja";
                            $result = $conn->query($sql);
                            if ($result->num_rows > 0) {
                                // Tworzenie opcji dla każdego sklepu
                                while($row = $result->fetch_assoc()) {
                                    echo "<option value='" . $row["IDLokalizacji"] . "'>" . $row["Nazwa"] . "</option>";
                                }
                            } else {
                                echo "<option value='-1'>Brak sklepów</option>";
                            }                    
                        ?>
                    </select><br>
                    <input type="submit" name="generate_report" value="Generuj raport">
                </form>
            </div>
            <div id="sekcja">
            <a class="button" href="../Config/generate_excel.php">Generuj plik Excel</a>
            </div>
            <div id="sekcja">
                <h1>Dzierżawa</h1>
                <?php
                if ($_SERVER["REQUEST_METHOD"] == "POST") {
                    
                    $result = $conn->query($dzierzawa_sql);

                    if ($result->num_rows > 0) {
                        // Wyświetlanie nagłówków tabeli
                        echo "<table><tr><th>Data</th><th>Lokalizacja</th><th>Dostawca</th><th>Model Drukarki</th><th>Kwota Jednostkowa Netto</th><th>Ilość</th><th>Kwota Dzierżawy</th><th>Stan na dzisiaj</th><th>Suma</th>";
                    
                        // Wyświetlanie danych w tabeli
                        while($row = $result->fetch_assoc()) {
                            echo "<tr><td>" . $row["DataDzierzawy"]. "</td><td>" . $row["Lokalizacja"]. "</td><td>" . $row["Nazwa"] . "</td><td>" . $row["ModelDrukarki"] . "</td><td>" . $row["KwotaJedNetto"]. "</td><td>" . $row["Ilosc"]. "</td><td>" . $row["KwotaDzierzawy"] . "</td><td>" . $row["StanNaDzisiaj"] . "</td><td>" . $row["Suma"] . "</td></tr>";
                        }
                        echo "</table>";
                    } else {
                        echo "Brak danych do wyświetlenia";
                    }
                }
                ?>
            </div>
            <div id="sekcja">
                <h1>Naprawy</h1>
                <?php
                if ($_SERVER["REQUEST_METHOD"] == "POST") {                    
                    
                    $result = $conn->query($naprawy_sql);
                    file_put_contents('session_debug.txt', print_r($naprawy_sql, true));

                    if ($result->num_rows > 0) {
                        // Wyświetlanie nagłówków tabeli
                        echo "<table><tr><th>Data</th><th>Lokalizacja</th><th>Dostawca</th><th>Model Drukarki</th><th>Kwota Naprawy</th>";
                    
                        // Wyświetlanie danych w tabeli
                        while($row = $result->fetch_assoc()) {
                            echo "<tr><td>" . $row["DataNaprawy"]. "</td><td>" . $row["Lokalizacja"]. "</td><td>" . $row["Nazwa"] . "</td><td>" . $row["ModelDrukarki"] . "</td><td>" . $row["Kwota"]. "</td></tr>";
                        }
                        echo "</table>";
                    } else {
                        echo "Brak danych do wyświetlenia";
                    }
                }
                ?>
            </div>
            <div id="sekcja">
                <h1>Tonery</h1>
                <?php
                if ($_SERVER["REQUEST_METHOD"] == "POST") {

                    $result = $conn->query($tonery_sql);
                    
                    if ($result->num_rows > 0) {
                        // Wyświetlanie nagłówków tabeli
                        echo "<table><tr><th>Data</th><th>Lokalizacja</th><th>Kwota</th><th>Ilosc</th><th>Suma</th></tr>";
                    
                        // Wyświetlanie danych w tabeli
                        while($row = $result->fetch_assoc()) {
                            echo "<tr><td>" . $row["DataTonerow"]. "</td><td>" . $row["Lokalizacja"]. "</td><td>" . $row["Kwota"] . "</td><td>" . $row["Ilosc"] . "</td><td>" . $row["Suma"]. "</td></tr>";
                        }
                        echo "</table>";
                    } else {
                        echo "Brak danych do wyświetlenia";
                    }
                }
                ?>
            </div>
            <div id="sekcja">
                <h1>Podsumowanie</h1>
                <?php
                if ($_SERVER["REQUEST_METHOD"] == "POST") {

                    $result = $conn->query($podsumowanie_sql);
                    
                    if ($result->num_rows > 0) {
                        // Wyświetlanie nagłówków tabeli
                        echo "<table><tr><th>Data</th><th>Lokalizacja</th><th>Suma Tonerow</th><th>Suma Napraw</th><th>Suma Kosztow Dzierżaw</th><th>Łączna suma kosztów</th></tr>";
                    
                        // Wyświetlanie danych w tabeli
                        while($row = $result->fetch_assoc()) {
                            echo "<tr><td>" . $row["DataDzierzaw"]. "</td><td>" . $row["Lokalizacja"]. "</td><td>" . $row["SumaTonerow"] . "</td><td>" . $row["SumaNapraw"] . "</td><td>" . $row["SumaKosztowDzierzawy"]. "</td><td>" . $row["SumaWszystkiego"]. "</td></tr>";
                        }
                        echo "</table>";
                    } else {
                        echo "Brak danych do wyświetlenia";
                    }
                }
                ?>
            </div>
        </div>
    </div>
</body>
</html>
