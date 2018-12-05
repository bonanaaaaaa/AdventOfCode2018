package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, _ := os.Open("input.txt")
	// file, _ := os.Open("sample.txt")

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var str string

	for scanner.Scan() {
		str = scanner.Text()
	}

	fmt.Println(str)
}
