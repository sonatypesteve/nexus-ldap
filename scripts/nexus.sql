create database nxrm;
\c nxrm;
create schema nxrm;
create user nxrm with encrypted password 'nxrm123';
grant all privileges on database nxrm to nxrm;
grant all privileges on schema nxrm to nxrm;
create extension if not exists pg_stat_statements;
create extension if not exists pg_trgm;
