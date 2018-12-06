package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

var minV = 999999999

func match(s1, s2 string) bool {
	return strings.ToLower(s1) == strings.ToLower(s2) && s1 != s2
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func produce(str string, index int) string {
	for {
		if len(str)-1 == index+1 {
			return str
		}

		if match(string(str[index]), string(str[index+1])) {
			front := str[:index]
			str = front + str[index+2:]
			index = max(0, index-1)
		} else {
			index++
		}
	}
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

	m := make(map[string]bool)

	for _, char := range str {
		m[strings.ToLower(string(char))] = true
	}

	strList := make([]string, 0, len(m))
	for k := range m {
		r, _ := regexp.Compile("([" + strings.ToUpper(k) + k + "])")
		s := r.ReplaceAllString(str, "")
		strList = append(strList, s)
	}

	// for _, s := range strList {
	// 	l := producer(s)
	// 	minV = min(l, minV)
	// }

	chInt := make(chan int)

	go func() {
		for _, s := range strList {
			chInt <- producer(s)
		}
		close(chInt)
	}()

	for l := range chInt {
		minV = min(l, minV)
	}
	fmt.Println(minV)
}
