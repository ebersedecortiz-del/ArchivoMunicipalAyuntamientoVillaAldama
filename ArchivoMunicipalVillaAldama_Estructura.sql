-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: archivo_municipal_villa_aldama
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `archivos_digitales`
--

DROP TABLE IF EXISTS `archivos_digitales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archivos_digitales` (
  `id_archivo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_documento` bigint unsigned NOT NULL,
  `nombre_original` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_almacenado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruta_relativa` varchar(700) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mime` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'application/pdf',
  `tamano_bytes` bigint unsigned NOT NULL,
  `sha256` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_carga` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cargado_por` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id_archivo`),
  KEY `idx_archivo_documento` (`id_documento`),
  KEY `fk_archivo_usuario` (`cargado_por`),
  CONSTRAINT `fk_archivo_documento` FOREIGN KEY (`id_documento`) REFERENCES `documentos` (`id_documento`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_archivo_usuario` FOREIGN KEY (`cargado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `areas`
--

DROP TABLE IF EXISTS `areas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `areas` (
  `id_area` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave_auxiliar` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetica` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_area`),
  UNIQUE KEY `uq_area_nombre` (`nombre`),
  UNIQUE KEY `uq_areas_clave_auxiliar` (`clave_auxiliar`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bitacora` (
  `id_evento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint unsigned DEFAULT NULL,
  `entidad` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_registro` bigint unsigned DEFAULT NULL,
  `accion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detalle` text COLLATE utf8mb4_unicode_ci,
  `fecha_evento` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_bitacora_fecha` (`fecha_evento`),
  KEY `idx_bitacora_usuario` (`id_usuario`),
  CONSTRAINT `fk_bitacora_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetica` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `uq_categoria_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clasificacion_archivistica`
--

DROP TABLE IF EXISTS `clasificacion_archivistica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clasificacion_archivistica` (
  `id_clasificacion` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_padre` bigint unsigned DEFAULT NULL,
  `nivel` enum('FONDO','SECCION','SERIE','SUBSERIE') NOT NULL,
  `clave` varchar(50) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `orden` smallint unsigned NOT NULL DEFAULT '1',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetica` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_clasificacion`),
  UNIQUE KEY `clave` (`clave`),
  KEY `idx_clasificacion_padre` (`id_padre`),
  KEY `idx_clasificacion_nivel` (`nivel`),
  KEY `idx_clasificacion_activa` (`activo`),
  CONSTRAINT `fk_clasificacion_padre` FOREIGN KEY (`id_padre`) REFERENCES `clasificacion_archivistica` (`id_clasificacion`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disposicion_documental`
--

DROP TABLE IF EXISTS `disposicion_documental`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disposicion_documental` (
  `id_disposicion` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_clasificacion` bigint unsigned NOT NULL,
  `plazo_tramite_meses` smallint unsigned DEFAULT NULL,
  `plazo_concentracion_meses` smallint unsigned DEFAULT NULL,
  `inicio_computo` enum('CIERRE_EXPEDIENTE','RECEPCION','OTRO','PENDIENTE') NOT NULL DEFAULT 'PENDIENTE',
  `destino_final` enum('CONSERVACION','BAJA','SELECCION','PENDIENTE') NOT NULL DEFAULT 'PENDIENTE',
  `estado_validacion` enum('PENDIENTE','VALIDADO','RECHAZADO') NOT NULL DEFAULT 'PENDIENTE',
  `observaciones` varchar(1000) DEFAULT NULL,
  `es_hipotetica` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_disposicion`),
  UNIQUE KEY `id_clasificacion` (`id_clasificacion`),
  CONSTRAINT `fk_disposicion_clasificacion` FOREIGN KEY (`id_clasificacion`) REFERENCES `clasificacion_archivistica` (`id_clasificacion`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disposicion_valores`
--

DROP TABLE IF EXISTS `disposicion_valores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disposicion_valores` (
  `id_disposicion` bigint unsigned NOT NULL,
  `id_valor` bigint unsigned NOT NULL,
  PRIMARY KEY (`id_disposicion`,`id_valor`),
  KEY `fk_disposicion_valores_valor` (`id_valor`),
  CONSTRAINT `fk_disposicion_valores_disposicion` FOREIGN KEY (`id_disposicion`) REFERENCES `disposicion_documental` (`id_disposicion`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_disposicion_valores_valor` FOREIGN KEY (`id_valor`) REFERENCES `valores_documentales` (`id_valor`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documentos`
--

DROP TABLE IF EXISTS `documentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos` (
  `id_documento` bigint unsigned NOT NULL AUTO_INCREMENT,
  `folio_interno` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `id_categoria` bigint unsigned NOT NULL,
  `id_tipo` bigint unsigned NOT NULL,
  `id_area` bigint unsigned NOT NULL,
  `id_expediente` bigint unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `palabras_clave` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'REGISTRADO',
  `creado_por` bigint unsigned DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`),
  UNIQUE KEY `uq_documento_folio` (`folio_interno`),
  KEY `idx_documento_nombre` (`nombre`),
  KEY `idx_documento_fecha` (`fecha_emision`),
  KEY `idx_documento_area` (`id_area`),
  KEY `idx_documento_categoria` (`id_categoria`),
  KEY `idx_documento_expediente` (`id_expediente`),
  KEY `fk_documento_tipo` (`id_tipo`),
  KEY `fk_documento_usuario` (`creado_por`),
  CONSTRAINT `fk_documento_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_documento_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_documento_expediente` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_documento_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipos_documentales` (`id_tipo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_documento_usuario` FOREIGN KEY (`creado_por`) REFERENCES `usuarios` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estados_documento`
--

DROP TABLE IF EXISTS `estados_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_documento` (
  `id_estado` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clave` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetico` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estados_expediente`
--

DROP TABLE IF EXISTS `estados_expediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_expediente` (
  `id_estado` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clave` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetico` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expedientes`
--

DROP TABLE IF EXISTS `expedientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedientes` (
  `id_expediente` bigint unsigned NOT NULL AUTO_INCREMENT,
  `codigo_expediente` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `id_area` bigint unsigned NOT NULL,
  `fecha_apertura` date DEFAULT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ABIERTO',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_expediente`),
  UNIQUE KEY `uq_expediente_codigo` (`codigo_expediente`),
  KEY `idx_expediente_area` (`id_area`),
  KEY `idx_expediente_estado` (`estado`),
  CONSTRAINT `fk_expediente_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `secuencias_folio`
--

DROP TABLE IF EXISTS `secuencias_folio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `secuencias_folio` (
  `id_area` bigint unsigned NOT NULL,
  `anio` smallint unsigned NOT NULL,
  `ultimo_folio` int unsigned NOT NULL DEFAULT '500',
  PRIMARY KEY (`id_area`,`anio`),
  CONSTRAINT `fk_secuencia_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipos_documentales`
--

DROP TABLE IF EXISTS `tipos_documentales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_documentales` (
  `id_tipo` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetico` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_tipo`),
  UNIQUE KEY `uq_tipo_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_usuario` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash_contrasena` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ARCHIVISTA',
  `id_area` bigint unsigned DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_nombre` (`nombre_usuario`),
  UNIQUE KEY `uq_usuario_correo` (`correo`),
  KEY `fk_usuario_area` (`id_area`),
  CONSTRAINT `fk_usuario_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id_area`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `valores_documentales`
--

DROP TABLE IF EXISTS `valores_documentales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `valores_documentales` (
  `id_valor` bigint unsigned NOT NULL AUTO_INCREMENT,
  `clave` varchar(50) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `tipo_valor` enum('PRIMARIO','SECUNDARIO') NOT NULL,
  `descripcion` varchar(500) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `es_hipotetica` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_valor`),
  UNIQUE KEY `clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'archivo_municipal_villa_aldama'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-12 17:17:20
