DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `charge`;

CREATE TABLE `charge` (
  id      INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  amount  INT unsigned NOT NULL DEFAULT '0' COMMENT '금액',
  user    INT unsigned NOT NULL COMMENT '청구 작성자',
  comment varchar(255) NOT NULL DEFAULT '내용 없음' COMMENT '청구 메모',
  title   varchar(255) NOT NULL DEFAULT '제목 없음' COMMENT '청구 제목',
  created_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  updated_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user` (
  id         INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  user_name  varchar(255) NOT NULL DEFAULT '',
  email      varchar(255) NOT NULL DEFAULT '',
  password   varchar(255) NOT NULL DEFAULT '',
  created_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  updated_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user` VALUES (1,'aanoaa','aanoaa@gmail.com','1234',localtime ,localtime);
INSERT INTO `user` VALUES (2,'rumidier','rumidier@gmail.com','1234',localtime ,localtime);
INSERT INTO `user` VALUES (3,'jack','ja3ck@me.com','4383', localtime, localtime);
