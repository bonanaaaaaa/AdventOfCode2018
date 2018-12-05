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

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
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
	ch := make(chan string)
	chInt := make(chan int)

	// var wg sync.WaitGroup

	// fmt.Println(len(strList))

	go func() {
		for _, s := range strList {
			go produce(s, ch)
			chInt <- len(<-ch)
		}
		close(ch)
		close(chInt)
	}()

	for l := range chInt {
		// fmt.Println(l)
		minV = min(l, minV)
	}

	fmt.Println(minV)

}
