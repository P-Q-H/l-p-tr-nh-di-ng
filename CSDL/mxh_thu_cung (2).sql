-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 29, 2025 at 05:51 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mxh_thu_cung`
--

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `user_id`, `post_id`, `created_at`, `updated_at`) VALUES
(10, 20, 21, NULL, NULL),
(21, 20, 17, NULL, NULL),
(25, 20, 18, NULL, NULL),
(26, 20, 15, NULL, NULL),
(28, 19, 14, NULL, NULL),
(36, 13, 21, NULL, NULL),
(37, 13, 19, NULL, NULL),
(38, 13, 18, NULL, NULL),
(39, 13, 17, NULL, NULL),
(40, 13, 15, NULL, NULL),
(41, 13, 14, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2025_09_11_053931_create_users_table', 1),
(2, '2025_09_11_054714_create_sessions_table', 1),
(3, '2025_09_11_072930_create_oauth_auth_codes_table', 2),
(4, '2025_09_11_072931_create_oauth_access_tokens_table', 2),
(5, '2025_09_11_072932_create_oauth_refresh_tokens_table', 2),
(6, '2025_09_11_072933_create_oauth_clients_table', 2),
(7, '2025_09_11_072934_create_oauth_device_codes_table', 2),
(8, '2025_09_13_004755_create_posts_table', 3),
(10, '2025_09_14_174047_create_posts_table', 4),
(11, '2025_09_15_024115_add_language_to_users_table', 5),
(12, '2025_09_16_023631_add_pet_name_to_users_table', 6),
(13, '2025_09_21_075925_add_user_id_to_posts_table', 7),
(14, '2025_09_24_030709_add_like_count_to_posts_table', 8);

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` char(80) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('01631a9d81f589698e4f0ed995eb0641938a1d2561fae28bee9bc6a7cdd459118b50ef80a0dcca26', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 18:07:11', '2025-09-15 18:07:11', '2026-09-16 01:07:11'),
('023533295ebe384f3a3bc381c75bbce1b70fbe54bd2d88c8911eacf7330115f5d524c1c86972600c', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-29 02:34:55', '2025-09-29 02:34:55', '2026-09-29 09:34:55'),
('05319c70efb157c9e464c47f7e21750495516d16b59e6e49b8f8827177a58ce11c870669b7c4deca', 8, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:07:02', '2025-09-12 00:07:02', '2026-09-12 07:07:02'),
('05a371a6ac203dd6ea27ff04d5819eae365b6aa0f9a89f58b7e78fba5735ed70b82124cd55be6969', 14, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 18:57:30', '2025-09-12 18:57:30', '2026-09-13 01:57:30'),
('07cffe8f95beaf27b3eaadf3e7716764709f977005e2bf94949ba2a0b8ec713b96c97523e83cc9e5', 5, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 02:02:57', '2025-09-21 02:02:58', '2026-09-21 09:02:57'),
('087b3dede3e8ea80db9d2f07445737f98041bc428658617b0b65482bb2ae2b0ed55a210c5ef26372', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 18:53:39', '2025-09-14 18:53:39', '2026-09-15 01:53:39'),
('0af9002143f7b9936278b41f1b2e743ab834e69b26eda1d1c3863541f215b95f8750919e1a036e26', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 21:52:47', '2025-09-21 21:52:47', '2026-09-22 04:52:47'),
('0e6ed832f2354613ea1f16147a26c54d31357456cf8ee835580c7bb142da913b3dfcc9da01f5c05c', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 18:33:28', '2025-09-15 18:33:28', '2026-09-16 01:33:28'),
('0fa20be5f8dabb5db75537c6676e6a289f5dfc8034a87b6ad73ebc0d6aecb929c269433c70f69a8b', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-29 02:35:09', '2025-09-29 02:35:09', '2026-09-29 09:35:09'),
('11eae628ab4868e587a225ffce09126b12cb601080735f4baf3f0b2874fe4f975fb14b29f1fc1705', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:01:38', '2025-09-21 22:01:38', '2026-09-22 05:01:38'),
('136bf0028d2d24205f8350e45a39bd17833974698f6f8a2f333d744002394318a1f0908cb2f59005', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:29:09', '2025-09-12 19:29:09', '2026-09-13 02:29:09'),
('15df21a053f5bf46a96833b745a217d6d2dbebd643730c6b47ee2f0486f0c3effdc24b921a38158d', 20, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-23 07:23:44', '2025-09-23 07:23:44', '2026-09-23 14:23:44'),
('16c0804bb1b50c1953086541471a638a76e7149922aa87d8acb79cbca21e241b7e10ed1b1819acbe', 2, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 00:43:38', '2025-09-11 00:43:38', '2026-09-11 07:43:38'),
('1c639141c7df720b13bb7d1ef207ea3a09cd1fb2119f1cd313c91750320470fb7248194a1452f502', 20, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 01:42:03', '2025-09-24 01:42:03', '2026-09-24 08:42:03'),
('1d1a79f3e77e52a2b9023a73e1591c755797600c1bce438743fc6a511a535c53c1c5528b3ec8e657', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 02:48:05', '2025-09-24 02:48:05', '2026-09-24 09:48:05'),
('1f4d593ee84f1b9448526e330194faf8202f4f9110d172024a40a18b0cad0caf36d9a4fde0699418', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 16:07:07', '2025-09-13 16:07:07', '2026-09-13 23:07:07'),
('212860627ed4e485fef65eeecd939c73934300dd18614b642f3e343f54257696d6b5b342b068e555', 18, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-17 17:36:06', '2025-09-17 17:36:06', '2026-09-18 00:36:06'),
('212cb0bbc69273035a1b0fa011724b93adba7cf6b24d134a8b53f29a289bf0200daf89aa971dbe4f', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 04:02:24', '2025-09-13 04:02:24', '2026-09-13 11:02:24'),
('219ca0c225941c722607fb4cc59981e513b983c3d9055dcf436ed613e6a6d336c0d2f50488344667', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:12:23', '2025-09-14 19:12:23', '2026-09-15 02:12:23'),
('22e9e6eb970fd2176ad722f9c931fd424889d25875ee8aecf565ce51d2e4e42faf445ac5e0d51abb', 20, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-23 07:23:54', '2025-09-23 07:23:54', '2026-09-23 14:23:54'),
('2b74b0391a4106b64bc1ecd4825721a4f0e587860a5d6028010050eb13b816979b54a70bdde5f760', 11, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:11:12', '2025-09-12 00:11:12', '2026-09-12 07:11:12'),
('2debaf42533e81c677fe3730f223c21cca6885e739e35c84d24662ca36ec5047121da793559662b0', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 18:15:58', '2025-09-12 18:15:58', '2026-09-13 01:15:58'),
('2e463bdaedce9e86add936d33fcf23cf5b03661020a1b239812b9282e64511d8612820717fd425c5', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 02:47:10', '2025-09-24 02:47:10', '2026-09-24 09:47:10'),
('2e73046c5a08b1d459784c659080f7efb71f7130bfd4fcf58545f0535ce73a4c8f09de9e4300776f', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 00:58:59', '2025-09-13 00:58:59', '2026-09-13 07:58:59'),
('2e8e082c55bc72495ba4b657ecc34d44780f658251abca9d5859d4dea7595a5c899f76ff38ec23f4', 7, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 00:03:50', '2025-09-12 00:04:02', '2026-09-12 07:03:50'),
('2ed13af9409b12933e72916fca72190b2e3dfdd4888cedbed4500e08a3de1ec7304ec52b042404a1', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:37:47', '2025-09-21 22:37:47', '2026-09-22 05:37:47'),
('2f86b74b1f86b40cea430a4e98b075cdbcd5370f491b4f382ccc734d66fa18941b8260a93ddd7b87', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:37:10', '2025-09-12 19:37:10', '2026-09-13 02:37:10'),
('32b14676985490519a41239aae6755ff1b344ccc43b8177fd6980ba6e9d11c6d180e9ebf965f3ad4', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 17:19:52', '2025-09-12 17:20:00', '2026-09-13 00:19:52'),
('34501c9a60209ceb202fa69de0273a273b608ad8d012bbef8c3df397467f78b9e3744ec8f887f868', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 20:26:20', '2025-09-12 20:26:20', '2026-09-13 03:26:20'),
('346b210eb99bf66cd1930594972a41cdac3979bd9c8b0b5cb6334c0c44e2c70de366b1209785efa7', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:40:50', '2025-09-13 01:40:50', '2026-09-13 08:40:50'),
('35336044b9bed9a321d04c20c2f713ed968eccc140259b039bcf45c795c33263a8928bda08a3c68d', 3, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 01:12:18', '2025-09-11 01:12:18', '2026-09-11 08:12:18'),
('3562cb1679145b80daf917bd76fc6aee0028276127c24af9de0c511642878bdf3133cecc0eb3bcc7', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:32:59', '2025-09-14 19:32:59', '2026-09-15 02:32:59'),
('3cf534ccb9846fe4c805453db8f9203f79903020aa1626923a63ae3c1b5bb63bc1f3705b7c6ab045', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:45:10', '2025-09-14 19:45:10', '2026-09-15 02:45:10'),
('43762b34a3b3e453fcc19822a9584dcfd0fb8718bcdcf70ec1d22e951ede0a1195e8769b0f5ac3f9', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 16:31:08', '2025-09-13 16:31:08', '2026-09-13 23:31:08'),
('4ef477fa4e4e891c4c158893ca4bd0810808ecfb4103fb74b55dd53d7be22a925911c960ac19db29', 17, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 19:53:13', '2025-09-15 19:53:13', '2026-09-16 02:53:13'),
('5405ff73234e07a1ab753cbc00fdc8221379d23f811cfecca220f2c3d72ebfe352db13560ea53dae', 2, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 00:43:21', '2025-09-11 00:43:21', '2026-09-11 07:43:21'),
('55b62cd4d6e99edf3eeba2e6a5879f7de21e12b8b8147d3464ee3a3cbdde9b6896a5c1554e522342', 1, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 00:37:53', '2025-09-11 00:37:53', '2026-09-11 07:37:53'),
('591348a4308545e461056936d3733188250b666c7e93ce906faec265a5a05851083f192adbeef4c4', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 02:47:28', '2025-09-24 02:47:28', '2026-09-24 09:47:28'),
('5966a5b4f14cb9a60ec36fc0633e8ff556a0f3e6b49ec2ba5f9c1b0ca3164c826c2dfe2a4194b465', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-18 21:17:08', '2025-09-18 21:17:08', '2026-09-19 04:17:08'),
('5a241d59c69e14ab49c6c028aa48c27ae83aafe9a7c188c0bbc32c9445147f92df43daa67003fe19', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:30:39', '2025-09-14 19:30:39', '2026-09-15 02:30:39'),
('5ba1ac43fad79aaebef54eb4f04f19f3e23b6576cbb49341859a0e0d9b14f344686c127f03f0b746', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 01:43:14', '2025-09-24 01:43:14', '2026-09-24 08:43:14'),
('5e324dbf1db10c86ab25c57d2c5ca83f9a2872fdae12e9640de5567c59a2b548d2d5720c686af448', 10, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:08:24', '2025-09-12 00:08:24', '2026-09-12 07:08:24'),
('63e23c2d609776c091762b0d1084b7eecb267ef896b1c95a2640d6bf04642e252c70e68780441fbb', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:34:09', '2025-09-21 22:34:09', '2026-09-22 05:34:09'),
('6576165d41fad4e9c863167b88893eb7d0a3a4f14706fc4186d11412f153c1005aedc990bbb49e0d', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 21:44:24', '2025-09-12 21:44:24', '2026-09-13 04:44:24'),
('65be2f1eb7af291198c8c9069a0fd69acec7a5516d0f187a9546ea1624d3b3dff5b73f3deda9f0d0', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-22 01:11:19', '2025-09-22 01:11:19', '2026-09-22 08:11:19'),
('65eb6d0c8f3eba9374100ea76e99cb7b8c543550bcfb9d2669e84e03d0019ed4b72d9b55bc0bf386', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:08:17', '2025-09-12 19:08:17', '2026-09-13 02:08:17'),
('6702c8d304dd6c1957ab4908c4565ec6cc331311c5cac95a51631b490963cb6711b27205b8e90c9f', 5, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 20:23:27', '2025-09-11 20:23:27', '2026-09-12 03:23:27'),
('67bc8409143aefa12eed8885678b52b96b4ef63542ffc8e659b295800f7541b4ff919952d840fc9b', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-22 01:47:08', '2025-09-22 01:47:08', '2026-09-22 08:47:08'),
('68e05e7919973e88e4a38fdf089d62da63364a25dfada28d041e6a3171ad7033fe423fb226085a17', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:52:18', '2025-09-12 19:52:18', '2026-09-13 02:52:18'),
('6ac77614ac604d2c10a585acdfecb091ac98450663abaee9f69aaaba5072e394063b5a6ff2f78a76', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:27:30', '2025-09-21 22:27:30', '2026-09-22 05:27:30'),
('6edf4e68a403c49d426fcfdb265548a4cc869392f718d43766388b9080f13c8d7d3349be34828803', 17, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 19:45:53', '2025-09-15 19:45:53', '2026-09-16 02:45:53'),
('70b00f628f77bc4e001d92bf488c6afa930f02917a2c8f4c24976cfa70f43e6ddd1d53442d0b6606', 4, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 19:03:30', '2025-09-11 19:03:30', '2026-09-12 02:03:30'),
('7442a305caa1b5823446ebacb7ac4f121724074e93458a7b0f84c218a2bffc68300eaba88a00c8de', 4, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 20:30:07', '2025-09-11 20:30:07', '2026-09-12 03:30:07'),
('754fbb9c5701ccb9ef03f981b7ecebd12e0c9a6378e60955702d45e57b5aa6c71d378fa6da7e1d69', 12, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:52:28', '2025-09-12 00:52:28', '2026-09-12 07:52:28'),
('759dfc9f9a6198a23e17e8146c53d9084b552b197294ab14d5f8d183c14b2a5d24bf3409c9600cd3', 17, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 21:12:01', '2025-09-15 21:12:01', '2026-09-16 04:12:01'),
('75acacae465e8013c3354d9063e34809d62c3a3c74e82eaf4b7b7a413cfb6293c47e275c54c2936d', 4, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 19:02:27', '2025-09-11 19:02:27', '2026-09-12 02:02:27'),
('7b205ca311711d09d8a923bb6a274874af64bdeaba798878b91eed24c91a6cbe35ed44d7ccf8f8ab', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 17:35:32', '2025-09-12 17:35:36', '2026-09-13 00:35:32'),
('7e9730f629de8b4e52125bc5ef05d4006faf68eabf27340cda6c3d91439a2c1fb6e01a4de6971e18', 1, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 00:41:53', '2025-09-11 00:41:53', '2026-09-11 07:41:53'),
('8150fff6ec884209a815c2434031e7eb5639085d365f782841a72feac930828ebe534d8b6c61e05f', 17, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 19:52:55', '2025-09-15 19:52:55', '2026-09-16 02:52:55'),
('85182013a3b50377fef09f33032ca0509fbfda8edfe020a89ce5fd1c55dca83792a12d46142f4a7b', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 01:41:40', '2025-09-24 01:41:40', '2026-09-24 08:41:40'),
('8c457dfb49a2bd6beb71c5f5bd2caa175d015713437669950cc36410f6d42479d73c2c090333b3eb', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:15:24', '2025-09-21 22:15:24', '2026-09-22 05:15:24'),
('8e463bf8681cebe75cd274e6bff15cd8ea3724487681cb4327d21287d63b2cbb465455b8612b6c20', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:27:36', '2025-09-14 19:27:36', '2026-09-15 02:27:36'),
('9083b92334f54ad208014a3090141d8a349b4da3bf6ed46fea39d9ac580e5f119d2d2c2ac37f3a27', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:12:44', '2025-09-12 19:12:44', '2026-09-13 02:12:44'),
('908c6efbaac08e14ca37efb94fdbcc8402dfc89f5d550afde7642c3ce43ec878eb638fffa11b7f12', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:04:42', '2025-09-21 22:04:42', '2026-09-22 05:04:42'),
('93b7a24d7afca436ce555ae8fbd2ba7351e829b6cad95de3510fe980117cdb089463faa7f133b983', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:51:07', '2025-09-12 19:51:07', '2026-09-13 02:51:07'),
('95ee071d1ef329c00271467eec591441f44a977d17450f08a96627be2d30849202723b02f6657359', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-29 02:27:11', '2025-09-29 02:27:11', '2026-09-29 09:27:11'),
('9987fa74a3be487c79f70f1d43431bd2c077e1ae374cf5d54f454f7d498f99e52bada8df0803eead', 10, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 00:08:31', '2025-09-12 00:08:33', '2026-09-12 07:08:31'),
('9b1324d73788c6218d03a70f223567a108a2343665d27c9a27e70f33aba94588993bea1a75984aaf', 20, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 02:47:46', '2025-09-24 02:47:46', '2026-09-24 09:47:46'),
('9c79c6a51ecf702da6d7ee6ff338a44a94640b04f23bb8244dbb22a17ccb9b2d018415a7baa7c426', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-17 16:31:26', '2025-09-17 16:31:26', '2026-09-17 23:31:26'),
('9d13ca4098f74725dc380b0143210a1b95d1c1dfed9ac04206b8d0b9c4122059e6a912bfe88a8474', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 00:38:06', '2025-09-13 00:38:07', '2026-09-13 07:38:06'),
('a22d3978d7c7c88b9b127913a88c4ff62687d7d2283d32d5d7d382f6cee0c6abe70e8ff44908d0a2', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 21:40:50', '2025-09-12 21:40:51', '2026-09-13 04:40:50'),
('a38b2d637eab6aafd82a6762b4b96b797223e877ae1c359a347d7893ff0f5daeb411518c5a624393', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:34:41', '2025-09-12 19:34:41', '2026-09-13 02:34:41'),
('a822af9d7befbd923ad319f9d0bd114392b83af5c847eec009da95e47e26c09405a1a8080ea4dff3', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:18:48', '2025-09-21 22:18:48', '2026-09-22 05:18:48'),
('a84f658c802412d1a50565d786441a8c3a2bc5bd9b9d0c6b22ebd029795e12b607316b97721e5d42', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 03:58:59', '2025-09-13 03:58:59', '2026-09-13 10:58:59'),
('a8be16d241ab08d78f21a31e2ea443c740cef98b0fa4b90989707de8b4f0cd8ff5f2f855fb3467b4', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 21:28:39', '2025-09-12 21:28:39', '2026-09-13 04:28:39'),
('a96ffc0f5e144afa3fab5ec2cdf49383d527d80a080d9b22a9a22220b98aad11fe90583bed166250', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:26:32', '2025-09-21 22:26:32', '2026-09-22 05:26:32'),
('a989b7281b3b596dd34cb7c4b506869c25d5b9ab1d8b4a6f1f259777375e0d8eee510a2977945815', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-21 22:00:00', '2025-09-21 22:00:00', '2026-09-22 05:00:00'),
('aa52cdce4ff1eda9e5127347edbb1816e43cef5e6749f717c8d0fe74fa8ffccfda5a453636b38457', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 17:30:26', '2025-09-12 17:30:33', '2026-09-13 00:30:26'),
('ab7bc74b16792ed2e5a37fb5fe51c4eb516ad373d7c2072f200b77586213a2a3802a1831dec75778', 15, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:05:12', '2025-09-12 19:05:12', '2026-09-13 02:05:12'),
('abd8152b2744e0a45b6f50e5373db963236f3f0ad7e0fcbfcd6de342e0f0fc5ecea46fb9439a8208', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 15:43:33', '2025-09-13 15:43:33', '2026-09-13 22:43:33'),
('ae9ed87856b7f30b51eb80e71c4e4b4a83b2e69524be13b53b680388717dfb16f842d0c2c34bdb20', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 03:05:11', '2025-09-13 03:05:11', '2026-09-13 10:05:11'),
('afa2dd47136e9e808aa76e0ea5c327ff61e8e52a78546f0b6f4179e62ff656f814b8624c6072bef6', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:29:37', '2025-09-13 01:29:37', '2026-09-13 08:29:37'),
('b070b9646de57feaf81397927035bf82acce7a6514a891e594662a877fdfa37ef320565b1739a519', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 03:09:07', '2025-09-13 03:09:07', '2026-09-13 10:09:07'),
('b5316284977427f61e54379c665299f73842eab1752487746523a5c264d7a9ad93a0726befa9c2d5', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-23 07:23:00', '2025-09-23 07:23:00', '2026-09-23 14:23:00'),
('b6103ed177f3913e46b6c7f9b04d60845524fcec877b34427b9064fb84b33597fb8eb8cda55fa290', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-23 07:23:13', '2025-09-23 07:23:13', '2026-09-23 14:23:13'),
('b9cf0d9a5251d8cb4f98fc1d969b718295d1a4617b9073bfa635567a46fd576cf503bc7f3762bae7', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:41:22', '2025-09-12 19:41:22', '2026-09-13 02:41:22'),
('bbb6701763276cafb83533d98e5d78a1e55c362b89b034792413b2b3b3970036ee363ffecaaf1a60', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-17 17:37:14', '2025-09-17 17:37:14', '2026-09-18 00:37:14'),
('be51b44ae5e30c16eee1f4e8a597fd4ab0a72a87651eab751166e91328592e817e73421186fd196a', 16, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 18:47:55', '2025-09-14 18:47:55', '2026-09-15 01:47:55'),
('c309e4695ffe1c9e6bde4ad4651d3d677a2dc78368e3d573c0d41d3a6d9430925810a468ec290774', 12, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-12 00:52:36', '2025-09-12 00:52:42', '2026-09-12 07:52:36'),
('c965b00ff8b2d41bc2635261265a941f01723eb367b0b52eeab401c3de3e9da376294321ebfe340e', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 17:19:45', '2025-09-12 17:19:45', '2026-09-13 00:19:45'),
('d065e53b926978b93224ee4d9c45736a9ae75f04d2619b9dd098977260fa675ec1983f564c9a6eba', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-22 01:49:56', '2025-09-22 01:49:56', '2026-09-22 08:49:56'),
('d3ede20b26af68a611d73e8c7c44936afc298f01d4d05055b26aef47381fac5d6b71f7b51978dc7a', 19, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-18 21:17:30', '2025-09-18 21:17:30', '2026-09-19 04:17:30'),
('d59b0a06345d9c111af1a611f68617d137c301b2bef9c532df5befbf8ad9839a28f96fe9b463414d', 20, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-24 02:01:47', '2025-09-24 02:01:47', '2026-09-24 09:01:47'),
('d74f8af6fc91e0964db4edce936d619e3d625ddc83feddb2b52908ea281ebb6312256ea671e4cc79', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-18 21:09:31', '2025-09-18 21:09:31', '2026-09-19 04:09:31'),
('db45a98bf52b7afd9cad31642b3919d87dc8de62891ae9a578d6b8f584d23513de8052824c3a39cd', 17, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 19:46:03', '2025-09-15 19:46:03', '2026-09-16 02:46:03'),
('de176144698182ebda75009b933aacc533e469c744d814f3f7e60de989073b72523202d4151abc1c', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 17:59:27', '2025-09-15 17:59:27', '2026-09-16 00:59:27'),
('df6d5356a80036de8497cb565cb87b566b3eb5c28590e0b7dd395aa44cc0e5dc328b144575e4ac4c', 9, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:07:20', '2025-09-12 00:07:20', '2026-09-12 07:07:20'),
('e0c6cce169d068bb9846f1699755415f1250aa13ec9560676ceb81203e7d8607fa424e98e4a0b239', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 17:38:38', '2025-09-12 17:38:38', '2026-09-13 00:38:38'),
('e0e786331bb33115b7d16ae7129b16ea671ea262d1c45d6ca66e87df1423eee9b72d3357d1037338', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 18:28:14', '2025-09-12 18:28:14', '2026-09-13 01:28:14'),
('e172a74ad7a9f5ad22d8058b62b7eddcad8a20750157aea972b6d2bcbe2ae96991130605292f24ec', 6, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 20:26:51', '2025-09-11 20:26:51', '2026-09-12 03:26:51'),
('e3bc3ac6b3ebbcf49eec5d868084f8c876c5de1afbc3cb0cef125db644ccad5c89fd103fe7867615', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-22 00:45:27', '2025-09-22 00:45:27', '2026-09-22 07:45:27'),
('e46935103761ac26b7cf06d589a3957509a84ae023957338097bdbc6102980564c85cd20b53d28ba', 7, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 00:03:25', '2025-09-12 00:03:25', '2026-09-12 07:03:25'),
('e6b07060e4f21e69f5b5fad02423ee23b1b93ff5a7b699569fff92215771e5ab665244f32f21f92d', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 16:18:04', '2025-09-13 16:18:04', '2026-09-13 23:18:04'),
('e7f9221758034fd163bd4b3c24122a8dbb436acc562887980b72ff5a95209e40bc18811f77bea289', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 16:02:59', '2025-09-13 16:02:59', '2026-09-13 23:02:59'),
('e8626070e44e0bff1a6c59c7d91b37097bc7e5481ba9e2704924ef0d580aaa298c0af8e9f2caae05', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 03:57:06', '2025-09-13 03:57:06', '2026-09-13 10:57:06'),
('e89cb8a6cbd83faee8e5f86ca531b370258665fd7f08c35cd59ff80e3a7684ceaef2e2e258bb15c1', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 21:20:32', '2025-09-12 21:20:32', '2026-09-13 04:20:32'),
('ea106b7060bd775972c5dfafa17bb14530c082160354886496abcdf5da5af66c79b953249467f577', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-15 18:03:48', '2025-09-15 18:03:48', '2026-09-16 01:03:48'),
('ece57218e14fba4a3972b819fb8e8a5e5c1ba4ece7256c7b7d66a86221c0b7055f257ba3fcd7ea39', 5, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 20:23:49', '2025-09-11 20:23:49', '2026-09-12 03:23:49'),
('efefb385612d77a2f01378f7b76dbe29ce5f33d0317cbd9f0b9b7f2a89794758c29a81e4a056a73f', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:19:19', '2025-09-13 01:19:19', '2026-09-13 08:19:19'),
('f2cde83829084e583885a5901ad77b3d699a2263a6421f151d1581d76c708275e16fd50c9231e006', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:16:39', '2025-09-13 01:16:39', '2026-09-13 08:16:39'),
('f36bc22fda4d9a49184ce7d5bf049c4cdbbbf4daa7fa7e1e39b90c1ac819cc575635c9768aa70f97', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:31:51', '2025-09-13 01:31:51', '2026-09-13 08:31:51'),
('f39a241bb651eb48f0f20ebf690a027e6b9c86e5bfae98bd9498ad66084157660fe5e329ef1078f4', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-14 19:06:16', '2025-09-14 19:06:16', '2026-09-15 02:06:16'),
('f5b82f15fe107d34a3b48038cdbc4fee738e74687de1ba6b54c51fe2db2f565eac4801a9ce22de45', 15, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:00:12', '2025-09-12 19:00:12', '2026-09-13 02:00:12'),
('f603ccac230c0b26e23281b2f81df0509207589c09d037b4ede2f588e499aacbc8cc0c0e3622adab', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 17:26:52', '2025-09-12 17:26:52', '2026-09-13 00:26:52'),
('f75186bcb568bf2499e702100309ff13d2ae648bf53218fed7f5db602e73b60d53bc499bcf2bdc03', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 01:13:58', '2025-09-13 01:13:58', '2026-09-13 08:13:58'),
('f769d2a0c3b90c4615376de60ef8dff713c184b83f8f8fedeae0c91610b8da006a787416bb88a6ec', 15, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-12 19:00:01', '2025-09-12 19:00:01', '2026-09-13 02:00:01'),
('f939370cb23dea972788856cfcfb19573e6bcfe579ea8688633a9d3a3513161a7e8ce866a16c1d49', 13, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-13 16:12:15', '2025-09-13 16:12:15', '2026-09-13 23:12:15'),
('fde84c88837c18f32d973264e9fccb11974000f8b3960ee72cf254fb454e0860ed64887aaf90e895', 6, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 1, '2025-09-11 20:26:54', '2025-09-11 20:27:42', '2026-09-12 03:26:54'),
('ff0873c97f380070263cf1ac77f2820cb57152aba028c9a1bfe69403ae26b2915e6e2b8ef0b3033a', 5, '019937ae-16dd-737a-9d28-ededcd71ddf1', 'LaravelPassportToken', '[]', 0, '2025-09-11 23:44:14', '2025-09-11 23:44:14', '2026-09-12 06:44:14');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` char(80) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` char(36) NOT NULL,
  `scopes` text DEFAULT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` char(36) NOT NULL,
  `owner_type` varchar(255) DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(255) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `redirect_uris` text NOT NULL,
  `grant_types` text NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `owner_type`, `owner_id`, `name`, `secret`, `provider`, `redirect_uris`, `grant_types`, `revoked`, `created_at`, `updated_at`) VALUES
('019937ae-16dd-737a-9d28-ededcd71ddf1', NULL, NULL, 'Laravel', '$2y$12$x4TfeQwupCer8p4VtqXghewc3gq0J07OV.BESvQmR6im5Xm6CLjDO', 'users', '[]', '[\"personal_access\"]', 0, '2025-09-11 00:29:40', '2025-09-11 00:29:40');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_device_codes`
--

CREATE TABLE `oauth_device_codes` (
  `id` char(80) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` char(36) NOT NULL,
  `user_code` char(8) NOT NULL,
  `scopes` text NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `user_approved_at` datetime DEFAULT NULL,
  `last_polled_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` char(80) NOT NULL,
  `access_token_id` char(80) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `pet_name` varchar(255) NOT NULL,
  `breed` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `pet_type` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `pet_name`, `breed`, `description`, `image`, `pet_type`, `created_at`, `updated_at`) VALUES
(14, 19, 'lucky', 'chó', 'nhát', 'posts/FzBlM3wCvf10TfuuETJGn7gaJRgbfj8E5OXPPcRS.jpg', 'dog', '2025-09-21 04:26:01', '2025-09-21 04:26:01'),
(15, 19, 'miu', 'mèo', 'dữ', 'posts/R52s1ed3qUf2qK6ZiHtNbDNCM1iWE69dWHPofSZo.jpg', 'cat', '2025-09-21 04:37:38', '2025-09-21 04:37:38'),
(17, 19, 'ki', 'chuột', 'dơ', 'posts/SZCtrg1usjTslu6p3BEBXWVHJS4YyUb6VYU1bwfY.jpg', 'dog', '2025-09-21 04:53:00', '2025-09-21 04:53:00'),
(18, 19, 'ttt', 'cat', 'tttttt', 'posts/UGF8AmrMhhMEdMODcUVIHkD1u9kJpJ3EviGFYHJx.jpg', 'dog', '2025-09-21 21:37:47', '2025-09-21 21:37:47'),
(19, 13, 'kkk', 'dog', 'uuuu', 'posts/3VZAHoww4WvHAkwBLl3SLTHQVAe6B5RhfNJKqZaw.jpg', 'dog', '2025-09-21 22:14:59', '2025-09-21 22:14:59'),
(21, 19, 'oo', 'dog', 'ttqyhs', 'posts/4EtdLAM0IBsHqpFgtOgBJkhSUYNbVvZz82C3juT2.jpg', 'dog', '2025-09-21 23:09:35', '2025-09-21 23:09:35');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('EnnYiAGgnbb9jEcr7wXxLPeIazW24RTDuRbksvtL', NULL, '127.0.0.1', 'PostmanRuntime/7.46.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZVJURDNrT3JXeW9HalNGS0dtMzVWREJDcXJpU1ZLVUNTeWtnUVc1ZSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1757739795),
('HF4iUPEK43vaC71CAI2yevHtxTwKelemtRCN0bVf', NULL, '192.168.1.6', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYVdUdmNCd3hzZnIyRDZzVjFEZk5vTmNyZURLYjk0WG53ZGRteER2byI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly8xOTIuMTY4LjEuNzo4MDAwIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1757740272),
('j9UOSf7cdZYCabJbQcSdDhAWBN8oye8qGF3MZQFC', NULL, '127.0.0.1', 'PostmanRuntime/7.46.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia3ZBOE1sTHFjZDlQbDNocjRBcnFLanFEdzRxamdRSHZTaEhaRU9DYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1757576482),
('rCcmHuFVt3Bxuh7oWELQhZ1tQ8fUgAOxG2gzohq9', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiejNHWW9BTmF1U25YRVBBT3hEejhBN3REeTBqcUI2ME91NXQxQmRqRCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1758683462),
('WKbcJBbjIuQWAY6beYCOJ4OXa4CI1fBm2Kazr3TU', NULL, '127.0.0.1', 'PostmanRuntime/7.46.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicTlVb21ybkdER2R2NnpDY3JtVldFVzMxVDRoQjBqeTY4S2Q0RHZYaCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1757985746);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `pet_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `theme` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `language` varchar(255) NOT NULL DEFAULT 'vi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `pet_name`, `email`, `email_verified_at`, `password`, `remember_token`, `theme`, `created_at`, `updated_at`, `language`) VALUES
(1, 'Phạm', NULL, 'pham@example.com', NULL, '$2y$12$rTgOnV9/86rbxCpIIYrU3Om1iwZ2w0B1KE0w3LnW0tUfAEUI6f4ba', NULL, NULL, '2025-09-11 00:37:53', '2025-09-11 00:37:53', 'vi'),
(3, 'Phạm Huy', NULL, 'phamhuy@example.com', NULL, '$2y$12$V/ifFicnXQ2180/kNYTKlexvMJEsh3M/mfZ0KCbs4/BTxdsoR/1Ee', NULL, NULL, '2025-09-11 01:12:18', '2025-09-11 01:12:18', 'vi'),
(4, 'Phạm Huy ne', NULL, 'phamhuyne@example.com', NULL, '$2y$12$Pzenm01usgAYwB4FRxM1RO6DgavvIQdbnexsI6zpw3T0wHUGObJjm', NULL, NULL, '2025-09-11 19:02:22', '2025-09-11 19:02:22', 'vi'),
(5, 'Huy', NULL, 'phamquochuy28102004@gmail.com', NULL, '$2y$12$vC8MkENMyiEjw.2d069ZE.rO0beIgjo1/wKONNGq6Tf8rz9yMROPa', NULL, NULL, '2025-09-11 20:23:27', '2025-09-11 20:23:27', 'vi'),
(6, 'duc', NULL, 'duc@gmail.com', NULL, '$2y$12$Vyst7uu3vL7boytSQ/LGO.NhOL646yKdG6AflQ/Du9/HsSYBL0YzO', NULL, NULL, '2025-09-11 20:26:51', '2025-09-11 20:26:51', 'vi'),
(7, 'huyneae', NULL, 'phamquochuy@gmail.com', NULL, '$2y$12$lqzziArEDfPYNZsbd9S9X.7ucdnEPfeqZdpHOAfC.wXeQLFviJRw6', NULL, NULL, '2025-09-12 00:03:24', '2025-09-12 00:03:24', 'vi'),
(8, 'tu', NULL, 'tu@gmail.com', NULL, '$2y$12$uXhKD8X4k8fIl9oyiE1bg.cPHWyf1XIZZU9Ahp9az4bzdaqFkkeWe', NULL, NULL, '2025-09-12 00:07:02', '2025-09-12 00:07:02', 'vi'),
(9, 'tuan', NULL, 'tuan@gmail.com', NULL, '$2y$12$/6wnrSnanW07QsC0UGVCYOEfoU4s6QsEx5txyKopsBvl7MG7l7iYS', NULL, NULL, '2025-09-12 00:07:20', '2025-09-12 00:07:20', 'vi'),
(10, 'tuanghelo', NULL, 'tuanghelo@gmail.com', NULL, '$2y$12$On/uedHT8Gtv94ZG.OEYm.f6e0XGPyCEKAwwnUOxP1WW5Btr1ahdC', NULL, NULL, '2025-09-12 00:08:24', '2025-09-12 00:08:24', 'vi'),
(11, 'ducdb', NULL, 'ducdb@gmail.com', NULL, '$2y$12$.7yu/wIgVT4D5dCzgSrQ5u6SgTZgRZtxos.0zd.Y.zV0aiJiyAKxK', NULL, NULL, '2025-09-12 00:11:12', '2025-09-12 00:11:12', 'vi'),
(12, 'Qhuy', NULL, 'qhuy@gmail.com', NULL, '$2y$12$ulzwkBoZSzamqhfGf5EWi.JieAPM0G7l8iJIgFQonOiMLVgmz5S3y', NULL, NULL, '2025-09-12 00:52:28', '2025-09-12 00:52:28', 'vi'),
(13, 'alo', NULL, 'alo@gmail.com', NULL, '$2y$12$dg4T.G2m4phnpWCfjOJmhugJSwer1xplxQXTT1lE82Z/KxXX4Qi6K', NULL, NULL, '2025-09-12 17:19:40', '2025-09-24 18:28:05', 'vi'),
(14, 'toan', NULL, 'toan@gmail.com', NULL, '$2y$12$57aQNtQLjCvERxAcII3PIeIcRHLiDNfXJvRPjEupVO1CQBusy2nf2', NULL, NULL, '2025-09-12 18:57:30', '2025-09-12 18:57:30', 'vi'),
(15, 'toan1', NULL, 'toan1@gmail.com', NULL, '$2y$12$Q//2XkDRVTykirfVd.r/a.Wk8Z9pWj.nQCyZjYptyVFi9ImZq9y1O', NULL, NULL, '2025-09-12 19:00:01', '2025-09-12 19:00:01', 'vi'),
(16, 'q', NULL, 'q@gmail.com', NULL, '$2y$12$Bd9xmFgyOlfwjguFFdhVjeX0Z6FUVWTUXwFbQ9FidE/pQ9N81Ulrm', NULL, NULL, '2025-09-14 18:47:55', '2025-09-14 18:47:55', 'vi'),
(17, 'huy', 'lucky', 'huy12@gmail.com', NULL, '$2y$12$eG8gPoWRugxeydCFuPXg/.6eztVw1pPspovOEaukddkZ/WFTg/oFq', NULL, NULL, '2025-09-15 19:45:52', '2025-09-15 19:57:22', 'en'),
(18, 'tuancoi', 'luckyyyyy', 'tuancoi@gmail.com', NULL, '$2y$12$S1LjEkCnCcg22MOR1MQOK.cwsodEqS0rLRvu412bcLarfT0tO07Ta', NULL, NULL, '2025-09-17 17:36:02', '2025-09-17 17:36:02', 'vi'),
(19, 'huy1', 'milu', 'huy1@gmail.com', NULL, '$2y$12$DiXeZ76RdgJZfgoM3P9PT.6DWt9cREmArslwGIwhYGeW.82GpdsEu', NULL, NULL, '2025-09-18 21:17:08', '2025-09-18 21:17:08', 'vi'),
(20, 'duc', NULL, 'duc111@gmail.com', NULL, '$2y$12$FBvqJQyZGAxEeCipFINlD.Et1QmvIjk9Nx/vpxydg4ssNP.O8u3ei', NULL, NULL, '2025-09-23 07:23:44', '2025-09-23 07:23:44', 'vi');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `likes_user_id_post_id_unique` (`user_id`,`post_id`),
  ADD KEY `likes_post_id_foreign` (`post_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_owner_type_owner_id_index` (`owner_type`,`owner_id`);

--
-- Indexes for table `oauth_device_codes`
--
ALTER TABLE `oauth_device_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `oauth_device_codes_user_code_unique` (`user_code`),
  ADD KEY `oauth_device_codes_user_id_index` (`user_id`),
  ADD KEY `oauth_device_codes_client_id_index` (`client_id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
