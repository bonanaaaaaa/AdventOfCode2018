package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var minV = 999999999

func match(s1, s2 string) bool {
	return strings.ToLower(s1) == strings.ToLower(s2) && s1 != s2
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func produce(str string, index int) string {
	if len(str)-1 == index+1 {
		return str
	}

	if match(string(str[index]), string(str[index+1])) {
		front := str[:index]
		newStr := front + str[index+2:]

		return produce(newStr, max(0, index-1))
	}
	return produce(str, index+1)
}

func producer(s string) int {
	return len(produce(s, 0))
}

func main() {
	file, _ := os.Open("input.txt")
	// file, _ := os.Open("sample.txt")

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var str string

	for scanner.Scan() {
		str = scanner.Text()
	}

	fmt.Println(producer(str))

}
