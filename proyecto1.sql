-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-09-2026 a las 21:53:32
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyecto1`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

CREATE TABLE `bitacora` (
  `id_bitacora` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `accion` varchar(20) NOT NULL,
  `tabla_afectada` varchar(40) DEFAULT NULL,
  `descripcion` varchar(200) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `bitacora`
--

INSERT INTO `bitacora` (`id_bitacora`, `id_usuario`, `accion`, `tabla_afectada`, `descripcion`, `fecha`) VALUES
(1, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-08 15:55:53'),
(2, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-08 21:09:07'),
(3, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-10 11:55:26'),
(4, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-13 11:16:32'),
(5, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-13 11:18:13'),
(6, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 20:50:20'),
(7, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 20:56:27'),
(8, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 21:24:54'),
(9, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 21:27:26'),
(10, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 21:51:57'),
(11, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 21:59:02'),
(12, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 22:25:50'),
(13, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-18 22:30:39'),
(14, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 00:15:19'),
(15, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 00:33:59'),
(16, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 00:39:18'),
(17, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 00:46:25'),
(18, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 07:53:01'),
(19, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 07:56:20'),
(20, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:01:00'),
(21, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:13:34'),
(22, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:15:55'),
(23, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:18:26'),
(24, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:19:30'),
(25, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:22:38'),
(26, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:24:39'),
(27, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:37:17'),
(28, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:57:53'),
(29, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 08:59:50'),
(30, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 09:10:53'),
(31, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 09:12:04'),
(32, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 19:02:54'),
(33, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 19:19:16'),
(34, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 19:21:34'),
(35, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-19 19:31:59'),
(36, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 13:41:05'),
(37, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 19:01:26'),
(38, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 19:32:20'),
(39, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 19:36:28'),
(40, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 19:38:33'),
(41, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 19:39:44'),
(42, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 20:12:15'),
(43, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 20:23:41'),
(44, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 20:36:36'),
(45, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-20 20:40:27'),
(46, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:12:10'),
(47, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:25:02'),
(48, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:36:17'),
(49, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:37:04'),
(50, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:40:18'),
(51, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:41:51'),
(52, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:48:06'),
(53, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:50:51'),
(54, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 13:51:33'),
(55, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-21 16:03:02'),
(56, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:07:37'),
(57, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:07:39'),
(58, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Do it Center con RUC 1-100-1001', '2026-09-22 14:19:56'),
(59, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Frio Express Panama con RUC 1-100-1002', '2026-09-22 14:20:27'),
(60, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Super Pisos con RUC 1-100-1003', '2026-09-22 14:20:44'),
(61, 1, 'INSERT', 'proveedores', 'Se registró el proveedor El machetazo con RUC 1-100-1004', '2026-09-22 14:21:26'),
(62, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:24:47'),
(63, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:25:43'),
(64, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:27:35'),
(65, 1, 'UPDATE', 'proveedores', 'Se cambió el estado del proveedor con ID 1 a INACTIVO', '2026-09-22 14:29:15'),
(66, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:30:21'),
(67, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:33:25'),
(68, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:34:38'),
(69, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:35:14'),
(70, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:36:13'),
(71, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:37:40'),
(72, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 14:40:37'),
(73, 1, 'INSERT', 'proveedores', 'Se registró el proveedor El campeon con RUC 1-100-1005', '2026-09-22 14:42:05'),
(74, 1, 'CREAR', 'cheques', 'Se registró el cheque número 1', '2026-09-22 14:43:58'),
(75, 1, 'CREAR', 'cheques', 'Se registró el cheque número 2', '2026-09-22 14:45:35'),
(76, 1, 'CREAR', 'cheques', 'Se registró el cheque número 3', '2026-09-22 14:46:40'),
(77, 1, 'CREAR', 'cheques', 'Se registró el cheque número 4', '2026-09-22 14:48:16'),
(78, 1, 'CREAR', 'cheques', 'Se registró el cheque número 5', '2026-09-22 14:50:12'),
(79, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 14:50:41'),
(80, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 14:50:54'),
(81, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-22 14:51:15'),
(82, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-22 14:51:18'),
(83, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 14:51:20'),
(84, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 14:51:29'),
(85, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 14:51:32'),
(86, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-22 14:51:34'),
(87, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 14:51:40'),
(88, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 5450.0', '2026-09-22 14:52:55'),
(89, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 5450.0', '2026-09-22 14:53:29'),
(90, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 5', '2026-09-22 15:01:37'),
(91, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 15:04:19'),
(92, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 15:06:27'),
(93, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Corporacion las Antillas con RUC 1-100-1004', '2026-09-22 15:06:49'),
(94, 1, 'INSERT', 'proveedores', 'Se registró el proveedor La Tachuelita con RUC 1-100-1005', '2026-09-22 15:07:06'),
(95, 1, 'CREAR', 'cheques', 'Se registró el cheque número 1', '2026-09-22 15:09:09'),
(96, 1, 'CREAR', 'cheques', 'Se registró el cheque número 2', '2026-09-22 15:10:41'),
(97, 1, 'CREAR', 'cheques', 'Se registró el cheque número 3', '2026-09-22 15:11:27'),
(98, 1, 'CREAR', 'cheques', 'Se registró el cheque número 4', '2026-09-22 15:12:04'),
(99, 1, 'CREAR', 'cheques', 'Se registró el cheque número 5', '2026-09-22 15:12:36'),
(100, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-22 15:17:25'),
(101, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-22 15:17:27'),
(102, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 15:17:29'),
(103, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 15:17:54'),
(104, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 15:17:57'),
(105, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 15:17:59'),
(106, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-22 15:18:01'),
(107, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 15:33:52'),
(108, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 15:44:56'),
(109, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 15:46:50'),
(110, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 15:47:00'),
(111, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 15:51:35'),
(112, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 1 a INACTIVO', '2026-09-22 15:53:02'),
(113, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 2 a INACTIVO', '2026-09-22 15:53:03'),
(114, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 2 a ACTIVO', '2026-09-22 15:57:19'),
(115, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 1 a ACTIVO', '2026-09-22 15:57:20'),
(116, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 2 a INACTIVO', '2026-09-22 15:59:58'),
(117, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 1 a INACTIVO', '2026-09-22 15:59:59'),
(118, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:08:42'),
(119, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 2 a ACTIVO', '2026-09-22 16:09:53'),
(120, 1, 'UPDATE', 'depositos', 'Se cambió el estado del depósito con ID 1 a ACTIVO', '2026-09-22 16:09:54'),
(121, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 16:10:02'),
(122, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:15:40'),
(123, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:20:51'),
(124, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:27:38'),
(125, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:31:56'),
(126, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:33:17'),
(127, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 16:33:22'),
(128, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:39:08'),
(129, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 16:43:26'),
(130, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 16:50:18'),
(131, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-01 con saldo según banco de B/. 28003.09', '2026-09-22 16:52:02'),
(132, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 17:13:13'),
(133, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:15:14'),
(134, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 17:17:03'),
(135, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 17:21:45'),
(136, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:26:09'),
(137, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:26:42'),
(138, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 17:26:51'),
(139, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 17:38:15'),
(140, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 17:39:20'),
(141, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 17:39:50'),
(142, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:44:25'),
(143, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 17:44:33'),
(144, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 17:45:57'),
(145, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:47:30'),
(146, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:48:04'),
(147, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 17:48:11'),
(148, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 17:48:13'),
(149, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 17:48:15'),
(150, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 17:48:17'),
(151, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-22 17:48:19'),
(152, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-22 17:48:20'),
(153, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:51:34'),
(154, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-22 17:51:46'),
(155, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 17:52:55'),
(156, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 1', '2026-09-22 17:54:21'),
(157, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-01 con saldo según banco de B/. 28003.09', '2026-09-22 17:56:12'),
(158, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 21:16:32'),
(159, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 21:44:56'),
(160, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:09:24'),
(161, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:16:01'),
(162, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:17:29'),
(163, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:34:15'),
(164, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:36:26'),
(165, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:43:54'),
(166, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:49:31'),
(167, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-01 con saldo según banco de B/. 28003.09', '2026-09-22 22:50:31'),
(168, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:53:57'),
(169, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-01', '2026-09-22 22:54:29'),
(170, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 22:55:13'),
(171, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-22 22:55:15'),
(172, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 22:55:17'),
(173, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 22:55:20'),
(174, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:56:30'),
(175, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 22:56:38'),
(176, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-22 22:58:27'),
(177, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 22:59:36'),
(178, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 22:59:41'),
(179, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-02', '2026-09-22 22:59:59'),
(180, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:03:33'),
(181, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-22 23:03:47'),
(182, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:06:25'),
(183, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 23:12:30'),
(184, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 23:12:32'),
(185, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 23:12:34'),
(186, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-02', '2026-09-22 23:13:12'),
(187, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-22 23:14:52'),
(188, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:15:21'),
(189, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:23:40'),
(190, 1, 'CREAR', 'cheques', 'Se registró el cheque número 6', '2026-09-22 23:25:14'),
(191, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 6 al estado 2', '2026-09-22 23:25:28'),
(192, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:33:39'),
(193, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:36:49'),
(194, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:38:26'),
(195, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 23:40:11'),
(196, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 23:40:13'),
(197, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-22 23:40:15'),
(198, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-22 23:40:17'),
(199, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-22 23:40:48'),
(200, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:43:51'),
(201, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:45:47'),
(202, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 23:46:17'),
(203, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 23:46:20'),
(204, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 23:46:22'),
(205, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:48:03'),
(206, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-22 23:48:35'),
(207, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-22 23:48:37'),
(208, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-22 23:48:39'),
(209, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-22 23:48:41'),
(210, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-22 23:49:04'),
(211, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-22 23:49:06'),
(212, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-22 23:49:08'),
(213, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:51:34'),
(214, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-22 23:59:31'),
(215, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-02', '2026-09-22 23:59:54'),
(216, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 00:01:33'),
(217, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-01', '2026-09-23 00:01:51'),
(218, 1, 'INSERT', 'conciliaciones', 'Conciliación guardada para el período 2025-02', '2026-09-23 00:02:08'),
(219, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 09:50:05'),
(220, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 09:56:03'),
(221, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 10:00:51'),
(222, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-23 10:01:03'),
(223, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 10:04:02'),
(224, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-23 10:04:14'),
(225, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-23 10:04:16'),
(226, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-23 10:04:19'),
(227, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 10:06:37'),
(228, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-23 10:06:43'),
(229, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-23 10:15:05'),
(230, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 3', '2026-09-23 10:15:34'),
(231, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-23 10:15:36'),
(232, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 10:30:14'),
(233, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-23 10:30:30'),
(234, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 10:31:18'),
(235, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 12:58:20'),
(236, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:00:24'),
(237, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-23 13:00:37'),
(238, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-23 13:00:39'),
(239, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-23 13:00:41'),
(240, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-23 13:00:43'),
(241, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-23 13:00:48'),
(242, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:02:22'),
(243, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-23 13:10:12'),
(244, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:11:34'),
(245, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-23 13:13:04'),
(246, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:14:47'),
(247, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-23 13:28:10'),
(248, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:28:54'),
(249, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:34:23'),
(250, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-23 13:34:38'),
(251, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:52:14'),
(252, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-23 13:52:40'),
(253, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 13:55:43'),
(254, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 14:02:53'),
(255, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-23 14:06:04'),
(256, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-24 20:25:26'),
(257, 1, 'SACAR_CIRCULACION', 'cheques', 'Se sacó de circulación el cheque ID 4', '2026-09-24 20:26:10'),
(258, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-24 21:06:21'),
(259, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-02 con saldo según banco de B/. 27675.33', '2026-09-24 21:27:59'),
(260, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-24 21:33:25'),
(261, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-24 21:33:41'),
(262, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-24 21:33:44'),
(263, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-02 con saldo según banco de B/. 27675.33', '2026-09-24 21:34:20'),
(264, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-24 21:43:48'),
(265, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-24 21:44:40'),
(266, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:22:54'),
(267, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:30:09'),
(268, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:30:56'),
(269, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:31:11'),
(270, 1, 'CREAR', 'cheques', 'Se registró el cheque número 1', '2026-09-25 21:32:46'),
(271, 1, 'CREAR', 'cheques', 'Se registró el cheque número 2', '2026-09-25 21:34:27'),
(272, 1, 'CREAR', 'cheques', 'Se registró el cheque número 3', '2026-09-25 21:35:05'),
(273, 1, 'CREAR', 'cheques', 'Se registró el cheque número 4', '2026-09-25 21:35:44'),
(274, 1, 'CREAR', 'cheques', 'Se registró el cheque número 5', '2026-09-25 21:36:28'),
(275, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:38:53'),
(276, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-01 con saldo según banco de B/. 27842.05', '2026-09-25 21:39:21'),
(277, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 21:40:06'),
(278, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:07:39'),
(279, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 2', '2026-09-25 22:08:09'),
(280, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 1 al estado 5', '2026-09-25 22:08:12'),
(281, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 2', '2026-09-25 22:08:16'),
(282, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 2', '2026-09-25 22:08:18'),
(283, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 2', '2026-09-25 22:08:20'),
(284, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 3 al estado 2', '2026-09-25 22:08:22'),
(285, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-01 con saldo según banco de B/. 27842.05', '2026-09-25 22:09:16'),
(286, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:14:05'),
(287, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 5', '2026-09-25 22:14:24'),
(288, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-02 con saldo según banco de B/. 27675.33', '2026-09-25 22:31:59'),
(289, 1, 'CREAR', 'cheques', 'Se registró el cheque número 6', '2026-09-25 22:33:06'),
(290, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 6 al estado 2', '2026-09-25 22:35:20'),
(291, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 6 al estado 4', '2026-09-25 22:40:42'),
(292, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-25 22:40:56'),
(293, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-25 22:41:00'),
(294, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:42:25'),
(295, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:43:11'),
(296, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:48:36'),
(297, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:49:06'),
(298, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-25 22:50:11'),
(299, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-25 22:50:13'),
(300, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 22:58:30'),
(301, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-25 23:01:06'),
(302, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-25 23:01:07'),
(303, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-03 con saldo según banco de B/. 25890.45', '2026-09-25 23:03:07'),
(304, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 23:04:50'),
(305, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 23:29:39'),
(306, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 23:30:55'),
(307, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-25 23:32:22'),
(308, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 00:33:36'),
(309, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 00:35:34'),
(310, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 4 al estado 3', '2026-09-26 00:35:59'),
(311, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-02 con saldo según banco de B/. 27675.33', '2026-09-26 00:50:00'),
(312, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 2 al estado 3', '2026-09-26 00:51:53'),
(313, 1, 'CAMBIAR_ESTADO', 'cheques', 'Se cambió el estado del cheque ID 5 al estado 3', '2026-09-26 00:51:55'),
(314, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-03 con saldo según banco de B/. 25890.45', '2026-09-26 00:52:37'),
(315, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 00:56:06'),
(316, 1, 'INSERT', 'conciliaciones', 'Se registró una conciliación bancaria para el período 2025-03 con saldo según banco de B/. 25890.45', '2026-09-26 01:06:16'),
(317, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:15:31'),
(318, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:19:50'),
(319, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:32:11'),
(320, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:38:22'),
(321, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:38:55'),
(322, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:41:18'),
(323, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:46:06'),
(324, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:51:13'),
(325, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:51:53'),
(326, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 01:56:29'),
(327, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 02:00:43'),
(328, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 02:08:57'),
(329, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 02:09:50'),
(330, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 02:10:58'),
(331, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 02:11:49'),
(332, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 13:53:53'),
(333, 1, 'INSERT', 'usuarios', 'Se registró el usuario Trabajador con rol CONTADOR', '2026-09-26 14:13:11'),
(334, 1, 'INSERT', 'usuarios', 'Se registró el usuario Asistente con rol AUXILIAR', '2026-09-26 14:15:22'),
(335, 1, 'INSERT', 'proveedores', 'Se registró el proveedor El Machetazo con RUC 1-100-1006', '2026-09-26 14:16:38'),
(336, 1, 'INSERT', 'proveedores', 'Se registró el proveedor El Campeon con RUC 1-100-1007', '2026-09-26 14:16:54'),
(337, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Madison con RUC 1-100-1008', '2026-09-26 14:17:05'),
(338, 1, 'INSERT', 'proveedores', 'Se registró el proveedor Cochez con RUC 1-100-1009', '2026-09-26 14:17:16'),
(339, 1, 'INSERT', 'proveedores', 'Se registró el proveedor El Costo con RUC 1-100-1010', '2026-09-26 14:19:09'),
(340, 1, 'CREAR', 'cheques', 'Se registró el cheque número 6', '2026-09-26 14:26:05'),
(341, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 14:26:40'),
(342, 1, 'CREAR', 'cheques', 'Se registró el cheque número 6', '2026-09-26 14:29:06'),
(343, 1, 'CREAR', 'cheques', 'Se registró el cheque número 7', '2026-09-26 14:29:33'),
(344, 1, 'CREAR', 'cheques', 'Se registró el cheque número 8', '2026-09-26 14:30:18'),
(345, 1, 'CREAR', 'cheques', 'Se registró el cheque número 9', '2026-09-26 14:30:41'),
(346, 1, 'CREAR', 'cheques', 'Se registró el cheque número 10', '2026-09-26 14:31:19'),
(347, 1, 'CREAR', 'cheques', 'Se registró el cheque número 11', '2026-09-26 14:31:37'),
(348, 1, 'CREAR', 'cheques', 'Se registró el cheque número 12', '2026-09-26 14:33:46'),
(349, 1, 'CREAR', 'cheques', 'Se registró el cheque número 13', '2026-09-26 14:34:13'),
(350, 1, 'CREAR', 'cheques', 'Se registró el cheque número 14', '2026-09-26 14:34:57'),
(351, 1, 'CREAR', 'cheques', 'Se registró el cheque número 15', '2026-09-26 14:35:36'),
(352, 1, 'CREAR', 'cheques', 'Se registró el cheque número 16', '2026-09-26 14:36:05'),
(353, 1, 'CREAR', 'cheques', 'Se registró el cheque número 17', '2026-09-26 14:36:53'),
(354, 1, 'CREAR', 'cheques', 'Se registró el cheque número 18', '2026-09-26 14:38:09'),
(355, 1, 'CREAR', 'cheques', 'Se registró el cheque número 19', '2026-09-26 14:38:54'),
(356, 1, 'CREAR', 'cheques', 'Se registró el cheque número 20', '2026-09-26 14:39:15'),
(357, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 6700.67', '2026-09-26 14:40:33'),
(358, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 1668.35', '2026-09-26 14:41:05'),
(359, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 6767.67', '2026-09-26 14:42:52'),
(360, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 4000.0', '2026-09-26 14:43:15'),
(361, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 5310.1', '2026-09-26 14:43:34'),
(362, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 1350.65', '2026-09-26 14:45:17'),
(363, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 1500.65', '2026-09-26 14:45:42'),
(364, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 6880.9', '2026-09-26 14:46:06'),
(365, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 5000.62', '2026-09-26 14:46:33'),
(366, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 6000.51', '2026-09-26 14:46:50'),
(367, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 8765.36', '2026-09-26 14:47:13'),
(368, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 1000.55', '2026-09-26 14:47:23'),
(369, 1, 'INSERT', 'depositos', 'Se registró un nuevo depósito con monto de 4462.15', '2026-09-26 14:47:39'),
(370, 1, 'LOGIN', 'usuarios', 'El usuario admin inició sesión correctamente.', '2026-09-26 14:51:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cheques`
--

CREATE TABLE `cheques` (
  `id_cheque` int(11) NOT NULL,
  `numero_cheque` varchar(30) NOT NULL,
  `fecha_cheque` date NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `monto_letras` varchar(300) NOT NULL,
  `detalle` varchar(300) DEFAULT NULL,
  `id_objeto_gasto` int(2) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = emitido. 2 = pendiente. 3 = cobrado. 4 = anulado. 5 = sacado de circulacion.',
  `fecha_anulacion` datetime DEFAULT NULL,
  `motivo_anulacion` varchar(300) DEFAULT NULL,
  `fecha_salida_circulacion` datetime DEFAULT NULL,
  `observacion_salida` varchar(300) DEFAULT NULL,
  `id_usuario_creacion` int(11) NOT NULL,
  `id_usuario_anulacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cheques`
--

INSERT INTO `cheques` (`id_cheque`, `numero_cheque`, `fecha_cheque`, `id_proveedor`, `monto`, `monto_letras`, `detalle`, `id_objeto_gasto`, `estado`, `fecha_anulacion`, `motivo_anulacion`, `fecha_salida_circulacion`, `observacion_salida`, `id_usuario_creacion`, `id_usuario_anulacion`) VALUES
(1, '1', '2025-01-28', 2, 161.04, 'CIENTO SESENTA Y UNO BALBOAS CON 04/100', '', 19, 5, NULL, NULL, '2026-09-25 22:08:12', '', 1, NULL),
(2, '2', '2025-02-19', 3, 109.68, 'CIENTO NUEVE BALBOAS CON 68/100', '', 5, 3, NULL, NULL, NULL, NULL, 1, NULL),
(3, '3', '2025-02-19', 4, 162.48, 'CIENTO SESENTA Y DOS BALBOAS CON 48/100', '', 18, 2, NULL, NULL, NULL, NULL, 1, NULL),
(4, '4', '2025-02-19', 5, 166.72, 'CIENTO SESENTA Y SEIS BALBOAS CON 72/100', '', 15, 3, NULL, NULL, '2026-09-25 22:14:24', '', 1, NULL),
(5, '5', '2025-02-27', 6, 1675.20, 'MIL SEISCIENTOS SETENTA Y CINCO BALBOAS CON 20/100', '', 14, 3, NULL, NULL, NULL, NULL, 1, NULL),
(6, '6', '2026-01-07', 10, 167.67, 'CIENTO SESENTA Y SIETE BALBOAS CON 67/100', '', 19, 1, NULL, NULL, NULL, NULL, 1, NULL),
(7, '7', '2026-01-24', 10, 195.15, 'CIENTO NOVENTA Y CINCO BALBOAS CON 15/100', '', 16, 1, NULL, NULL, NULL, NULL, 1, NULL),
(8, '8', '2026-01-24', 11, 1245.67, 'MIL DOSCIENTOS CUARENTA Y CINCO BALBOAS CON 67/100', '', 13, 1, NULL, NULL, NULL, NULL, 1, NULL),
(9, '9', '2026-02-26', 8, 532.53, 'QUINIENTOS TREINTA Y DOS BALBOAS CON 53/100', '', 9, 1, NULL, NULL, NULL, NULL, 1, NULL),
(10, '10', '2026-02-13', 11, 325.35, 'TRESCIENTOS VEINTICINCO BALBOAS CON 35/100', '', 17, 1, NULL, NULL, NULL, NULL, 1, NULL),
(11, '11', '2026-02-04', 8, 875.23, 'OCHOCIENTOS SETENTA Y CINCO BALBOAS CON 23/100', '', 13, 1, NULL, NULL, NULL, NULL, 1, NULL),
(12, '12', '2026-01-23', 7, 1456.78, 'MIL CUATROCIENTOS CINCUENTA Y SEIS BALBOAS CON 78/100', '', 12, 1, NULL, NULL, NULL, NULL, 1, NULL),
(13, '13', '2026-02-26', 9, 857.35, 'OCHOCIENTOS CINCUENTA Y SIETE BALBOAS CON 35/100', '', 13, 1, NULL, NULL, NULL, NULL, 1, NULL),
(14, '14', '2026-03-01', 10, 1100.67, 'MIL CIEN BALBOAS CON 67/100', '', 17, 1, NULL, NULL, NULL, NULL, 1, NULL),
(15, '15', '2026-03-26', 7, 543.17, 'QUINIENTOS CUARENTA Y TRES BALBOAS CON 17/100', '', 25, 1, NULL, NULL, NULL, NULL, 1, NULL),
(16, '16', '2026-03-29', 7, 4664.36, 'CUATRO MIL SEISCIENTOS SESENTA Y CUATRO BALBOAS CON 36/100', '', 6, 1, NULL, NULL, NULL, NULL, 1, NULL),
(17, '17', '2026-04-03', 8, 1554.21, 'MIL QUINIENTOS CINCUENTA Y CUATRO BALBOAS CON 21/100', '', 15, 1, NULL, NULL, NULL, NULL, 1, NULL),
(18, '18', '2026-04-23', 11, 521.43, 'QUINIENTOS VEINTIUNO BALBOAS CON 43/100', '', 25, 1, NULL, NULL, NULL, NULL, 1, NULL),
(19, '19', '2026-05-26', 9, 1453.56, 'MIL CUATROCIENTOS CINCUENTA Y TRES BALBOAS CON 56/100', '', 11, 1, NULL, NULL, NULL, NULL, 1, NULL),
(20, '20', '2026-05-22', 9, 7523.53, 'SIETE MIL QUINIENTOS VEINTITRES BALBOAS CON 53/100', '', 7, 1, NULL, NULL, NULL, NULL, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conciliaciones`
--

CREATE TABLE `conciliaciones` (
  `id_conciliacion` int(11) NOT NULL,
  `periodo` varchar(7) NOT NULL,
  `saldo_libros` decimal(12,2) NOT NULL DEFAULT 0.00,
  `depositos_transito` decimal(12,2) NOT NULL DEFAULT 0.00,
  `cheques_pendientes` decimal(12,2) NOT NULL DEFAULT 0.00,
  `saldo_banco` decimal(12,2) NOT NULL DEFAULT 0.00,
  `diferencia` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fecha_conciliacion` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = en proceso. 2 = ajustada. 3 = verificada. 4 = cerrada.',
  `id_usuario` int(11) NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `conciliaciones`
--

INSERT INTO `conciliaciones` (`id_conciliacion`, `periodo`, `saldo_libros`, `depositos_transito`, `cheques_pendientes`, `saldo_banco`, `diferencia`, `fecha_conciliacion`, `estado`, `id_usuario`, `observaciones`) VALUES
(0, '2024-12', 17103.09, 0.00, 0.00, 0.00, 0.00, '2026-09-22 16:31:01', 4, 1, 'Conciliación al cierre de periodo'),
(1, '2025-01', 27842.05, 0.00, 0.00, 27842.05, 0.00, '2026-09-25 22:09:16', 3, 1, ''),
(2, '2025-02', 25727.97, 0.00, 1947.36, 27675.33, 0.00, '2026-09-26 00:50:00', 3, 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conciliacion_detalle_cheque`
--

CREATE TABLE `conciliacion_detalle_cheque` (
  `id_conciliacion` int(11) NOT NULL,
  `id_cheque` int(11) NOT NULL,
  `monto_al_momento` decimal(12,2) NOT NULL COMMENT 'Monto del cheque tomado en cuenta dentro de la conciliacion.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `conciliacion_detalle_cheque`
--

INSERT INTO `conciliacion_detalle_cheque` (`id_conciliacion`, `id_cheque`, `monto_al_momento`) VALUES
(1, 1, 161.04),
(2, 1, 161.04),
(2, 2, 109.68),
(2, 3, 162.48),
(2, 4, 166.72),
(2, 5, 1675.20);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conciliacion_detalle_deposito`
--

CREATE TABLE `conciliacion_detalle_deposito` (
  `id_conciliacion` int(11) NOT NULL,
  `id_deposito` int(11) NOT NULL,
  `monto_al_momento` decimal(12,2) NOT NULL COMMENT 'Monto del deposito tomado en cuenta para la conciliacion.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `conciliacion_detalle_deposito`
--

INSERT INTO `conciliacion_detalle_deposito` (`id_conciliacion`, `id_deposito`, `monto_al_momento`) VALUES
(1, 1, 5450.00),
(1, 2, 5450.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `depositos`
--

CREATE TABLE `depositos` (
  `id_deposito` int(11) NOT NULL,
  `numero_comprobante` varchar(50) NOT NULL,
  `tipo_deposito` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = transferencia, 2 = deposito directo.',
  `fecha` date NOT NULL,
  `monto` decimal(12,2) NOT NULL,
  `detalle` varchar(300) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = activo, 0 = inactivo',
  `id_usuario` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `depositos`
--

INSERT INTO `depositos` (`id_deposito`, `numero_comprobante`, `tipo_deposito`, `fecha`, `monto`, `detalle`, `estado`, `id_usuario`, `fecha_registro`) VALUES
(1, '1', 1, '2025-01-03', 5450.00, '', 1, 1, '2026-09-22 14:52:55'),
(2, '2', 1, '2025-01-10', 5450.00, '', 1, 1, '2026-09-22 14:53:29'),
(3, '3', 1, '2026-01-15', 6700.67, '', 1, 1, '2026-09-26 14:40:33'),
(4, '4', 1, '2026-01-20', 1668.35, '', 1, 1, '2026-09-26 14:41:05'),
(5, '5', 1, '2026-02-14', 6767.67, '', 1, 1, '2026-09-26 14:42:52'),
(6, '6', 1, '2026-02-18', 4000.00, '', 1, 1, '2026-09-26 14:43:15'),
(7, '7', 1, '2026-02-25', 5310.10, '', 1, 1, '2026-09-26 14:43:34'),
(8, '8', 1, '2026-03-01', 1350.65, '', 1, 1, '2026-09-26 14:45:17'),
(9, '9', 1, '2026-03-13', 1500.65, '', 1, 1, '2026-09-26 14:45:42'),
(10, '10', 1, '2026-03-28', 6880.90, '', 1, 1, '2026-09-26 14:46:06'),
(11, '11', 1, '2026-01-01', 5000.62, '', 1, 1, '2026-09-26 14:46:33'),
(12, '12', 1, '2026-04-26', 6000.51, '', 1, 1, '2026-09-26 14:46:50'),
(13, '13', 1, '2026-04-15', 8765.36, '', 1, 1, '2026-09-26 14:47:13'),
(14, '14', 2, '2026-05-26', 1000.55, '', 1, 1, '2026-09-26 14:47:23'),
(15, '15', 1, '2026-05-23', 4462.15, '', 1, 1, '2026-09-26 14:47:39');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas_y_salidas`
--

CREATE TABLE `entradas_y_salidas` (
  `id_log` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `fecha_entrada` datetime DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL,
  `intentos_fallidos` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `entradas_y_salidas`
--

INSERT INTO `entradas_y_salidas` (`id_log`, `id_usuario`, `fecha_entrada`, `fecha_salida`, `intentos_fallidos`) VALUES
(1, 1, '2026-09-08 15:55:53', NULL, 0),
(2, 1, '2026-09-08 21:09:07', '2026-09-08 21:09:45', 0),
(3, 1, '2026-09-10 11:55:26', '2026-09-10 11:56:58', 0),
(4, 1, '2026-09-13 11:16:32', '2026-09-13 11:16:54', 0),
(5, 1, '2026-09-13 11:18:13', NULL, 0),
(6, 1, '2026-09-18 20:50:20', '2026-09-18 20:54:58', 0),
(7, 1, '2026-09-18 20:56:27', '2026-09-18 21:24:23', 0),
(8, 1, '2026-09-18 21:24:54', NULL, 0),
(9, 1, '2026-09-18 21:27:26', '2026-09-18 21:36:47', 0),
(10, 1, '2026-09-18 21:51:57', NULL, 0),
(11, 1, '2026-09-18 21:59:02', NULL, 0),
(12, 1, '2026-09-18 22:25:50', NULL, 0),
(13, 1, '2026-09-18 22:30:39', NULL, 0),
(14, 1, '2026-09-19 00:15:19', NULL, 0),
(15, 1, '2026-09-19 00:33:59', NULL, 0),
(16, 1, '2026-09-19 00:39:18', NULL, 0),
(17, 1, '2026-09-19 00:46:25', NULL, 0),
(18, 1, '2026-09-19 07:53:01', NULL, 0),
(19, 1, '2026-09-19 07:56:20', NULL, 0),
(20, 1, '2026-09-19 08:01:00', NULL, 0),
(21, 1, '2026-09-19 08:13:34', NULL, 0),
(22, 1, '2026-09-19 08:15:55', NULL, 0),
(23, 1, '2026-09-19 08:18:26', NULL, 0),
(24, 1, '2026-09-19 08:19:30', NULL, 0),
(25, 1, '2026-09-19 08:22:38', '2026-09-19 08:24:23', 0),
(26, 1, '2026-09-19 08:24:39', NULL, 0),
(27, 1, '2026-09-19 08:37:17', NULL, 0),
(28, 1, '2026-09-19 08:57:53', NULL, 0),
(29, 1, '2026-09-19 08:59:50', NULL, 0),
(30, 1, '2026-09-19 09:10:53', NULL, 0),
(31, 1, '2026-09-19 09:12:04', NULL, 0),
(32, 1, '2026-09-19 19:02:54', NULL, 0),
(33, 1, '2026-09-19 19:19:16', NULL, 0),
(34, 1, '2026-09-19 19:21:34', NULL, 0),
(35, 1, '2026-09-19 19:31:59', NULL, 0),
(36, 1, '2026-09-20 13:41:05', NULL, 0),
(37, 1, '2026-09-20 19:01:26', NULL, 0),
(38, 1, '2026-09-20 19:32:20', NULL, 0),
(39, 1, '2026-09-20 19:36:28', NULL, 0),
(40, 1, '2026-09-20 19:38:33', NULL, 0),
(41, 1, '2026-09-20 19:39:44', NULL, 0),
(42, 1, '2026-09-20 20:12:15', NULL, 0),
(43, 1, '2026-09-20 20:23:41', NULL, 0),
(44, 1, '2026-09-20 20:36:36', NULL, 0),
(45, 1, '2026-09-20 20:40:27', NULL, 0),
(46, 1, '2026-09-21 13:12:10', NULL, 0),
(47, 1, '2026-09-21 13:25:02', NULL, 0),
(48, 1, '2026-09-21 13:36:17', '2026-09-21 13:36:43', 0),
(49, 1, '2026-09-21 13:37:04', NULL, 0),
(50, 1, '2026-09-21 13:40:18', '2026-09-21 13:40:25', 0),
(51, 1, '2026-09-21 13:41:51', NULL, 0),
(52, 1, '2026-09-21 13:48:06', NULL, 0),
(53, 1, '2026-09-21 13:50:51', NULL, 0),
(54, 1, '2026-09-21 13:51:33', NULL, 0),
(55, 1, '2026-09-21 16:03:02', NULL, 0),
(56, 1, '2026-09-22 14:07:37', NULL, 0),
(57, 1, '2026-09-22 14:07:39', NULL, 0),
(58, 1, '2026-09-22 14:24:47', NULL, 0),
(59, 1, '2026-09-22 14:25:43', NULL, 0),
(60, 1, '2026-09-22 14:27:35', NULL, 0),
(61, 1, '2026-09-22 14:30:21', NULL, 0),
(62, 1, '2026-09-22 14:33:25', NULL, 0),
(63, 1, '2026-09-22 14:34:38', NULL, 0),
(64, 1, '2026-09-22 14:35:14', NULL, 0),
(65, 1, '2026-09-22 14:36:13', NULL, 0),
(66, 1, '2026-09-22 14:37:40', NULL, 0),
(67, 1, '2026-09-22 14:40:37', NULL, 0),
(68, 1, '2026-09-22 15:04:19', NULL, 0),
(69, 1, '2026-09-22 15:06:27', NULL, 0),
(70, 1, '2026-09-22 15:33:52', NULL, 0),
(71, 1, '2026-09-22 15:46:50', NULL, 0),
(72, 1, '2026-09-22 16:08:42', NULL, 0),
(73, 1, '2026-09-22 16:15:40', NULL, 0),
(74, 1, '2026-09-22 16:20:51', NULL, 0),
(75, 1, '2026-09-22 16:27:38', NULL, 0),
(76, 1, '2026-09-22 16:31:56', NULL, 0),
(77, 1, '2026-09-22 16:33:17', NULL, 0),
(78, 1, '2026-09-22 16:39:08', NULL, 0),
(79, 1, '2026-09-22 16:43:26', NULL, 0),
(80, 1, '2026-09-22 17:15:14', NULL, 0),
(81, 1, '2026-09-22 17:26:09', NULL, 0),
(82, 1, '2026-09-22 17:26:42', NULL, 0),
(83, 1, '2026-09-22 17:44:25', NULL, 0),
(84, 1, '2026-09-22 17:47:30', NULL, 0),
(85, 1, '2026-09-22 17:48:04', NULL, 0),
(86, 1, '2026-09-22 17:51:34', NULL, 0),
(87, 1, '2026-09-22 17:52:55', NULL, 0),
(88, 1, '2026-09-22 21:16:32', NULL, 0),
(89, 1, '2026-09-22 21:44:56', NULL, 0),
(90, 1, '2026-09-22 22:09:24', NULL, 0),
(91, 1, '2026-09-22 22:16:01', NULL, 0),
(92, 1, '2026-09-22 22:17:29', NULL, 0),
(93, 1, '2026-09-22 22:34:15', NULL, 0),
(94, 1, '2026-09-22 22:36:26', NULL, 0),
(95, 1, '2026-09-22 22:43:54', NULL, 0),
(96, 1, '2026-09-22 22:49:31', NULL, 0),
(97, 1, '2026-09-22 22:53:57', NULL, 0),
(98, 1, '2026-09-22 22:56:30', NULL, 0),
(99, 1, '2026-09-22 22:59:36', NULL, 0),
(100, 1, '2026-09-22 23:03:33', NULL, 0),
(101, 1, '2026-09-22 23:06:25', NULL, 0),
(102, 1, '2026-09-22 23:15:21', NULL, 0),
(103, 1, '2026-09-22 23:23:40', NULL, 0),
(104, 1, '2026-09-22 23:33:39', NULL, 0),
(105, 1, '2026-09-22 23:36:49', NULL, 0),
(106, 1, '2026-09-22 23:38:26', NULL, 0),
(107, 1, '2026-09-22 23:43:51', NULL, 0),
(108, 1, '2026-09-22 23:45:47', NULL, 0),
(109, 1, '2026-09-22 23:48:03', NULL, 0),
(110, 1, '2026-09-22 23:51:34', NULL, 0),
(111, 1, '2026-09-22 23:59:30', NULL, 0),
(112, 1, '2026-09-23 00:01:33', NULL, 0),
(113, 1, '2026-09-23 09:50:04', NULL, 0),
(114, 1, '2026-09-23 09:56:03', NULL, 0),
(115, 1, '2026-09-23 10:00:51', NULL, 0),
(116, 1, '2026-09-23 10:04:02', NULL, 0),
(117, 1, '2026-09-23 10:06:37', NULL, 0),
(118, 1, '2026-09-23 10:30:14', NULL, 0),
(119, 1, '2026-09-23 10:31:18', NULL, 0),
(120, 1, '2026-09-23 12:58:20', NULL, 0),
(121, 1, '2026-09-23 13:00:24', NULL, 0),
(122, 1, '2026-09-23 13:02:22', NULL, 0),
(123, 1, '2026-09-23 13:11:34', NULL, 0),
(124, 1, '2026-09-23 13:14:47', NULL, 0),
(125, 1, '2026-09-23 13:28:54', NULL, 0),
(126, 1, '2026-09-23 13:34:23', NULL, 0),
(127, 1, '2026-09-23 13:52:14', NULL, 0),
(128, 1, '2026-09-23 13:55:43', NULL, 0),
(129, 1, '2026-09-23 14:02:53', NULL, 0),
(130, 1, '2026-09-23 14:06:04', NULL, 0),
(131, 1, '2026-09-24 20:25:26', NULL, 0),
(132, 1, '2026-09-24 21:06:21', NULL, 0),
(133, 1, '2026-09-24 21:33:25', NULL, 0),
(134, 1, '2026-09-24 21:43:48', NULL, 0),
(135, 1, '2026-09-24 21:44:40', NULL, 0),
(136, 1, '2026-09-25 21:22:53', NULL, 0),
(137, 1, '2026-09-25 21:30:09', NULL, 0),
(138, 1, '2026-09-25 21:30:56', NULL, 0),
(139, 1, '2026-09-25 21:31:11', NULL, 0),
(140, 1, '2026-09-25 21:38:53', NULL, 0),
(141, 1, '2026-09-25 21:40:06', NULL, 0),
(142, 1, '2026-09-25 22:07:39', NULL, 0),
(143, 1, '2026-09-25 22:14:05', NULL, 0),
(144, 1, '2026-09-25 22:42:25', NULL, 0),
(145, 1, '2026-09-25 22:43:11', NULL, 0),
(146, 1, '2026-09-25 22:48:36', NULL, 0),
(147, 1, '2026-09-25 22:49:06', NULL, 0),
(148, 1, '2026-09-25 22:58:30', NULL, 0),
(149, 1, '2026-09-25 23:04:50', NULL, 0),
(150, 1, '2026-09-25 23:29:39', NULL, 0),
(151, 1, '2026-09-25 23:30:55', NULL, 0),
(152, 1, '2026-09-25 23:32:22', NULL, 0),
(153, 1, '2026-09-26 00:33:36', NULL, 0),
(154, 1, '2026-09-26 00:35:34', NULL, 0),
(155, 1, '2026-09-26 00:56:06', NULL, 0),
(156, 1, '2026-09-26 01:15:31', NULL, 0),
(157, 1, '2026-09-26 01:19:50', NULL, 0),
(158, 1, '2026-09-26 01:32:11', NULL, 0),
(159, 1, '2026-09-26 01:38:22', NULL, 0),
(160, 1, '2026-09-26 01:38:55', NULL, 0),
(161, 1, '2026-09-26 01:41:18', NULL, 0),
(162, 1, '2026-09-26 01:46:06', NULL, 0),
(163, 1, '2026-09-26 01:51:13', NULL, 0),
(164, 1, '2026-09-26 01:51:53', NULL, 0),
(165, 1, '2026-09-26 01:56:29', NULL, 0),
(166, 1, '2026-09-26 02:00:43', NULL, 0),
(167, 1, '2026-09-26 02:08:57', NULL, 0),
(168, 1, '2026-09-26 02:09:50', NULL, 0),
(169, 1, '2026-09-26 02:10:58', NULL, 0),
(170, 1, '2026-09-26 02:11:49', NULL, 0),
(171, 1, '2026-09-26 13:53:53', NULL, 0),
(172, 1, '2026-09-26 14:26:40', NULL, 0),
(173, 1, '2026-09-26 14:51:48', NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_cheque`
--

CREATE TABLE `historial_cheque` (
  `id_historial` int(11) NOT NULL,
  `id_cheque` int(11) NOT NULL,
  `estado_anterior` tinyint(4) NOT NULL COMMENT '1 = emitido. 2 = pendiente. 3 = cobrado. 4 = anulado. 5 = sacado de circulacion.',
  `estado_nuevo` tinyint(4) NOT NULL COMMENT '1 = emitido. 2 = pendiente. 3 = cobrado. 4 = anulado. 5 = sacado de circulacion.',
  `fecha_cambio` datetime NOT NULL DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL,
  `observacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_cheque`
--

INSERT INTO `historial_cheque` (`id_historial`, `id_cheque`, `estado_anterior`, `estado_nuevo`, `fecha_cambio`, `id_usuario`, `observacion`) VALUES
(1, 1, 1, 2, '2026-09-25 22:08:09', 1, ''),
(2, 1, 2, 5, '2026-09-25 22:08:12', 1, ''),
(3, 5, 1, 2, '2026-09-25 22:08:16', 1, ''),
(4, 4, 1, 2, '2026-09-25 22:08:18', 1, ''),
(5, 2, 1, 2, '2026-09-25 22:08:20', 1, ''),
(6, 3, 1, 2, '2026-09-25 22:08:22', 1, ''),
(7, 4, 2, 5, '2026-09-25 22:14:24', 1, ''),
(10, 5, 2, 3, '2026-09-25 22:40:56', 1, ''),
(11, 2, 2, 3, '2026-09-25 22:41:00', 1, ''),
(12, 2, 2, 3, '2026-09-25 22:50:11', 1, ''),
(13, 5, 2, 3, '2026-09-25 22:50:13', 1, ''),
(14, 5, 2, 3, '2026-09-25 23:01:06', 1, ''),
(15, 2, 2, 3, '2026-09-25 23:01:07', 1, ''),
(16, 4, 2, 3, '2026-09-26 00:35:59', 1, ''),
(17, 2, 2, 3, '2026-09-26 00:51:53', 1, ''),
(18, 5, 2, 3, '2026-09-26 00:51:55', 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `objeto_gasto`
--

CREATE TABLE `objeto_gasto` (
  `id_objeto_gasto` int(2) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `descripcion` varchar(200) NOT NULL,
  `estado` tinyint(4) NOT NULL CHECK (`estado` in (1,2,3,6)),
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `objeto_gasto`
--

INSERT INTO `objeto_gasto` (`id_objeto_gasto`, `codigo`, `descripcion`, `estado`, `fecha_creacion`) VALUES
(1, '120', 'Impresión, Encuadernación y otros', 1, '2026-08-26 09:36:44'),
(2, '130', 'Información y Publicidad', 1, '2026-08-26 09:36:44'),
(3, '141', 'Viáticos dentro del país', 1, '2026-08-26 09:36:44'),
(4, '151', 'Transporte dentro del país', 1, '2026-08-26 09:36:44'),
(5, '169', 'Otros Servicios', 1, '2026-08-26 09:36:44'),
(6, '180', 'Mantenimiento y Reparación', 1, '2026-08-26 09:36:44'),
(7, '181', 'Mantenimiento y Reparación de Edificios', 1, '2026-08-26 09:36:44'),
(8, '182', 'Mantenimiento de Maquinarias y Otros Equipos', 1, '2026-08-26 09:36:44'),
(9, '183', 'Mantenimiento de Mobiliario y Equipo de Oficina', 1, '2026-08-26 09:36:44'),
(10, '185', 'Mantenimiento de Equipos de Computación', 1, '2026-08-26 09:36:44'),
(11, '189', 'Otros Mantenimientos y Reparaciones', 1, '2026-08-26 09:36:44'),
(12, '200', 'Alimentos y Bebidas', 2, '2026-08-26 09:36:44'),
(13, '210', 'Textiles y Vestuarios', 2, '2026-08-26 09:36:44'),
(14, '220', 'Combustibles y Lubricantes', 2, '2026-08-26 09:36:44'),
(15, '230', 'Productos de Papel y Cartón ', 2, '2026-08-26 09:36:44'),
(16, '240', 'Productos Químicos y Conexos', 2, '2026-08-26 09:36:44'),
(17, '250', 'Otros Materiales de Construcción', 2, '2026-08-26 09:36:44'),
(18, '260', 'Productos Varios', 2, '2026-08-26 09:36:44'),
(19, '262', 'Herramientas', 2, '2026-08-26 09:36:44'),
(20, '265', 'Materiales, Accesorios y Suministros de Computación', 2, '2026-08-26 09:36:44'),
(21, '270', 'Útiles y Materiales Diversos', 2, '2026-08-26 09:36:44'),
(22, '280', 'Repuestos', 2, '2026-08-26 09:36:44'),
(23, '320', 'Equipo Educacional y Recreativo', 3, '2026-08-26 09:36:44'),
(24, '340', 'Equipo de Oficina', 3, '2026-08-26 09:36:44'),
(25, '350', 'Mobiliario de Oficina', 3, '2026-08-26 09:36:44'),
(26, '370', 'Maquinarias y Equipos Varios', 3, '2026-08-26 09:36:44'),
(27, '380', 'Equipo de Computación', 3, '2026-08-26 09:36:44'),
(28, '610', 'Comedor Escolar (60%)', 6, '2026-08-26 09:36:44'),
(29, '611', 'Donaciones Estudiantiles (40%)', 6, '2026-08-26 09:36:44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL COMMENT 'identifica al proveedor dentro de la bd, se usa para las fk.',
  `nombre` varchar(150) NOT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = activo, 0 = inactivo.',
  `ruc` varchar(20) NOT NULL COMMENT 'Identifica legalmente al proveedor y puede cambiar en situaciones muy especificas.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nombre`, `telefono`, `correo`, `estado`, `ruc`) VALUES
(2, 'Do it Center', NULL, NULL, 1, '1-100-1001'),
(3, 'Frio Express Panama', NULL, NULL, 1, '1-100-1002'),
(4, 'Super Pisos', NULL, NULL, 1, '1-100-1003'),
(5, 'Corporacion las Antillas', NULL, NULL, 1, '1-100-1004'),
(6, 'La Tachuelita', NULL, NULL, 1, '1-100-1005'),
(7, 'El Machetazo', NULL, NULL, 1, '1-100-1006'),
(8, 'El Campeon', NULL, NULL, 1, '1-100-1007'),
(9, 'Madison', NULL, NULL, 1, '1-100-1008'),
(10, 'Cochez', NULL, NULL, 1, '1-100-1009'),
(11, 'El Costo', NULL, NULL, 1, '1-100-1010');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Debe guardarse el hash.',
  `correo` varchar(100) NOT NULL,
  `rol` varchar(20) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1 = activo, 0 = inactivo.',
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `intentos_fallidos` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `bloqueado_hasta` datetime DEFAULT NULL COMMENT 'Se usa si se pasa cierto limite de intentos.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `apellido`, `usuario`, `password`, `correo`, `rol`, `estado`, `fecha_creacion`, `intentos_fallidos`, `bloqueado_hasta`) VALUES
(1, 'Administrador', 'Sistema', 'admin', 'nS3J0QF/FnsRToksPJ2JzQ==:jkGWIw2jtmIqV0RJihT9nq8ouDpn4+0fWp7+k22x5Tg=', 'admin@proyecto.com', 'Administrador', 1, '2026-09-08 15:32:55', 0, NULL),
(2, 'Alberto', 'Gonzales', 'Trabajador', '3prSHJKyoPuu/6I3gJqjIQ==:WjMjkffqsYdO6vrLUTardTnqZsTaya/GeiwVYHxjCUg=', 'albertogonzales@gmail.com', 'CONTADOR', 1, '2026-09-26 14:13:11', 0, NULL),
(3, 'Einar', 'Boyd', 'Asistente', 'WdEyVaqn90Zv44dFS82N8A==:5M8v5RlcEEpEeeFM5rhmpZWQb8mOPkUim85BtRSYGgM=', 'einaboyd@gmal.com', 'AUXILIAR', 1, '2026-09-26 14:15:22', 0, NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD PRIMARY KEY (`id_bitacora`),
  ADD KEY `fk_bitacora_usuario` (`id_usuario`);

--
-- Indices de la tabla `cheques`
--
ALTER TABLE `cheques`
  ADD PRIMARY KEY (`id_cheque`),
  ADD UNIQUE KEY `numero_cheque` (`numero_cheque`),
  ADD KEY `fk_cheque_proveedor` (`id_proveedor`),
  ADD KEY `fk_cheque_objeto` (`id_objeto_gasto`),
  ADD KEY `fk_cheque_usuario_creacion` (`id_usuario_creacion`),
  ADD KEY `fk_cheque_usuario_anulacion` (`id_usuario_anulacion`);

--
-- Indices de la tabla `conciliaciones`
--
ALTER TABLE `conciliaciones`
  ADD PRIMARY KEY (`id_conciliacion`),
  ADD UNIQUE KEY `periodo` (`periodo`),
  ADD KEY `fk_conciliacion_usuario` (`id_usuario`);

--
-- Indices de la tabla `conciliacion_detalle_cheque`
--
ALTER TABLE `conciliacion_detalle_cheque`
  ADD PRIMARY KEY (`id_conciliacion`,`id_cheque`),
  ADD KEY `fk_detalle_cheque` (`id_cheque`);

--
-- Indices de la tabla `conciliacion_detalle_deposito`
--
ALTER TABLE `conciliacion_detalle_deposito`
  ADD PRIMARY KEY (`id_conciliacion`,`id_deposito`),
  ADD KEY `fk_detalle_deposito` (`id_deposito`);

--
-- Indices de la tabla `depositos`
--
ALTER TABLE `depositos`
  ADD PRIMARY KEY (`id_deposito`),
  ADD KEY `fk_deposito_usuario` (`id_usuario`);

--
-- Indices de la tabla `entradas_y_salidas`
--
ALTER TABLE `entradas_y_salidas`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `fk_entrada_salida_usuario` (`id_usuario`);

--
-- Indices de la tabla `historial_cheque`
--
ALTER TABLE `historial_cheque`
  ADD PRIMARY KEY (`id_historial`),
  ADD KEY `fk_historial_cheque` (`id_cheque`),
  ADD KEY `fk_historial_usuario` (`id_usuario`);

--
-- Indices de la tabla `objeto_gasto`
--
ALTER TABLE `objeto_gasto`
  ADD PRIMARY KEY (`id_objeto_gasto`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `ruc` (`ruc`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD UNIQUE KEY `usuario_2` (`usuario`),
  ADD UNIQUE KEY `uq_usuario` (`usuario`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bitacora`
--
ALTER TABLE `bitacora`
  ADD CONSTRAINT `fk_bitacora_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `cheques`
--
ALTER TABLE `cheques`
  ADD CONSTRAINT `fk_cheque_objeto` FOREIGN KEY (`id_objeto_gasto`) REFERENCES `objeto_gasto` (`id_objeto_gasto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cheque_proveedor` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cheque_usuario_anulacion` FOREIGN KEY (`id_usuario_anulacion`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cheque_usuario_creacion` FOREIGN KEY (`id_usuario_creacion`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `conciliaciones`
--
ALTER TABLE `conciliaciones`
  ADD CONSTRAINT `fk_conciliacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `conciliacion_detalle_cheque`
--
ALTER TABLE `conciliacion_detalle_cheque`
  ADD CONSTRAINT `fk_detalle_cheque` FOREIGN KEY (`id_cheque`) REFERENCES `cheques` (`id_cheque`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_cheque_conciliacion` FOREIGN KEY (`id_conciliacion`) REFERENCES `conciliaciones` (`id_conciliacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `conciliacion_detalle_deposito`
--
ALTER TABLE `conciliacion_detalle_deposito`
  ADD CONSTRAINT `fk_detalle_deposito` FOREIGN KEY (`id_deposito`) REFERENCES `depositos` (`id_deposito`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_deposito_conciliacion` FOREIGN KEY (`id_conciliacion`) REFERENCES `conciliaciones` (`id_conciliacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `depositos`
--
ALTER TABLE `depositos`
  ADD CONSTRAINT `fk_deposito_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `entradas_y_salidas`
--
ALTER TABLE `entradas_y_salidas`
  ADD CONSTRAINT `fk_entrada_salida_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `historial_cheque`
--
ALTER TABLE `historial_cheque`
  ADD CONSTRAINT `fk_historial_cheque` FOREIGN KEY (`id_cheque`) REFERENCES `cheques` (`id_cheque`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
