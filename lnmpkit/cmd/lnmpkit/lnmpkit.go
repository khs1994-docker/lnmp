package main

import (
	"fmt"
	"github.com/khs1994-docker/lnmp/lnmpkit/api"
	"os"
)

func main() {
	fmt.Printf("Welcome use LNMPKit %s\n", api.DefaultVersion)

	argv := os.Args

	if len(argv) == 1 {
		fmt.Println("LNMPKit help info")
	} else {
		Argv(argv)
	}
}
