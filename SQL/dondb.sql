CREATE TABLE `charge` (
  id      INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  amount  INT unsigned NOT NULL DEFAULT '0' COMMENT '금액',
  user_id INT unsigned NOT NULL COMMENT '청구 작성자',
  content varchar(255) NOT NULL DEFAULT '내용 없음' COMMENT '청구 메모',
  title   varchar(255) NOT NULL DEFAULT '제목 없음' COMMENT '청구 제목',
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user` (
  id         INT unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  user_name  varchar(255) NOT NULL DEFAULT '',
  email      varchar(255) NOT NULL DEFAULT '',
  password   varchar(255) NOT NULL DEFAULT '',
  created_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  updated_on DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`id`) REFERENCES `charge` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
