package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func match(s1, s2 string) bool {
	return strings.ToLower(s1) == strings.ToLower(s2) && s1 != s2
}

func produce(str string, ch chan string) {
	l := len(str)
	if l == 0 {
		ch <- ""
	} else if l == 1 {
		ch <- str
	} else {
		half := int(l / 2)

		leftChan := make(chan string)
		rightChan := make(chan string)

		go produce(str[:half], leftChan)
		go produce(str[half:], rightChan)

		ch <- merge(
			<-leftChan,
			<-rightChan,
		)
	}
}

func merge(front, back string) string {
	if front == "" && back == "" {
		return ""
	} else if front == "" {
		return back
	} else if back == "" {
		return front
	} else if match(front[len(front)-1:], back[0:1]) {
		return merge(front[:len(front)-1], back[1:])
	} else {
		return front + back
	}
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

	ch := make(chan string)

	go produce(str, ch)
	ans := <-ch
	fmt.Println(len(ans))
}
