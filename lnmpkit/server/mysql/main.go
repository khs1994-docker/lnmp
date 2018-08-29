package mysql

func Main(argv []string) {
	if len(argv) == 2 {
		helper()

		return
	}

	switch argv[2] {
	case "init":
		Init()
		break

	case "help":
		helper()
		break
	}
}
