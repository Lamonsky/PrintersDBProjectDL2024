<?php
session_start();

require_once('../Config/db_connection.php');

// Funkcja walidująca dane
function validateInput($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

// Obsługa dodawania danych do tabeli Dzierzawa
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_dzierzawa'])) {
    $iddrukarki_dzierzawa = $_POST['iddrukarki_dzierzawa'];
    $iddostawcy_dzierzawa = $_POST['iddostawcy_dzierzawa'];
    $kwota_jed_netto = isset($_POST['kwota_jed_netto']) ? floatval(str_replace(',', '.', validateInput($_POST['kwota_jed_netto']))) : 0;
    $ilosc_dzierzawa = isset($_POST['ilosc_dzierzawa']) ? intval($_POST['ilosc_dzierzawa']) : 0;
    $stan_na_dzisiaj = isset($_POST['stan_na_dzisiaj']) ? intval($_POST['stan_na_dzisiaj']) : 0;
    $kwota_dzierzawy = isset($_POST['kwota_dzierzawy']) ? str_replace(',', '.', validateInput($_POST['kwota_dzierzawy'])) : 0;
    $suma_dzierzawa = $kwota_jed_netto * $ilosc_dzierzawa + $kwota_dzierzawy;
    $data_dzierzawa = $_POST['data_dzierzawa'];

    // Zabezpieczenie przed atakami SQL injection
    $kwota_jed_netto = mysqli_real_escape_string($conn, $kwota_jed_netto);
    $ilosc_dzierzawa = mysqli_real_escape_string($conn, $ilosc_dzierzawa);
    $stan_na_dzisiaj = mysqli_real_escape_string($conn, $stan_na_dzisiaj);
    $kwota_dzierzawy = mysqli_real_escape_string($conn, $kwota_dzierzawy);
    $suma_dzierzawa = mysqli_real_escape_string($conn, $suma_dzierzawa);
    $data_dzierzawa = mysqli_real_escape_string($conn, $data_dzierzawa);

    // Dodanie danych do tabeli Dzierzawa
    $query_dzierzawa = "INSERT INTO Dzierzawa (IDDrukarki, IDDostawcy, KwotaJedNetto, Ilosc, StanNaDzisiaj, KwotaDzierzawy, Suma, Data) VALUES ('$iddrukarki_dzierzawa', '$iddostawcy_dzierzawa', '$idlokalizacji_dzierzawa', '$kwota_jed_netto', '$ilosc_dzierzawa', '$stan_na_dzisiaj', '$kwota_dzierzawy', '$suma_dzierzawa', '$data_dzierzawa')";
    $result_dzierzawa = mysqli_query($conn, $query_dzierzawa);

    if ($result_dzierzawa) {
        echo "Dane zostały dodane do tabeli Dzierzawa.";
    } else {
        echo "Błąd podczas dodawania danych do tabeli Dzierzawa: " . mysqli_error($conn);
    }
}

// Obsługa dodawania danych do tabeli Naprawy
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_naprawa'])) {
    $iddostawcy_naprawa = $_POST['iddostawcy_naprawa'];
    $idlokalizacji_naprawa = $_POST['idlokalizacji_naprawa'];
    $model_drukarki = $_POST['model_drukarki'];
    $kwota_naprawy = str_replace(',', '.', validateInput($_POST['kwota_naprawy']));
    $data_naprawy = $_POST['data_naprawy'];

    // Zabezpieczenie przed atakami SQL injection
    $kwota_naprawy = mysqli_real_escape_string($conn, $kwota_naprawy);
    $data_naprawy = mysqli_real_escape_string($conn, $data_naprawy);

    // Dodanie danych do tabeli Naprawy
    $query_naprawa = "INSERT INTO Naprawy (IDDostawcy, IDLokalizacji, IDModeluDrukarki, Kwota, DataNaprawy) VALUES ('$iddostawcy_naprawa', '$idlokalizacji_naprawa', '$model_drukarki', '$kwota_naprawy', '$data_naprawy')";
    $result_naprawa = mysqli_query($conn, $query_naprawa);

    if ($result_naprawa) {
        echo "Dane zostały dodane do tabeli Naprawy.";
    } else {
        echo "Błąd podczas dodawania danych do tabeli Naprawy: " . mysqli_error($conn);
    }
}
// Obsługa dodawania danych do tabeli Tonery
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['submit_toner'])) {
    $idlokalizacji_toner = $_POST['idlokalizacji_toner'];
    $kwota_toner = str_replace(',', '.', validateInput($_POST['kwota_toner']));
    $ilosc_toner = $_POST['ilosc_toner'];
    $suma_toner = $kwota_toner*$ilosc_toner;
    $data_toner = $_POST['data_toner'];

    // Zabezpieczenie przed atakami SQL injection
    $kwota_toner = mysqli_real_escape_string($conn, $kwota_toner);
    $ilosc_toner = mysqli_real_escape_string($conn, $ilosc_toner);
    $suma_toner = mysqli_real_escape_string($conn, $suma_toner);
    $data_toner = mysqli_real_escape_string($conn, $data_toner);

    // Dodanie danych do tabeli Tonery
    $query_toner = "INSERT INTO Tonery (IDLokalizacji, Kwota, Ilosc, Suma, Data) VALUES ('$idlokalizacji_toner', '$kwota_toner', '$ilosc_toner', '$suma_toner', '$data_toner')";
    $result_toner = mysqli_query($conn, $query_toner);

    if ($result_toner) {
        echo "Dane zostały dodane do tabeli Tonery.";
    } else {
        echo "Błąd podczas dodawania danych do tabeli Tonery: " . mysqli_error($conn);
    }
}

// Pobranie dostępnych drukarek dla comboboxa w dzierżawie
$query_drukarki_dzierzawa = "SELECT di.IDdrukarki, CONCAT(dm.Producent, ' ', dm.Model, ' - ', di.NumerSeryjny, ' - ', l.Kod, '-', l.Nazwa_Lokalizacji ,' - ', di.AdresIP, ' - ', di.Lokalizacja) AS Model FROM DrukarkiInwentaryzacja di LEFT JOIN DrukarkiModele dm ON di.IDModeluDrukarki = dm.IDDrukarki LEFT JOIN Lokalizacja l ON di.IDLokalizacji = l.IDLokalizacji WHERE di.IDDostawcy BETWEEN 1 AND 3";
$result_drukarki_dzierzawa = mysqli_query($conn, $query_drukarki_dzierzawa);

// Pobranie dostawców dla comboboxa w dzierżawie
$query_dostawcy_dzierzawa = "SELECT IDDostawcy, Nazwa FROM Dostawca";
$result_dostawcy_dzierzawa = mysqli_query($conn, $query_dostawcy_dzierzawa);

// Pobranie lokalizacji dla comboboxa w dzierżawie
$query_lokalizacje = "SELECT IDLokalizacji, CONCAT(Kod, ' - ', Nazwa_Lokalizacji) AS Lokalizacja FROM Lokalizacja";
$result_lokalizacje = mysqli_query($conn, $query_lokalizacje);

// Pobranie lokalizacji dla comboboxa w naprawach
$query_lokalizacje_naprawy = "SELECT IDLokalizacji, CONCAT(Kod, ' - ', Nazwa_Lokalizacji) AS Lokalizacja FROM Lokalizacja";
$result_lokalizacje_naprawy = mysqli_query($conn, $query_lokalizacje_naprawy);

// Pobranie lokalizacji dla comboboxa w tonerach
$query_lokalizacje_tonery = "SELECT IDLokalizacji, CONCAT(Kod, ' - ', Nazwa_Lokalizacji) AS Lokalizacja FROM Lokalizacja";
$result_lokalizacje_tonery = mysqli_query($conn, $query_lokalizacje_tonery);

// Pobranie dostawców dla comboboxa w naprawie
$query_dostawcy_naprawa = "SELECT IDDostawcy, Nazwa FROM Dostawca";
$result_dostawcy_naprawa = mysqli_query($conn, $query_dostawcy_naprawa);

// Pobranie modeli drukarek dla comboboxa w naprawie
$query_modele_naprawa = "SELECT IDdrukarki, Producent, Model FROM DrukarkiModele";
$result_modele_naprawa = mysqli_query($conn, $query_modele_naprawa);
?>

<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administracyjny - Zarządzanie Drukarkami</title>
    <link rel="stylesheet" href="../Style/styles.css">
</head>
<body>
<div id="holder">
    <header><a href="admin_panel.php" class="button">Powrót do panelu administracyjnego</a></header>
    <header><h2>Panel Administracyjny - Zarządzanie Drukarkami</h2></header>
    <div id="body">
        <div class="sekcja">
            <h3>Dzierżawa</h3>
            <div>
                <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                    <label for="iddrukarki_dzierzawa">Wybierz drukarkę:</label><br>
                    <select id="iddrukarki_dzierzawa" name="iddrukarki_dzierzawa">
                        <?php
                        while ($row_drukarki_dzierzawa = mysqli_fetch_assoc($result_drukarki_dzierzawa)) {
                            echo "<option value='" . $row_drukarki_dzierzawa['IDdrukarki'] . "'>" . $row_drukarki_dzierzawa['Model'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="iddostawcy_dzierzawa">Wybierz dostawcę:</label><br>
                    <select id="iddostawcy_dzierzawa" name="iddostawcy_dzierzawa">
                        <?php
                        while ($row_dostawcy_dzierzawa = mysqli_fetch_assoc($result_dostawcy_dzierzawa)) {
                            echo "<option value='" . $row_dostawcy_dzierzawa['IDDostawcy'] . "'>" . $row_dostawcy_dzierzawa['Nazwa'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="kwota_jed_netto">Kwota jednostkowa netto:</label><br>
                    <input type="text" id="kwota_jed_netto" name="kwota_jed_netto"><br>
                    <label for="ilosc_dzierzawa">Ilość:</label><br>
                    <input type="text" id="ilosc_dzierzawa" name="ilosc_dzierzawa"><br>
                    <label for="stan_na_dzisiaj">Stan na dzisiaj:</label><br>
                    <input type="text" id="stan_na_dzisiaj" name="stan_na_dzisiaj"><br>
                    <label for="kwota_dzierzawy">Kwota dzierżawy:</label><br>
                    <input type="text" id="kwota_dzierzawy" name="kwota_dzierzawy"><br>
                    <label for="data_dzierzawa">Data:</label><br>
                    <input type="date" id="data_dzierzawa" name="data_dzierzawa" required><br>
                    <input type="submit" name="submit_dzierzawa" value="Dodaj">
                </form>
            </div>
            <div>
    <h4>Tabela Dzierzawa</h4>
    <table>
        <thead>
            <tr>
                <th>IDDzierzawy</th>
                <th>Drukarka</th>
                <th>Dostawca</th>
                <th>Lokalizacja</th>
                <th>KwotaJedNetto</th>
                <th>Ilosc</th>
                <th>StanNaDzisiaj</th>
                <th>KwotaDzierzawy</th>
                <th>Suma</th>
                <th>Data</th>
            </tr>
        </thead>
        <tbody>
            <?php
            // Pobranie danych z tabeli Dzierzawa wraz z nazwami drukarek, dostawców i lokalizacji
            $query_get_dzierzawa = "SELECT dz.IDDzierzawy, CONCAT(dm.Producent, ' ', dm.Model,' - ', di.NumerSeryjny) AS ModelDrukarki, CONCAT(l.Kod, ' ',l.Nazwa_lokalizacji) AS Lokalizacja, d.Nazwa AS NazwaDostawcy, dz.KwotaJedNetto, dz.Ilosc, dz.StanNaDzisiaj, dz.KwotaDzierzawy, dz.Suma, dz.Data
                                    FROM Dzierzawa dz
                                    LEFT JOIN DrukarkiInwentaryzacja di ON dz.IDDrukarki = di.IDdrukarki
                                    LEFT JOIN DrukarkiModele dm ON di.IDModeluDrukarki = dm.IDDrukarki
                                    LEFT JOIN Dostawca d ON dz.IDDostawcy = d.IDDostawcy
                                    LEFT JOIN Lokalizacja l ON di.IDLokalizacji = l.IDLokalizacji";
            $result_get_dzierzawa = mysqli_query($conn, $query_get_dzierzawa);

            // Wyświetlenie danych z tabeli Dzierzawa
            while ($row_dzierzawa = mysqli_fetch_assoc($result_get_dzierzawa)) {
                echo "<tr>";
                echo "<td>".$row_dzierzawa['IDDzierzawy']."</td>";
                echo "<td>".$row_dzierzawa['ModelDrukarki']."</td>";
                echo "<td>".$row_dzierzawa['NazwaDostawcy']."</td>";
                echo "<td>".$row_dzierzawa['Lokalizacja']."</td>";
                echo "<td>".$row_dzierzawa['KwotaJedNetto']."</td>";
                echo "<td>".$row_dzierzawa['Ilosc']."</td>";
                echo "<td>".$row_dzierzawa['StanNaDzisiaj']."</td>";
                echo "<td>".$row_dzierzawa['KwotaDzierzawy']."</td>";
                echo "<td>".$row_dzierzawa['Suma']."</td>";
                echo "<td>".$row_dzierzawa['Data']."</td>";
                echo "</tr>";
            }
            ?>
        </tbody>
    </table>
</div>

        </div>
        <div class="sekcja">
            <h3>Naprawa</h3>
            <div>
                <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                    <label for="iddostawcy_naprawa">Wybierz dostawcę:</label><br>
                    <select id="iddostawcy_naprawa" name="iddostawcy_naprawa">
                        <?php
                        while ($row_dostawcy_naprawa = mysqli_fetch_assoc($result_dostawcy_naprawa)) {
                            echo "<option value='" . $row_dostawcy_naprawa['IDDostawcy'] . "'>" . $row_dostawcy_naprawa['Nazwa'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="idlokalizacji_naprawa">Wybierz lokalizację:</label><br>
                    <select id="idlokalizacji_naprawa" name="idlokalizacji_naprawa">
                        <?php
                        while ($row_lokalizacje = mysqli_fetch_assoc($result_lokalizacje_naprawy)) {
                            echo "<option value='" . $row_lokalizacje['IDLokalizacji'] . "'>" . $row_lokalizacje['Lokalizacja'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="model_drukarki">Wybierz model drukarki:</label><br>
                    <select id="model_drukarki" name="model_drukarki">
                        <?php
                        while ($row_modele_naprawa = mysqli_fetch_assoc($result_modele_naprawa)) {
                            echo "<option value='" . $row_modele_naprawa['IDdrukarki'] . "'>" . $row_modele_naprawa['Producent'] . " " . $row_modele_naprawa['Model'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="kwota_naprawy">Kwota naprawy:</label><br>
                    <input type="text" id="kwota_naprawy" name="kwota_naprawy" required><br>
                    <label for="data_naprawy">Data naprawy:</label><br>
                    <input type="date" id="data_naprawy" name="data_naprawy" required><br>
                    <input type="submit" name="submit_naprawa" value="Dodaj">
                </form>
            </div>
            <!-- Tabela Naprawa -->
            <div>
                <h4>Tabela Naprawa</h4>
                <table>
                    <!-- Nagłówki tabeli -->
                    <thead>
                        <tr>
                            <th>IDNaprawy</th>
                            <th>Dostawca</th>
                            <th>Lokalizacja</th>
                            <th>Model Drukarki</th>
                            <th>Kwota</th>
                            <th>Data Naprawy</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        // Pobranie danych z tabeli Naprawa
                        $query_get_naprawa = "SELECT nap.*, d.Nazwa AS NazwaDostawcy, CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS NazwaLokalizacji, CONCAT(dm.Producent, ' ', dm.Model) AS ModelDrukarki FROM Naprawy nap
                        LEFT JOIN Dostawca d ON nap.IDDostawcy = d.IDDostawcy
                        LEFT JOIN Lokalizacja l ON nap.IDLokalizacji = l.IDLokalizacji
                        LEFT JOIN DrukarkiModele dm ON nap.IDModeluDrukarki = dm.IDdrukarki";
                        $result_get_naprawa = mysqli_query($conn, $query_get_naprawa);

                        // Wyświetlenie danych z tabeli Naprawa
                        while ($row_naprawa = mysqli_fetch_assoc($result_get_naprawa)) {
                            echo "<tr>";
                            echo "<td>".$row_naprawa['IDNaprawy']."</td>";
                            echo "<td>".$row_naprawa['NazwaDostawcy']."</td>";
                            echo "<td>".$row_naprawa['NazwaLokalizacji']."</td>";
                            echo "<td>".$row_naprawa['ModelDrukarki']."</td>";
                            echo "<td>".$row_naprawa['Kwota']."</td>";
                            echo "<td>".$row_naprawa['DataNaprawy']."</td>";
                            echo "</tr>";
                        }
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- TONERY -->
        <div class="sekcja">
            <h3>Dodaj do tabeli Tonery</h3>
            <div>
                <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
                    <label for="idlokalizacji_toner">Wybierz lokalizację:</label><br>
                    <select id="idlokalizacji_toner" name="idlokalizacji_toner" required>
                    <?php
                        while ($row_lokalizacje = mysqli_fetch_assoc($result_lokalizacje_tonery)) {
                            echo "<option value='" . $row_lokalizacje['IDLokalizacji'] . "'>" . $row_lokalizacje['Lokalizacja'] . "</option>";
                        }
                        ?>
                    </select><br>
                    <label for="kwota_toner">Kwota:</label><br>
                    <input type="text" id="kwota_toner" name="kwota_toner" required><br>
                    <label for="ilosc_toner">Ilość:</label><br>
                    <input type="text" id="ilosc_toner" name="ilosc_toner" required><br>
                    <label for="data_toner">Data:</label><br>
                    <input type="date" id="data_toner" name="data_toner" required><br>
                    <input type="submit" name="submit_toner" value="Dodaj">
                </form>
            </div>
            <div>
                <h4>Tabela Tonery</h4>
                <table>
                    <!-- Nagłówki tabeli -->
                    <thead>
                        <tr>
                            <th>ID Toneru</th>
                            <th>Lokalizacja</th>
                            <th>Kwota</th>
                            <th>Ilość</th>
                            <th>Suma</th>
                            <th>Data</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        // Pobranie danych z tabeli Tonery
                        $query_get_tonery = "SELECT ton.*, l.Kod, l.Nazwa_Lokalizacji FROM Tonery ton
                        LEFT JOIN Lokalizacja l ON ton.IDLokalizacji = l.IDLokalizacji";
                        $result_get_tonery = mysqli_query($conn, $query_get_tonery);

                        // Wyświetlenie danych z tabeli Tonery
                        while ($row_tonery = mysqli_fetch_assoc($result_get_tonery)) {
                            echo "<tr>";
                            echo "<td>".$row_tonery['IDToneru']."</td>";
                            echo "<td>".$row_tonery['Kod']." - ".$row_tonery['Nazwa_Lokalizacji']."</td>";
                            echo "<td>".$row_tonery['Kwota']."</td>";
                            echo "<td>".$row_tonery['Ilosc']."</td>";
                            echo "<td>".$row_tonery['Suma']."</td>";
                            echo "<td>".$row_tonery['Data']."</td>";
                            echo "</tr>";
                        }
                        ?>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</div>
</body>
</html>
