-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 02, 2024 at 07:09 PM
-- Wersja serwera: 8.0.36-0ubuntu0.22.04.1
-- Wersja PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PrintersDB`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Dostawca`
--

CREATE TABLE `Dostawca` (
  `IDDostawcy` int NOT NULL,
  `Nazwa` varchar(100) DEFAULT NULL,
  `Mail` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Dostawca`
--

INSERT INTO `Dostawca` (`IDDostawcy`, `Nazwa`, `Mail`) VALUES
(1, 'EKKO', 'serwis@ekko.net.pl'),
(2, 'Drab Technika Biurowa', 'drab.technika.biurowa@biuro.pl'),
(3, 'CopySystem', 'copysystem.pl'),
(4, 'Nasze', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `DrukarkiInwentaryzacja`
--

CREATE TABLE `DrukarkiInwentaryzacja` (
  `IDdrukarki` int NOT NULL,
  `IDDostawcy` int DEFAULT NULL,
  `IDModeluDrukarki` int NOT NULL,
  `IDLokalizacji` int NOT NULL,
  `NumerSeryjny` varchar(50) DEFAULT NULL,
  `AdresIP` varchar(50) DEFAULT NULL,
  `Lokalizacja` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `DrukarkiInwentaryzacja`
--

INSERT INTO `DrukarkiInwentaryzacja` (`IDdrukarki`, `IDDostawcy`, `IDModeluDrukarki`, `IDLokalizacji`, `NumerSeryjny`, `AdresIP`, `Lokalizacja`) VALUES
(5, 1, 1, 1, '231', '10.0.24.64', 'Contact Center'),
(6, 4, 2, 2, '123', 'xxx', 'xxx'),
(7, 1, 1, 1, 'asd', '10.0.24.1', 'DKW'),
(8, 2, 6, 593, '0', '0', '0'),
(9, 1, 7, 1047, '0', '0', '0'),
(10, 1, 8, 1047, '0', '0', '0');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `DrukarkiModele`
--

CREATE TABLE `DrukarkiModele` (
  `IDdrukarki` int NOT NULL,
  `Producent` varchar(100) DEFAULT NULL,
  `Model` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `DrukarkiModele`
--

INSERT INTO `DrukarkiModele` (`IDdrukarki`, `Producent`, `Model`) VALUES
(1, 'Lexmark', 'MX511de'),
(2, 'Brother', 'HL-2080DW'),
(5, 'Brother', 'MFC-7715DW'),
(6, 'Canon ', 'C2080'),
(7, 'Brother', 'HL-2372DN'),
(8, 'Brother', 'DCP-L2552DN');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Dzierzawa`
--

CREATE TABLE `Dzierzawa` (
  `IDDzierzawy` int NOT NULL,
  `IDDrukarki` int DEFAULT NULL,
  `IDDostawcy` int DEFAULT NULL,
  `KwotaJedNetto` decimal(10,2) DEFAULT NULL,
  `Ilosc` int DEFAULT NULL,
  `StanNaDzisiaj` int DEFAULT NULL,
  `KwotaDzierzawy` decimal(10,2) DEFAULT NULL,
  `Suma` decimal(10,2) DEFAULT NULL,
  `Data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Dzierzawa`
--

INSERT INTO `Dzierzawa` (`IDDzierzawy`, `IDDrukarki`, `IDDostawcy`, `KwotaJedNetto`, `Ilosc`, `StanNaDzisiaj`, `KwotaDzierzawy`, `Suma`, `Data`) VALUES
(1, 5, 1, 0.29, 10000, 10000, 150.00, 2900.00, '2024-02-01'),
(2, 5, 1, 0.29, 10000, 10000, 150.00, 3050.00, '2024-02-01'),
(3, 5, 1, 0.00, 0, 0, 150.00, 150.00, '2024-02-01'),
(4, 7, 1, 0.00, 0, 0, 10.00, 10.00, '2024-01-01'),
(5, 7, 1, 0.00, 0, 0, 10.00, 10.00, '2024-01-01'),
(6, 5, 1, 0.00, 0, 0, 12.00, 12.00, '2024-03-07'),
(7, 5, 1, 0.19, 150, 0, 20.00, 48.50, '2022-12-01'),
(8, 9, 1, 15.52, 7, 0, 0.00, 108.64, '2024-01-01'),
(9, 10, 1, 20.03, 1, 0, 0.00, 20.03, '2024-01-01');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Lokalizacja`
--

CREATE TABLE `Lokalizacja` (
  `IDLokalizacji` int NOT NULL,
  `Kod` varchar(50) DEFAULT NULL,
  `Nazwa_Lokalizacji` varchar(100) DEFAULT NULL,
  `IleDrukarek` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Lokalizacja`
--

INSERT INTO `Lokalizacja` (`IDLokalizacji`, `Kod`, `Nazwa_Lokalizacji`, `IleDrukarek`) VALUES
(1, 'HQ', 'Centrala', 79),
(2, 'S001', 'Złotów', 9),
(588, 'S002', 'Człuchów', NULL),
(589, 'S004', 'Piła Kasztanowa', NULL),
(590, 'S009', 'Barlinek', NULL),
(591, 'S011', 'Starogard Gd. 1', NULL),
(592, 'S012', 'Wągrowiec', NULL),
(593, 'S013', 'Chodzież', NULL),
(594, 'S019', 'Czersk', NULL),
(595, 'S022', 'Grudziądz', NULL),
(596, 'S026', 'Malbork', NULL),
(597, 'S027', 'Wejherowo', NULL),
(598, 'S031', 'Leszno', NULL),
(599, 'S033', 'Wałcz Agroma', NULL),
(600, 'S037', 'Słubice', NULL),
(601, 'S038', 'Pyrzyce', NULL),
(602, 'S042', 'Rawicz', NULL),
(603, 'S046', 'Kołobrzeg', NULL),
(604, 'S047', 'Tczew 2', NULL),
(605, 'S048', 'Kwidzyn', NULL),
(606, 'S054', 'Pleszew', NULL),
(607, 'S056', 'Gostyń', NULL),
(608, 'S057', 'Szamotuły', NULL),
(609, 'S060', 'Racibórz', NULL),
(610, 'S061', 'Przasnysz', NULL),
(611, 'S064', 'Wrocław Futura', NULL),
(612, 'S065', 'Polkowice', NULL),
(613, 'S066', 'Gniezno', NULL),
(614, 'S067', 'Sieradz', NULL),
(615, 'S069', 'Legnica', NULL),
(616, 'S070', 'Świebodzin', NULL),
(617, 'S071', 'Starogard Gd. 3', NULL),
(618, 'S072', 'Wrocław Helical', NULL),
(619, 'S073', 'Lubin', NULL),
(620, 'S078', 'Lubań', NULL),
(621, 'S079', 'Ostrołęka', NULL),
(622, 'S081', 'Gubin', NULL),
(623, 'S082', 'Dzierżoniów', NULL),
(624, 'S083', 'Inowrocław', NULL),
(625, 'S084', 'Wejherowo 2', NULL),
(626, 'S086', 'Tuchola', NULL),
(627, 'S087', 'Szprotawa', NULL),
(628, 'S089', 'Świdnica', NULL),
(629, 'S092', 'Golub-Dobrzyń 2', NULL),
(630, 'S093', 'Lipno', NULL),
(631, 'S095', 'Wrocław Sconto', NULL),
(632, 'S096', 'Stargard Szczeciński 2', NULL),
(633, 'S097', 'Ciechanów', NULL),
(634, 'S099', 'Strzelin', NULL),
(635, 'S101', 'Sulęcin', NULL),
(636, 'S102', 'Elbląg', NULL),
(637, 'S104', 'Kłodzko', NULL),
(638, 'S105', 'Bogatynia', NULL),
(639, 'S106', 'Strzelce Opolskie', NULL),
(640, 'S107', 'Lębork 2', NULL),
(641, 'S109', 'Łowicz', NULL),
(642, 'S110', 'Jelenia Góra 2', NULL),
(643, 'S114', 'Kępno', NULL),
(644, 'S121', 'Kalisz', NULL),
(645, 'S122', 'Choszczno', NULL),
(646, 'S123', 'Nysa 2', NULL),
(647, 'S126', 'Wolsztyn', NULL),
(648, 'S145', 'Witkowo', NULL),
(649, 'S148', 'Gniewkowo', NULL),
(650, 'S149', 'Radziejów', NULL),
(651, 'S153', 'Włocławek 1', NULL),
(652, 'S154', 'Opole', NULL),
(653, 'S155', 'Olkusz', NULL),
(654, 'S156', 'Miechów', NULL),
(655, 'S157', 'Kazimierza Wielka', NULL),
(656, 'S158', 'Kielce 1', NULL),
(657, 'S162', 'Elbląg 2', NULL),
(658, 'S163', 'Ostrów Wielkopolski 2', NULL),
(659, 'S164', 'Kalisz 2', NULL),
(660, 'S165', 'Ostrów Mazowiecka', NULL),
(661, 'S166', 'Włocławek 2', NULL),
(662, 'S167', 'Toruń', NULL),
(663, 'S169', 'Włoszczowa', NULL),
(664, 'S170', 'Kielce 2', NULL),
(665, 'S171', 'Opole 2', NULL),
(666, 'S175', 'Gryfino', NULL),
(667, 'S178', 'Krosno Odrzańskie', NULL),
(668, 'S179', 'Wadowice', NULL),
(669, 'S180', 'Wałbrzych', NULL),
(670, 'S182', 'Gorzów Wielkopolski', NULL),
(671, 'S184', 'Świecie 3', NULL),
(672, 'S186', 'Krapkowice', NULL),
(673, 'S188', 'Węgrów', NULL),
(674, 'S189', 'Koszalin', NULL),
(675, 'S190', 'Biskupiec', NULL),
(676, 'S191', 'Łuków', NULL),
(677, 'S192', 'Lublin', NULL),
(678, 'S197', 'Giżycko', NULL),
(679, 'S198', 'Rybnik', NULL),
(680, 'S199', 'Żuromin', NULL),
(681, 'S200', 'Włodawa', NULL),
(682, 'S201', 'Świdwin 3', NULL),
(683, 'S202', 'Mrągowo', NULL),
(684, 'S203', 'Słupsk 3', NULL),
(685, 'S207', 'Wyszków', NULL),
(686, 'S208', 'Żnin', NULL),
(687, 'S209', 'Żary 2', NULL),
(688, 'S210', 'Grajewo', NULL),
(689, 'S211', 'Kostrzyn 2', NULL),
(690, 'S212', 'Słupca 2', NULL),
(691, 'S213', 'Syców', NULL),
(692, 'S215', 'Ząbkowice Śląskie', NULL),
(693, 'S216', 'Bystrzyca Kłodzka', NULL),
(694, 'S218', 'Działdowo', NULL),
(695, 'S219', 'Olecko', NULL),
(696, 'S220', 'Więcbork', NULL),
(697, 'S221', 'Sochaczew', NULL),
(698, 'S223', 'Czarnków 2', NULL),
(699, 'S224', 'Opoczno 2', NULL),
(700, 'S226', 'Miastko', NULL),
(701, 'S231', 'Opole Lubelskie', NULL),
(702, 'S232', 'Zduńska Wola', NULL),
(703, 'S233', 'Bartoszyce', NULL),
(704, 'S234', 'Grudziądz 2', NULL),
(705, 'S235', 'Sępólno Krajeńskie 2', NULL),
(706, 'S236', 'Aleksandrów Kujawski', NULL),
(707, 'S237', 'Chojnice 4', NULL),
(708, 'S238', 'Szczecinek 4', NULL),
(709, 'S239', 'Radom 2', NULL),
(710, 'S240', 'Kętrzyn', NULL),
(711, 'S241', 'Zielona Góra', NULL),
(712, 'S242', 'Hajnówka', NULL),
(713, 'S243', 'Piła Vivo', NULL),
(714, 'S244', 'Międzyrzecz', NULL),
(715, 'S246', 'Zgorzelec 2', NULL),
(716, 'S247', 'Strzegom', NULL),
(717, 'S249', 'Katowice', NULL),
(718, 'S251', 'Augustów', NULL),
(719, 'S254', 'Brzeszcze', NULL),
(720, 'S256', 'Kęty', NULL),
(721, 'S258', 'Złocieniec 2', NULL),
(722, 'S260', 'Tomaszów Lubelski', NULL),
(723, 'S262', 'Siedlce', NULL),
(724, 'S263', 'Strzelce Krajeńskie', NULL),
(725, 'S264', 'Grójec', NULL),
(726, 'S265', 'Bytom', NULL),
(727, 'S266', 'Rabka Zdrój', NULL),
(728, 'S267', 'Brzeg 3', NULL),
(729, 'S268', 'Lublin 3', NULL),
(730, 'S269', 'Ełk 2', NULL),
(731, 'S270', 'Wrocław 4', NULL),
(732, 'S272', 'Ruda Śląska', NULL),
(733, 'S274', 'Bydgoszcz 2', NULL),
(734, 'S275', 'Ostrowiec Świętokrzyski', NULL),
(735, 'S277', 'Dębno', NULL),
(736, 'S280', 'Kutno 2', NULL),
(737, 'S281', 'Oleśnica', NULL),
(738, 'S284', 'Częstochowa', NULL),
(739, 'S285', 'Poznań 3', NULL),
(740, 'S287', 'Tomaszów Mazowiecki 2', NULL),
(741, 'S288', 'Warka', NULL),
(742, 'S289', 'Rypin 2', NULL),
(743, 'S290', 'Białystok', NULL),
(744, 'S291', 'Białystok 2', NULL),
(745, 'S292', 'Bielsk Podlaski', NULL),
(746, 'S293', 'Biłgoraj', NULL),
(747, 'S294', 'Częstochowa 2', NULL),
(748, 'S295', 'Dąbrowa Tarnowska', NULL),
(749, 'S296', 'Garwolin', NULL),
(750, 'S298', 'Hrubieszów', NULL),
(751, 'S299', 'Kielce 3', NULL),
(752, 'S300', 'Knurów', NULL),
(753, 'S301', 'Kościan 3', NULL),
(754, 'S302', 'Kozienice', NULL),
(755, 'S305', 'Lesko', NULL),
(756, 'S306', 'Lublin 4', NULL),
(757, 'S307', 'Lubliniec', NULL),
(758, 'S309', 'Łomianki', NULL),
(759, 'S311', 'Międzyrzec Podlaski', NULL),
(760, 'S312', 'Mikołów', NULL),
(761, 'S313', 'Morąg', NULL),
(762, 'S314', 'Myślibórz', NULL),
(763, 'S315', 'Nowa Sól 3', NULL),
(764, 'S316', 'Oświęcim', NULL),
(765, 'S317', 'Parczew', NULL),
(766, 'S318', 'Pisz', NULL),
(767, 'S319', 'Rzeszów', NULL),
(768, 'S320', 'Sandomierz', NULL),
(769, 'S321', 'Siemiatycze', NULL),
(770, 'S322', 'Skierniewice', NULL),
(771, 'S323', 'Sokołów Podlaski', NULL),
(772, 'S324', 'Starachowice', NULL),
(773, 'S326', 'Staszów', NULL),
(774, 'S327', 'Szczytno 2', NULL),
(775, 'S329', 'Trzebnica', NULL),
(776, 'S330', 'Turek 3', NULL),
(777, 'S332', 'Wieruszów 2', NULL),
(778, 'S333', 'Wołów', NULL),
(779, 'S335', 'Zamość', NULL),
(780, 'S336', 'Zawiercie', NULL),
(781, 'S338', 'Drawsko 2', NULL),
(782, 'S340', 'Koło 3', NULL),
(783, 'S341', 'Wieluń', NULL),
(784, 'S342', 'Dębica', NULL),
(785, 'S343', 'Mogilno', NULL),
(786, 'S344', 'Nowy Dwór Mazowiecki 2', NULL),
(787, 'S346', 'Siedlce 2', NULL),
(788, 'S347', 'Głuchołazy', NULL),
(789, 'S348', 'Bydgoszcz 3', NULL),
(790, 'S349', 'Bochnia', NULL),
(791, 'S350', 'Nowa Ruda', NULL),
(792, 'S351', 'Ostrowiec Świętokrzyski 2', NULL),
(793, 'S353', 'Jastrzębie Zdrój', NULL),
(794, 'S354', 'Łęczna', NULL),
(795, 'S355', 'Rogoźno', NULL),
(796, 'S356', 'Biała Podlaska', NULL),
(797, 'S357', 'Toruń 2', NULL),
(798, 'S359', 'Iława', NULL),
(799, 'S360', 'Piotrków Trybunalski', NULL),
(800, 'S361', 'Mińsk Mazowiecki', NULL),
(801, 'S362', 'Środa Wlkp.2', NULL),
(802, 'S363', 'Jarosław', NULL),
(803, 'S364', 'Kościerzyna 3', NULL),
(804, 'S365', 'Głubczyce', NULL),
(805, 'S366', 'Chełm', NULL),
(806, 'S367', 'Piekary Śląskie', NULL),
(807, 'S368', 'Czerwionka-Leszczyny', NULL),
(808, 'S369', 'Poznań 4', NULL),
(809, 'S370', 'Łódź', NULL),
(810, 'S371', 'Złotoryja', NULL),
(811, 'S372', 'Pruszcz Gdański', NULL),
(812, 'S373', 'Kluczbork', NULL),
(813, 'S374', 'Łęczyca', NULL),
(814, 'S375', 'Nowy Targ', NULL),
(815, 'S376', 'Suwałki', NULL),
(816, 'S377', 'Rawa Mazowiecka', NULL),
(817, 'S378', 'Puławy', NULL),
(818, 'S379', 'Chrzanów', NULL),
(819, 'S380', 'Myślenice', NULL),
(820, 'S381', 'Końskie 2', NULL),
(821, 'S382', 'Olesno', NULL),
(822, 'S383', 'Pszczyna', NULL),
(823, 'S384', 'Radomsko 2', NULL),
(824, 'S386', 'Krosno', NULL),
(825, 'S387', 'Lubartów', NULL),
(826, 'S389', 'Przemyśl', NULL),
(827, 'S391', 'Mszana Dolna', NULL),
(828, 'S392', 'Gostynin', NULL),
(829, 'S393', 'Ostróda', NULL),
(830, 'S394', 'Żywiec', NULL),
(831, 'S395', 'Cieszyn', NULL),
(832, 'S396', 'Rzeszów 2', NULL),
(833, 'S397', 'Limanowa', NULL),
(834, 'S398', 'Będzin', NULL),
(835, 'S399', 'Gorzów Wielkopolski 2', NULL),
(836, 'S401', 'Mysłowice', NULL),
(837, 'S402', 'Sanok', NULL),
(838, 'S403', 'Marki', NULL),
(839, 'S404', 'Podkowa Leśna', NULL),
(840, 'S407', 'Łódź 2', NULL),
(841, 'S409', 'Konin', NULL),
(842, 'S410', 'Bydgoszcz 4', NULL),
(843, 'S411', 'Sztum', NULL),
(844, 'S412', 'Kłobuck', NULL),
(845, 'S413', 'Płock 1', NULL),
(846, 'S415', 'Radom 3', NULL),
(847, 'S416', 'Żmigród', NULL),
(848, 'S419', 'Siemianowice Śląskie', NULL),
(849, 'S421', 'Kraków-Węgrzce', NULL),
(850, 'S422', 'Gdańsk', NULL),
(851, 'S423', 'Wołomin', NULL),
(852, 'S425', 'Puck', NULL),
(853, 'S426', 'Gołdap', NULL),
(854, 'S427', 'Toruń 3', NULL),
(855, 'S428', 'Gdańsk 2', NULL),
(856, 'S429', 'Gdynia', NULL),
(857, 'S431', 'Łódź 4', NULL),
(858, 'S432', 'Sławno', NULL),
(859, 'S435', 'Bydgoszcz 5', NULL),
(860, 'S437', 'Police', NULL),
(861, 'S438', 'Sulechów', NULL),
(862, 'S440', 'Łask 2', NULL),
(863, 'S441', 'Białystok 3', NULL),
(864, 'S442', 'Poznań 5', NULL),
(865, 'S443', 'Świdnik', NULL),
(866, 'S444', 'Płock 2', NULL),
(867, 'S445', 'Brzeg Dolny', NULL),
(868, 'S446', 'Węgorzewo', NULL),
(869, 'S447', 'Pszów', NULL),
(870, 'S448', 'Świebodzice', NULL),
(871, 'S449', 'Łobez 2', NULL),
(872, 'S451', 'Jelenia Góra 3', NULL),
(873, 'S452', 'Kamienna Góra 2', NULL),
(874, 'S454', 'Lublin 5', NULL),
(875, 'S455', 'Stalowa Wola 2', NULL),
(876, 'S457', 'Żagań 2', NULL),
(877, 'S458', 'Chełm 2', NULL),
(878, 'S459', 'Wodzisław Śląski', NULL),
(879, 'S460', 'Świętochłowice', NULL),
(880, 'S461', 'Chorzów', NULL),
(881, 'S462', 'Zawadzkie', NULL),
(882, 'S463', 'Krasnystaw 2', NULL),
(883, 'S464', 'Bolesławiec 2', NULL),
(884, 'S467', 'Pyskowice', NULL),
(885, 'S468', 'Brzeziny', NULL),
(886, 'S469', 'Olsztyn', NULL),
(887, 'S470', 'Chełmża 2', NULL),
(888, 'S471', 'Luboń', NULL),
(889, 'S473', 'Lubaczów', NULL),
(890, 'S474', 'Głogów 2', NULL),
(891, 'S475', 'Szydłowiec', NULL),
(892, 'S476', 'Zgierz 2', NULL),
(893, 'S477', 'Szczecin', NULL),
(894, 'S479', 'Szczecin 2', NULL),
(895, 'S480', 'Radlin', NULL),
(896, 'S481', 'Leszno 3', NULL),
(897, 'S482', 'Pruszków', NULL),
(898, 'S483', 'Paczków', NULL),
(899, 'S484', 'Wronki', NULL),
(900, 'S485', 'Gdańsk 3', NULL),
(901, 'S486', 'Kolno', NULL),
(902, 'S487', 'Tarnowskie Góry 2', NULL),
(903, 'S488', 'Bielsko Biała 2', NULL),
(904, 'S489', 'Błonie', NULL),
(905, 'S491', 'Grodków', NULL),
(906, 'S492', 'Grodzisk Mazowiecki', NULL),
(907, 'S493', 'Jastrowie', NULL),
(908, 'S494', 'Legionowo', NULL),
(909, 'S495', 'Nowy Tomyśl 2', NULL),
(910, 'S497', 'Piastów', NULL),
(911, 'S500', 'Radzionków', NULL),
(912, 'S501', 'Radzyń Podlaski 2', NULL),
(913, 'S504', 'Sosnowiec', NULL),
(914, 'S505', 'Śrem 2', NULL),
(915, 'S507', 'Wąbrzeźno 2', NULL),
(916, 'S509', 'Wrocław 5', NULL),
(917, 'S510', 'Twardogóra', NULL),
(918, 'S512', 'Nowe', NULL),
(919, 'S515', 'Łódź 5', NULL),
(920, 'S516', 'Wisła', NULL),
(921, 'S517', 'Połaniec', NULL),
(922, 'S518', 'Skawina', NULL),
(923, 'S520', 'Środa Śląska', NULL),
(924, 'S521', 'Dobczyce', NULL),
(925, 'S522', 'Nowe Miasto Lubawskie 2', NULL),
(926, 'S523', 'Siechnice', NULL),
(927, 'S530', 'Dynów', NULL),
(928, 'S531', 'Gorlice', NULL),
(929, 'S533', 'Jasło 2', NULL),
(930, 'S534', 'Kańczuga', NULL),
(931, 'S537', 'Kolbuszowa', NULL),
(932, 'S539', 'Kraków 3', NULL),
(933, 'S542', 'Leżajsk', NULL),
(934, 'S545', 'Krosno 4', NULL),
(935, 'S547', 'Nisko', NULL),
(936, 'S548', 'Nowy Sącz 2', NULL),
(937, 'S552', 'Rzeszów 3', NULL),
(938, 'S558', 'Strzyżów', NULL),
(939, 'S560', 'Tarnów', NULL),
(940, 'S561', 'Tarnów 2', NULL),
(941, 'S562', 'Zakopane', NULL),
(942, 'S564', 'Namysłów 2', NULL),
(943, 'S565', 'Nidzica 2', NULL),
(944, 'S566', 'Pniewy', NULL),
(945, 'S567', 'Opalenica', NULL),
(946, 'S569', 'Jaworzno', NULL),
(947, 'S571', 'Andrychów 2', NULL),
(948, 'S572', 'Witnica', NULL),
(949, 'S573', 'Warszawa', NULL),
(950, 'S574', 'Libiąż', NULL),
(951, 'S575', 'Poznań 6', NULL),
(952, 'S576', 'Orneta', NULL),
(953, 'S577', 'Jędrzejów 2', NULL),
(954, 'S578', 'Trzebinia', NULL),
(955, 'S580', 'Sosnowiec 2', NULL),
(956, 'S582', 'Praszka', NULL),
(957, 'S584', 'Żory 2', NULL),
(958, 'S585', 'Kudowa-Zdrój', NULL),
(959, 'S586', 'Kraków 4', NULL),
(960, 'S588', 'Szczecin 3', NULL),
(961, 'S590', 'Radom 4', NULL),
(962, 'S591', 'Bytów 2', NULL),
(963, 'S592', 'Warszawa 2', NULL),
(964, 'S593', 'Płońsk 2', NULL),
(965, 'S596', 'Władysławowo', NULL),
(966, 'S598', 'Sokółka', NULL),
(967, 'S602', 'Zamość 2', NULL),
(968, 'S605', 'Warszawa 4', NULL),
(969, 'S606', 'Warszawa 5', NULL),
(970, 'S607', 'Milicz', NULL),
(971, 'S608', 'Kruszwica', NULL),
(972, 'S610', 'Oława 2', NULL),
(973, 'S611', 'Rybnik 2', NULL),
(974, 'S612', 'Konstantynów Łódzki', NULL),
(975, 'S613', 'Gdańsk 4', NULL),
(976, 'S614', 'Jelcz-Laskowice 2', NULL),
(977, 'S615', 'Grodzisk Wielkopolski 2', NULL),
(978, 'S616', 'Lidzbark', NULL),
(979, 'S617', 'Skoczów', NULL),
(980, 'S618', 'Głogówek', NULL),
(981, 'S619', 'Ruda Śląska 3', NULL),
(982, 'S620', 'Warszawa 6', NULL),
(983, 'S621', 'Aleksandrów Łódzki', NULL),
(984, 'S622', 'Pajęczno', NULL),
(985, 'S623', 'Barcin', NULL),
(986, 'S624', 'Oborniki', NULL),
(987, 'S625', 'Chojna', NULL),
(988, 'S626', 'Lubsko', NULL),
(989, 'S627', 'Gorlice 3', NULL),
(990, 'S628', 'Boguszów-Gorce', NULL),
(991, 'S629', 'Pabianice 2', NULL),
(992, 'S631', 'Tychy', NULL),
(993, 'S632', 'Ciechanów 2', NULL),
(994, 'S633', 'Łomża 2', NULL),
(995, 'S634', 'Ożarów Mazowiecki', NULL),
(996, 'S635', 'Poznań 7', NULL),
(997, 'S636', 'Koronowo', NULL),
(998, 'S638', 'Przemyśl 3', NULL),
(999, 'S639', 'Żyrardów 2', NULL),
(1000, 'S640', 'Brodnica 4', NULL),
(1001, 'S641', 'Jarosław 2', NULL),
(1002, 'S642', 'Kędzierzyn Koźle 2', NULL),
(1003, 'S643', 'Chorzów 2', NULL),
(1004, 'S644', 'Swarzędz', NULL),
(1005, 'S646', 'Dąbrowa Białostocka', NULL),
(1006, 'S647', 'Warszawa 7', NULL),
(1007, 'S648', 'Braniewo 2', NULL),
(1008, 'S649', 'Myszków 2', NULL),
(1009, 'S650', 'Niepołomice', NULL),
(1010, 'S651', 'Zielona Góra 3', NULL),
(1011, 'S653', 'Pułtusk 2', NULL),
(1012, 'S655', 'Jawor 2', NULL),
(1013, 'S661', 'Wieliczka', NULL),
(1014, 'S662', 'Opatów', NULL),
(1015, 'S665', 'Wrocław 6', NULL),
(1016, 'S666', 'Wysokie Mazowieckie', NULL),
(1017, 'S667', 'Łomża 3', NULL),
(1018, 'S668', 'Otwock', NULL),
(1019, 'S669', 'Żarów', NULL),
(1020, 'S670', 'Góra 2', NULL),
(1021, 'S671', 'Wałbrzych 3', NULL),
(1022, 'S672', 'Chrzanów 2', NULL),
(1023, 'S674', 'Bytom 3', NULL),
(1024, 'S675', 'Chełmno 2', NULL),
(1025, 'S676', 'Maków Mazowiecki 2', NULL),
(1026, 'S677', 'Sejny', NULL),
(1027, 'S678', 'Szczecin 4', NULL),
(1028, 'S679', 'Skarżysko-Kamienna 2', NULL),
(1029, 'S681', 'Lubawa', NULL),
(1030, 'S683', 'Drezdenko', NULL),
(1031, 'S684', 'Ełk 3', NULL),
(1032, 'S687', 'Skarszewy', NULL),
(1033, 'S689', 'Gdańsk 5', NULL),
(1034, 'S690', 'Warszawa 8', NULL),
(1035, 'S691', 'Łosice', NULL),
(1036, 'S696', 'Rzgów', NULL),
(1037, 'S697', 'Pasłęk', NULL),
(1038, 'S699', 'Gdynia 2', NULL),
(1039, 'S700', 'Lidzbark Warmiński', NULL),
(1040, 'S701', 'Nakło 2', NULL),
(1041, 'S702', 'Płock 3', NULL),
(1042, 'S703', 'Nowa Sarzyna', NULL),
(1043, 'S704', 'Zielonka', NULL),
(1044, 'S706', 'Rydułtowy', NULL),
(1045, 'S707', 'Mława 2', NULL),
(1046, 'S708', 'Łuków 2', NULL),
(1047, 'S709', 'Kraków 5', NULL),
(1048, 'S710', 'Pelplin', NULL),
(1049, 'S711', 'Tczew 3', NULL),
(1050, 'S712', 'Szczecin 5', NULL),
(1051, 'S713', 'Olsztynek', NULL),
(1052, 'S714', 'Koszalin 2', NULL),
(1053, 'S715', 'Mielec 2', NULL),
(1054, 'S716', 'Bełchatów 2', NULL),
(1055, 'S717', 'Łaziska Górne', NULL),
(1056, 'S718', 'Barczewo', NULL),
(1057, 'S720', 'Rumia', NULL),
(1058, 'S721', 'Tarnobrzeg 3', NULL),
(1059, 'S722', 'Kraśnik 2', NULL),
(1060, 'S723', 'Łódź 6', NULL),
(1061, 'S724', 'Warszawa 9', NULL),
(1062, 'S725', 'Bielsko Biała 3', NULL),
(1063, 'S726', 'Kraków 6', NULL),
(1064, 'S727', 'Białystok 4', NULL),
(1065, 'S728', 'Katowice 5', NULL),
(1066, 'S729', 'Piaseczno', NULL),
(1067, 'S730', 'Sosnowiec 3', NULL),
(1068, 'S731', 'Warszawa 10', NULL),
(1069, 'S732', 'Wrocław 7', NULL),
(1070, 'S733', 'Suwałki 2', NULL),
(1071, 'S734', 'Puławy 2', NULL),
(1072, 'S735', 'Trzcianka 2', NULL),
(1073, 'S736', 'Janki', NULL),
(1074, 'S738', 'Nowy Sącz 3', NULL),
(1075, 'S739', 'Otwock 2', NULL),
(1076, 'S740', 'Piotrków Trybunalski 2', NULL),
(1077, 'S741', 'Warszawa 11', NULL),
(1078, 'S742', 'Ruda Śląska 4', NULL),
(1079, 'S743', 'Limanowa 3', NULL),
(1080, 'S746', 'Gliwice 3', NULL),
(1081, 'S752', 'Warszawa 12', NULL),
(1082, 'S753', 'Warszawa 13', NULL),
(1083, 'S756', 'Katowice 6', NULL),
(1084, 'S757', 'Kartuzy', NULL),
(1085, 'S759', 'Nowy Dwór Gdański', NULL),
(1086, 'S760', 'Radzymin', NULL),
(1087, 'S761', 'Sosnowiec 4', NULL),
(1088, 'S763', 'Łańcut', NULL),
(1089, 'S765', 'Sędziszów Małopolski', NULL),
(1090, 'S768', 'Łany', NULL),
(1091, 'S769', 'Kłodawa', NULL),
(1092, 'S770', 'Jarocin 3', NULL),
(1093, 'S771', 'Legnica 3', NULL),
(1094, 'S772', 'Białogard 3', NULL),
(1095, 'S774', 'Prabuty', NULL),
(1096, 'S775', 'Skarżysko-Kamienna 3', NULL),
(1097, 'S776', 'Lubin 2', NULL),
(1098, 'S777', 'Wągrowiec 2', NULL),
(1099, 'S779', 'Kraków 7', NULL),
(1100, 'S780', 'Bielawa', NULL),
(1101, 'S781', 'Kołobrzeg 2', NULL),
(1102, 'S783', 'Ustka', NULL),
(1103, 'S784', 'Koluszki', NULL),
(1104, 'S785', 'Gliwice 2', NULL),
(1105, 'S786', 'Pionki', NULL),
(1106, 'S787', 'Kraków 8', NULL),
(1107, 'S788', 'Mielec 3', NULL),
(1108, 'S790', 'Żywiec 2', NULL),
(1109, 'S791', 'Lubawa 2', NULL),
(1110, 'S792', 'Brzozów 2', NULL),
(1111, 'S794', 'Stargard 5', NULL),
(1112, 'S795', 'Zabrze', NULL),
(1113, 'S796', 'Ozorków 2', NULL),
(1114, 'S797', 'Czechowice-Dziedzice 2', NULL),
(1115, 'S798', 'Ustrzyki Dolne 2', NULL),
(1116, 'S799', 'Lwówek Śląski 2', NULL),
(1117, 'S821', 'Wschowa 2', NULL),
(1118, 'S822', 'Sucha Beskidzka 2', NULL),
(1119, 'S823', 'Przasnysz 2', NULL),
(1120, 'S824', 'Brzesko 2', NULL),
(1121, 'S825', 'Łapy 2', NULL),
(1122, 'S826', 'Elbląg 3', NULL),
(1123, 'S827', 'Suchy Las', NULL),
(1124, 'S828', 'Świebodzin 2', NULL),
(1125, 'S829', 'Ostrzeszów 2', NULL),
(1126, 'S831', 'Wąbrzeźno 3', NULL),
(1127, 'S832', 'Żnin 2', NULL),
(1128, 'S833', 'Iława 2', NULL),
(1129, 'S835', 'Prudnik 2', NULL),
(1130, 'S837', 'Libiąż 2', NULL),
(1131, 'S839', 'Zambrów 2', NULL),
(1132, 'S840', 'Jabłonna', NULL),
(1133, 'S841', 'Ustroń', NULL),
(1134, 'S843', 'Busko Zdrój 4', NULL),
(1135, 'S844', 'Pińczów 2', NULL),
(1136, 'S845', 'Jasło 4', NULL),
(1137, 'S846', 'Sędziszów Świętokrzyski', NULL),
(1138, 'S847', 'Gostynin 2', NULL),
(1139, 'S851', 'Olkusz 2', NULL),
(1140, 'S852', 'Przeworsk', NULL),
(1141, 'S854', 'Toruń 4', NULL),
(1142, 'S856', 'Biała Podlaska 2', NULL),
(1143, 'S857', 'Dawidy Bankowe', NULL),
(1144, 'S858', 'Koszalin 3', NULL),
(1145, 'S861', 'Sochaczew 3', NULL),
(1146, 'S863', 'Bełchatów 3', NULL),
(1147, 'S864', 'Krotoszyn 3', NULL),
(1148, 'S865', 'Września 4', NULL),
(1149, 'S866', 'Świnoujście 4', NULL),
(1150, 'S867', 'Goleniów 2', NULL),
(1151, 'S868', 'Kamień Pomorski 2', NULL),
(1152, 'S869', 'Nowogard 3', NULL),
(1153, 'S870', 'Gryfice 4', NULL),
(1154, 'S871', 'Międzyzdroje 2', NULL),
(1155, 'S872', 'Świnoujście 5', NULL),
(1156, 'S873', 'Ropczyce 2', NULL),
(1157, 'S874', 'Lubaczów 3', NULL),
(1158, 'S875', 'Myszków 3', NULL),
(1159, 'S876', 'Zawiercie 2', NULL),
(1160, 'S877', 'Strzyżów 2', NULL),
(1161, 'S878', 'Grodzisk Wielkopolski 3', NULL),
(1162, 'S879', 'Ciechocinek', NULL),
(1163, 'S881', 'Stalowa Wola 4', NULL),
(1164, 'S883', 'Kraków 9', NULL),
(1165, 'S884', 'Sierpc 2', NULL),
(1166, 'S885', 'Kępno 2', NULL),
(1167, 'S886', 'Wojkowice', NULL),
(1168, 'S887', 'Krapkowice 2', NULL),
(1169, 'S888', 'Gorzów Wielkopolski 3', NULL),
(1170, 'S889', 'Opole 3', NULL),
(1171, 'S890', 'Swarzędz 2', NULL),
(1172, 'S891', 'Oleśnica 2', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Naprawy`
--

CREATE TABLE `Naprawy` (
  `IDNaprawy` int NOT NULL,
  `IDDostawcy` int DEFAULT NULL,
  `IDLokalizacji` int DEFAULT NULL,
  `IDModeluDrukarki` int DEFAULT NULL,
  `Kwota` decimal(10,2) DEFAULT NULL,
  `DataNaprawy` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Naprawy`
--

INSERT INTO `Naprawy` (`IDNaprawy`, `IDDostawcy`, `IDLokalizacji`, `IDModeluDrukarki`, `Kwota`, `DataNaprawy`) VALUES
(3, 1, 2, 2, 500.00, '2024-02-01'),
(4, 1, 1, 1, 150.00, '2024-02-01');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Tonery`
--

CREATE TABLE `Tonery` (
  `IDToneru` int NOT NULL,
  `IDLokalizacji` int DEFAULT NULL,
  `Kwota` decimal(10,2) DEFAULT NULL,
  `Ilosc` int DEFAULT NULL,
  `Suma` decimal(10,2) DEFAULT NULL,
  `Data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Tonery`
--

INSERT INTO `Tonery` (`IDToneru`, `IDLokalizacji`, `Kwota`, `Ilosc`, `Suma`, `Data`) VALUES
(4, 2, 180.00, 5, 900.00, '2024-02-01'),
(5, 603, 180.00, 5, 900.00, '2022-12-01');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `Uzytkownicy`
--

CREATE TABLE `Uzytkownicy` (
  `UzytkownikID` int NOT NULL,
  `Imie` varchar(50) DEFAULT NULL,
  `Nazwisko` varchar(50) DEFAULT NULL,
  `Login` varchar(50) DEFAULT NULL,
  `Haslo` varchar(32) DEFAULT NULL,
  `Rola` enum('Admin','Uzytkownik') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Uzytkownicy`
--

INSERT INTO `Uzytkownicy` (`UzytkownikID`, `Imie`, `Nazwisko`, `Login`, `Haslo`, `Rola`) VALUES
(1, 'Damian', 'Lamonski', 'dlam00', '75f3cd7d38e5f3bcdddffc0e2dc85040', 'Admin'),
(2, 'Jacek', 'Kurnikowski', 'jkur00', 'b8259e4b2f46f4266dab304428a39996', 'Uzytkownik');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `Dostawca`
--
ALTER TABLE `Dostawca`
  ADD PRIMARY KEY (`IDDostawcy`);

--
-- Indeksy dla tabeli `DrukarkiInwentaryzacja`
--
ALTER TABLE `DrukarkiInwentaryzacja`
  ADD PRIMARY KEY (`IDdrukarki`),
  ADD KEY `IDDostawcy` (`IDDostawcy`),
  ADD KEY `DrukarkiCentrala_ibfk_2` (`IDModeluDrukarki`),
  ADD KEY `DrukarkiCentrala_ibfk_4` (`IDLokalizacji`);

--
-- Indeksy dla tabeli `DrukarkiModele`
--
ALTER TABLE `DrukarkiModele`
  ADD PRIMARY KEY (`IDdrukarki`);

--
-- Indeksy dla tabeli `Dzierzawa`
--
ALTER TABLE `Dzierzawa`
  ADD PRIMARY KEY (`IDDzierzawy`),
  ADD KEY `IDDostawcy` (`IDDostawcy`),
  ADD KEY `Dzierzawa_ibfk_1` (`IDDrukarki`);

--
-- Indeksy dla tabeli `Lokalizacja`
--
ALTER TABLE `Lokalizacja`
  ADD PRIMARY KEY (`IDLokalizacji`);

--
-- Indeksy dla tabeli `Naprawy`
--
ALTER TABLE `Naprawy`
  ADD PRIMARY KEY (`IDNaprawy`),
  ADD KEY `IDDostawcy` (`IDDostawcy`),
  ADD KEY `Naprawy_ibfk_3` (`IDLokalizacji`),
  ADD KEY `Naprawy_ibfk_2` (`IDModeluDrukarki`);

--
-- Indeksy dla tabeli `Tonery`
--
ALTER TABLE `Tonery`
  ADD PRIMARY KEY (`IDToneru`),
  ADD KEY `Lokalizacja` (`IDLokalizacji`);

--
-- Indeksy dla tabeli `Uzytkownicy`
--
ALTER TABLE `Uzytkownicy`
  ADD PRIMARY KEY (`UzytkownikID`),
  ADD UNIQUE KEY `Login` (`Login`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Dostawca`
--
ALTER TABLE `Dostawca`
  MODIFY `IDDostawcy` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `DrukarkiInwentaryzacja`
--
ALTER TABLE `DrukarkiInwentaryzacja`
  MODIFY `IDdrukarki` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `DrukarkiModele`
--
ALTER TABLE `DrukarkiModele`
  MODIFY `IDdrukarki` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Dzierzawa`
--
ALTER TABLE `Dzierzawa`
  MODIFY `IDDzierzawy` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `Lokalizacja`
--
ALTER TABLE `Lokalizacja`
  MODIFY `IDLokalizacji` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1173;

--
-- AUTO_INCREMENT for table `Naprawy`
--
ALTER TABLE `Naprawy`
  MODIFY `IDNaprawy` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `Tonery`
--
ALTER TABLE `Tonery`
  MODIFY `IDToneru` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Uzytkownicy`
--
ALTER TABLE `Uzytkownicy`
  MODIFY `UzytkownikID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `DrukarkiInwentaryzacja`
--
ALTER TABLE `DrukarkiInwentaryzacja`
  ADD CONSTRAINT `DrukarkiInwentaryzacja_ibfk_1` FOREIGN KEY (`IDDostawcy`) REFERENCES `Dostawca` (`IDDostawcy`),
  ADD CONSTRAINT `DrukarkiInwentaryzacja_ibfk_2` FOREIGN KEY (`IDModeluDrukarki`) REFERENCES `DrukarkiModele` (`IDdrukarki`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `DrukarkiInwentaryzacja_ibfk_4` FOREIGN KEY (`IDLokalizacji`) REFERENCES `Lokalizacja` (`IDLokalizacji`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `Dzierzawa`
--
ALTER TABLE `Dzierzawa`
  ADD CONSTRAINT `Dzierzawa_ibfk_1` FOREIGN KEY (`IDDrukarki`) REFERENCES `DrukarkiInwentaryzacja` (`IDdrukarki`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `Dzierzawa_ibfk_2` FOREIGN KEY (`IDDostawcy`) REFERENCES `Dostawca` (`IDDostawcy`);

--
-- Constraints for table `Naprawy`
--
ALTER TABLE `Naprawy`
  ADD CONSTRAINT `Naprawy_ibfk_1` FOREIGN KEY (`IDDostawcy`) REFERENCES `Dostawca` (`IDDostawcy`),
  ADD CONSTRAINT `Naprawy_ibfk_2` FOREIGN KEY (`IDModeluDrukarki`) REFERENCES `DrukarkiModele` (`IDdrukarki`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `Naprawy_ibfk_3` FOREIGN KEY (`IDLokalizacji`) REFERENCES `Lokalizacja` (`IDLokalizacji`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `Tonery`
--
ALTER TABLE `Tonery`
  ADD CONSTRAINT `Lokalizacja` FOREIGN KEY (`IDLokalizacji`) REFERENCES `Lokalizacja` (`IDLokalizacji`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
