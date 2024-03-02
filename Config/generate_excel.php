<?php
require_once('../Config/db_connection.php');
session_start(); // Dodaj tę linię

require '../vendor/autoload.php';

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;

// Stworzenie nowego obiektu Spreadsheet
$spreadsheet = new Spreadsheet();

// Ustawienie informacji o pliku i jego autorze
$spreadsheet->getProperties()->setCreator("Twórca")->setTitle("Tytuł")->setDescription("Opis")->setKeywords("excel raport")->setCategory("Raporty");

$start_year_month = $_SESSION['start_year_month'];
$end_year_month = $_SESSION['end_year_month'];
$lokalizacja_selected_shops_condition = $_SESSION['lokalizacja_selected_shops_condition'];
$naprawy_selected_shops_condition = $_SESSION['naprawy_selected_shops_condition'];
$tonery_selected_shops_condition = $_SESSION['tonery_selected_shops_condition'];
// Zdefiniowanie zapytań SQL
$sql_queries = array(
    "Podsumowanie" => "SELECT 
                            DATE_FORMAT(dz.Data,'%Y-%m') AS DataDzierzaw, 
                            CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja,
                            COALESCE(SUM(dz.Suma), 0) AS SumaKosztowDzierzawy, 
                            COALESCE(SUM(tn.Suma), 0) AS SumaTonerow, 
                            COALESCE(SUM(np.Kwota), 0) AS SumaNapraw, 
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
                            Lokalizacja, DataDzierzaw",
    "Dzierzawa" => "SELECT 
                        DATE_FORMAT(dz.Data,'%Y-%m') AS DataDzierzawy, 
                        CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja,
                        do.Nazwa AS Dostawca, 
                        CONCAT(dm.Producent, ' ', dm.Model) AS ModelDrukarki, 
                        dz.StanNaDzisiaj, 
                        dz.KwotaDzierzawy, 
                        dz.KwotaJedNetto,
                        dz.Ilosc, 
                        dz.Suma
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
                    ORDER BY DataDzierzawy ASC, l.IDLokalizacji ASC",
    "Tonery" => "SELECT 
                        DATE_FORMAT(tn.Data,'%Y-%m') AS DataTonerow, 
                        CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja,
                        tn.Kwota, 
                        tn.Ilosc, 
                        tn.Suma
                    FROM 
                        Tonery tn
                    JOIN
                        Lokalizacja l ON tn.IDLokalizacji = l.IDLokalizacji
                    WHERE 
                    DATE_FORMAT(tn.Data,'%Y-%m') BETWEEN '$start_year_month' AND '$end_year_month'
                        $tonery_selected_shops_condition
                    ORDER BY tn.Data ASC, tn.IDLokalizacji ASC",
    "Naprawy" => "SELECT 
                        DATE_FORMAT(np.DataNaprawy,'%Y-%m') AS DataNaprawy,
                        CONCAT(l.Kod, ' - ', l.Nazwa_Lokalizacji) AS Lokalizacja, 
                        CONCAT(dm.Producent, ' ', dm.Model) AS ModelDrukarki, 
                        do.Nazwa AS Dostawca, 
                        np.Kwota
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
                    ORDER BY DataNaprawy ASC, np.IDLokalizacji ASC",
    // Dodaj kolejne zapytania tutaj...
);

// Iteracja przez zapytania
foreach ($sql_queries as $sheetName => $sql_query) {
    // Tworzenie nowego arkusza dla każdego zapytania SQL
    $sheet = $spreadsheet->createSheet();
    $sheet->setTitle($sheetName);

    // Wykonanie zapytania SQL i pobranie wyników
    $result = $conn->query($sql_query);
    if ($result && $result->num_rows > 0) {
        $row = 1;

        // Dodanie własnych nazw kolumn do pierwszego wiersza
        $columnNames = array_keys($result->fetch_assoc());
        foreach ($columnNames as $key => $columnName) {
            // Ustawienie wartości komórki dla nazw kolumn
            $sheet->setCellValue(Coordinate::stringFromColumnIndex($key + 1) . '1', $columnName);
        }

        // Przesunięcie wskaźnika danych z powrotem na początek
        $result->data_seek(0);

        // Przetwarzanie pozostałych wierszy z wynikami zapytania
        while ($row_data = $result->fetch_assoc()) {
            $row++;
            foreach ($row_data as $col => $value) {
                // Ustawianie wartości komórki w arkuszu
                $sheet->setCellValue(Coordinate::stringFromColumnIndex(array_search($col, array_keys($row_data)) + 1) . $row, $value);
            }
        }
    } else {
        // Obsługa przypadku braku wyników
        $sheet->setCellValue('A1', 'Brak danych');
    }
}




// Ustawienie aktywnego arkusza na pierwszy
$spreadsheet->setActiveSheetIndex(0);

// Utworzenie nowego obiektu Writer
$writer = new Xlsx($spreadsheet);

// Zapisanie pliku
$filename = 'raport.xlsx';
$writer->save($filename);

// Pobranie pliku
header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
header('Content-Disposition: attachment;filename="'. $filename .'"');
header('Cache-Control: max-age=0');
// Wysyłanie pliku do przeglądarki użytkownika
$writer->save('php://output');
?>
