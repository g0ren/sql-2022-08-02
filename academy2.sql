SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `academy` DEFAULT CHARACTER SET utf8 ;
USE `academy` ;

-- Дропаем все таблицы из прошлого задания и пересоздаём как надо

-- -----------------------------------------------------
-- Table `academy`.`Groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `academy`.`Groups`;
CREATE TABLE IF NOT EXISTS `academy`.`Groups` (
  `idGroups` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(10) NOT NULL,
  CHECK (`Name` <> ''),
  `Rating` INT NOT NULL, 
  CHECK (`Rating` >= 0 and `Rating` <= 5),
  `Year` INT NOT NULL, 
  CHECK (`Year` >= 1 and `Year` <= 5),
  PRIMARY KEY (`idGroups`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy`.`Departments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `academy`.`Departments`;
CREATE TABLE IF NOT EXISTS `academy`.`Departments` (
  `idDepartments` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL,
  CHECK (`Name` <> ''),
  `Funding` INT NOT NULL DEFAULT 0, 
  CHECK (`Funding` >= 0),
  PRIMARY KEY (`idDepartments`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy`.`Faculties`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `academy`.`Faculties`;
CREATE TABLE IF NOT EXISTS `academy`.`Faculties` (
  `idFaculties` INT NOT NULL AUTO_INCREMENT,
  `Name` NVARCHAR(100) NOT NULL,
  CHECK (`Name` <> ''),
  `Dean` NVARCHAR(100) NOT NULL,
  CHECK (`Dean` <> ''),
  PRIMARY KEY (`idFaculties`),
  UNIQUE INDEX `Name_UNIQUE` (`Name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `academy`.`Teachers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `academy`.`Teachers`;
CREATE TABLE IF NOT EXISTS `academy`.`Teachers` (
    `idTeachers` INT NOT NULL AUTO_INCREMENT,
    `EmploymentDate` DATE NOT NULL,
    CHECK (`EmploymentDate` >= '1990-01-01'),
    `IsAssistant` BOOL NOT NULL DEFAULT 0,
    `IsProfessor` BOOL NOT NULL DEFAULT 0,
    `Name` NVARCHAR(100) NOT NULL,
     CHECK (`Name` <> ''),
    `Surname` NVARCHAR(100) NOT NULL,
     CHECK (`Surname` <> ''),
    `Position` NVARCHAR(100) NOT NULL,
     CHECK (`Position` <> ''),
    `Salary` INT NOT NULL,
    CHECK (`Salary` > 0),
    `Premium` INT NOT NULL DEFAULT 0,
    CHECK (`Premium` >= 0),
    PRIMARY KEY (`idTeachers`)
)  ENGINE=INNODB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*
Тут (пере)создание базы заканчивается, и её надо заполнить какими-нибудь данными. Мне лень много выдумывать, добавлю по одной строке
*/
INSERT INTO `Departments`
(`Name`,`Funding`)
VALUES
('Electroengineering', 10000);

INSERT INTO `Faculties`
(`Name`,`Dean`)
VALUES
('Faculty of Applied Physics', 'Nicola Tesla');

INSERT INTO `Groups`
(`Name`,`Rating`,`Year`)
VALUES
('EE 101', 4, 1);

INSERT INTO `Teachers`
(`Name`,`Surname`,`Position`,`EmploymentDate`,`IsAssistant`,`IsProfessor`,`Salary`,`Premium`)
VALUES
('Albert', 'Einstein', 'Privat-Dozent', '1999-09-09', 0, 1, 1500, 150);

/*
Запросы
*/

-- Вывести таблицу кафедр, но расположить ее поля в обратном порядке.
SELECT `Funding`, `Name`, `idDepartments`
FROM `Departments`;

-- Вывести названия групп и их рейтинги с уточнением имен полей именем таблицы.
SELECT `Groups`.`Name`, `Groups`.`Rating`
FROM `Groups`;

-- Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки).
SELECT `Surname`, `Salary`/`Premium` as 'Salary to Premium', `Salary`/ (`Salary` + `Premium`) as 'Salary to Total'
FROM `Teachers`;

-- Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”.
SELECT concat('The dean of ',`Name`, ' is ', `Dean`) as 'Deans'
FROM `Faculties`;

-- Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050.
SELECT `Surname`
FROM `Teachers`
WHERE `IsProfessor` = 1 and `Salary` > 1050;

-- Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000.
SELECT `Name`
FROM `Departments`
WHERE `Funding` < 11000 or `Funding` > 25000;

-- Вывести названия факультетов кроме факультета “Computer Science”.
SELECT `Name`
FROM `Faculties`
WHERE `Name` not like 'Computer Science';

-- Вывести фамилии и должности преподавателей, которые не являются профессорами.
SELECT `Surname`, `Position`
FROM `Teachers`
WHERE `IsProfessor` = 0;

-- Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.
SELECT `Surname`, `Position`, `Salary`, `Premium`
FROM `Teachers`
WHERE `IsAssistant` = 1 and `Premium` between 150 and 550;

-- Вывести фамилии и ставки ассистентов.
SELECT `Surname`, `Salary`
FROM `Teachers`
WHERE `IsAssistant` = 1;

-- Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.
SELECT `Surname`, `Position`
FROM `Teachers`
WHERE `EmploymentDate` < '2000-01-01';

-- Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “Software Development”.
-- Выводимое поле должно иметь название “Name of De­part­ment”.
SELECT `Name` as 'Name of De­part­ment'
FROM `Departments`
WHERE `Name` < 'Software Development'
ORDER BY `Name`;

-- Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 1200
SELECT `Surname`
FROM `Teachers`
WHERE `IsAssistant` = 1 and `Salary` + `Premium` <= 1200;

-- Вывести названия групп 5-го курса, имеющих рейтинг в диапазоне от 2 до 4.
SELECT `Name`
FROM `Groups`
WHERE `Year` = 5 and `Rating` between 2 and 4;

-- Вывести фамилии ассистентов со ставкой меньше 550 или надбавкой меньше 200.
SELECT `Surname`
FROM `Teachers`
WHERE `IsAssistant` = 1 and (`Salary` < 550 or `Premium` < 200);
