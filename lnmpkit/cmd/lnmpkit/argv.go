package main

import "github.com/khs1994-docker/lnmp/lnmpkit/server/mysql"

func Argv(argv []string){
	switch argv[1] {
	case "mysql":
		mysql.Main(argv)
	}
}
