Donnenwa
========
사장에게 돈내놔라고 합니다.

## 목적

ja3ck : 근데 이거 뭐하는 거임?

rumidier : 형석님도 물으셨죠 근데 대체 이게 뭐하려고 하는거냐.. 라
고

ja3ck : 영어로 subject, 목적 목표

rumidier : 공적인 돈을 내꺼로 썻다

ja3k : 아

rumidier : 1. 사장에게 돈달라고 해야는데 구찮다.

ja3ck : 공금횡령용 웹앱이구나

rumidier : 2. 사장이 까먹는다

rumidier : 3. 나 썻으니 달라

rumidier : 요거때문에...

ja3ck : ㅇㅇ

> 그렇다고 합니다.

## how to run

	mysql> create database dondb;
	mysql> create user 'don'@'localhost' identified by 'don';
	mysql> grant all privileges on `dondb`.* to 'don'@'localhost' with grant option;
	
	$> mysql -udon -pdon dondb < schema/dondb.sql 
	$> ./run

### dbicdump ###

    $ cpanm dbicdump
    $ dbicdump -Ilib schema/schema.pl

## carton install

    $ vi Makefile.PL
    모듈 require
    $ carton install 또는 carton install 모듈명
