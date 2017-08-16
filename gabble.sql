-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: Gabble
-- ------------------------------------------------------
-- Server version	5.5.5-10.2.7-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gabs`
--

DROP TABLE IF EXISTS `gabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gabs` (
  `gabid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gabtext` varchar(140) NOT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`gabid`),
  UNIQUE KEY `gabid_UNIQUE` (`gabid`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gabs`
--

LOCK TABLES `gabs` WRITE;
/*!40000 ALTER TABLE `gabs` DISABLE KEYS */;
INSERT INTO `gabs` VALUES (1,'Hi!',NULL,NULL),(2,'Hi!',NULL,NULL),(3,'Hi!',NULL,NULL),(4,'Hi!',NULL,NULL),(5,'Hi!',NULL,NULL),(6,'Yo?',NULL,NULL),(7,'Sup',NULL,NULL),(8,'Not uh...',NULL,NULL),(9,'Killah_Dillah first comment',NULL,NULL),(10,'KD shows logged in -does mySQL show userid with \r\ngab?',2,NULL),(11,'last comment showed userID in SQL, but when \r\nredirected, no longer showed username as logged in',2,NULL),(12,'testing if session transfers to \'homepage\'',2,NULL),(13,'testing timestamp',2,'2017-08-12 21:03:23'),(14,'Long comment with timestamp to view where like button \r\nis. Spacing purposes. Lah di dah!',2,'2017-08-12 22:33:15'),(15,'looooooooooooooong \r\nmessssssssssssaaaaaaagggggggggggeeeeeeeeeee.......\r\n.............................sup',NULL,'2017-08-12 22:41:48'),(16,'testing out likes',2,'2017-08-12 23:04:55'),(17,'testing',2,'2017-08-12 23:08:19'),(18,'Hi there!',2,'2017-08-13 14:15:30'),(19,'testing likes with added app.js code with COUNT',2,'2017-08-13 15:44:19'),(20,'gjaghaergnhaibae',2,'2017-08-13 15:56:26'),(21,'dryguhjihgftdretfyguyguktyft',2,'2017-08-13 17:27:33'),(22,'',NULL,'2017-08-14 17:44:58'),(23,'',NULL,'2017-08-14 17:47:49'),(24,'perfect',2,'2017-08-14 18:59:01'),(25,'professor gab',1,'2017-08-14 19:03:11');
/*!40000 ALTER TABLE `gabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `gabid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `gabid_fk_idx` (`gabid`),
  KEY `userid_fk_idx` (`userid`),
  CONSTRAINT `gabid_fk` FOREIGN KEY (`gabid`) REFERENCES `gabs` (`gabid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `userid_fk` FOREIGN KEY (`userid`) REFERENCES `users` (`userid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,2,18),(2,2,21),(3,2,21),(4,2,21),(5,2,21),(6,2,21),(7,2,24),(8,1,24),(9,1,25),(10,1,24),(11,1,24),(12,3,25),(13,3,24),(14,3,24),(15,4,25);
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `userid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fname` varchar(225) DEFAULT NULL,
  `lname` varchar(225) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `side` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `id_UNIQUE` (`userid`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Michael','Sweeney','theprofessor','401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429080fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1','Rebellion'),(2,'Leah','Miller','Killah_Dillah','b109f3bbbc244eb82441917ed06d618b9008dd09b3befd1b5e07394c706a8bb980b1d7785e5976ec049b46df5f1326af5a2ea6d103fd07c95385ffab0cacbc86','Empire'),(3,'Mila','Endo','mila.alim','929872838cb9cfe6578e11f0a323438aee5ae7f61d41412d62db72b25dac52019de2d6a355eb2d033336fb70e73f0ec0afeca3ef36dd8a90d83f998fee23b78d',NULL),(4,'Jimmy','Jacobson','JimmyJam','929872838cb9cfe6578e11f0a323438aee5ae7f61d41412d62db72b25dac52019de2d6a355eb2d033336fb70e73f0ec0afeca3ef36dd8a90d83f998fee23b78d',NULL),(5,'Thomas','Shannon','tomboy','929872838cb9cfe6578e11f0a323438aee5ae7f61d41412d62db72b25dac52019de2d6a355eb2d033336fb70e73f0ec0afeca3ef36dd8a90d83f998fee23b78d',NULL),(6,'Domingo','Rosa','Domino','e1cc867e070565b17656702f48d54c483b3fb64fe4d2f0bb30b6c4ec84e4b8d51fe3cdebe2324e7dec3c82f6971d89b52a6c3beb8d5dda2b9b1a80ddc129d073',NULL),(7,'Jase','Cutler','Charlie','401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429080fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1',NULL),(8,'Princess','Leia','general','401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429080fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-08-16 10:19:55
