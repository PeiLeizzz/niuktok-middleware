use mysql;
select host, user from user;
create user if not exists 'qiniu' identified by 'qiniu1024';
grant all privileges on *.* to 'qiniu'@'%' with grant option;

flush privileges;
