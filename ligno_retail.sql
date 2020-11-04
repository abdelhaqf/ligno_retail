-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 04, 2020 at 02:22 AM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.3.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ligno_retail`
--

-- --------------------------------------------------------

--
-- Table structure for table `distributor`
--

CREATE TABLE `distributor` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `city` varchar(32) NOT NULL,
  `shipping` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `distributor`
--

INSERT INTO `distributor` (`id`, `name`, `city`, `shipping`) VALUES
(1, 'abdel', 'tangerang', 0),
(2, 'wildan', 'tangerang', 0),
(3, 'mansyur', 'tangerang', 0),
(4, 'robet andika', 'bandung', 1000),
(5, 'azizah', 'lampung', 2000);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  `distributor_id` int(11) NOT NULL,
  `taken` int(11) NOT NULL,
  `total_price` int(11) NOT NULL,
  `note` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`id`, `date`, `distributor_id`, `taken`, `total_price`, `note`) VALUES
(1, '2020-09-01 00:00:00', 1, 0, 90000, 'sept 01 \n450ml x10\nRp 90.000'),
(2, '2020-09-01 00:00:00', 3, 1, 50000, '1 sept\nsudah ambil\n5L x1\nRp 50.000'),
(3, '2020-09-04 00:00:00', 1, 0, 50000, '4 Sept\nRp 50.000\nbelum ambil\n5L x1'),
(5, '2020-10-01 00:00:00', 4, 1, 945000, '-'),
(6, '2020-10-03 00:00:00', 5, 1, 1980000, ''),
(7, '2021-01-02 00:00:00', 1, 1, 9000, ''),
(8, '2019-11-01 00:00:00', 4, 0, 18900, '');

-- --------------------------------------------------------

--
-- Table structure for table `transaction_detail`
--

CREATE TABLE `transaction_detail` (
  `detail_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `product` varchar(128) NOT NULL,
  `netto` int(11) NOT NULL,
  `base_price` int(11) NOT NULL,
  `shipping` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `final_price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `transaction_detail`
--

INSERT INTO `transaction_detail` (`detail_id`, `transaction_id`, `product`, `netto`, `base_price`, `shipping`, `qty`, `final_price`) VALUES
(1, 1, 'LIGNO Dish Soap', 450, 9000, 0, 10, 9000),
(2, 2, 'LIGNO Dish Soap', 5000, 50000, 0, 1, 50000),
(3, 3, 'LIGNO Dish Soap', 5000, 50000, 0, 1, 50000),
(5, 5, 'LIGNO Dish Soap', 450, 9000, 1000, 100, 9450),
(6, 6, 'LIGNO Dish Soap', 450, 9000, 2000, 200, 9900),
(7, 7, 'LIGNO Dish Soap', 450, 9000, 0, 1, 9000),
(8, 8, 'LIGNO Dish Soap', 450, 9000, 1000, 2, 9450);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `distributor`
--
ALTER TABLE `distributor`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD PRIMARY KEY (`detail_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `distributor`
--
ALTER TABLE `distributor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
