package mysql

import "fmt"

func Init() {
	fmt.Println("To init MySQL, please exec this command\n\n" +
		">mysql ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mytest';\n\n" +
		">mysql GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;\n\n" +
		">mysql CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';\n\n" +
		">mysql GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;")
}
