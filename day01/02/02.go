package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	// file, _ := os.Open("input.txt")
	file, _ := os.Open("input.txt")

	defer file.Close()

	scanner := bufio.NewScanner(file)

	mem := make(map[int]bool)

	var arr []int

	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		arr = append(arr, num)
	}

	recur(0, 0, arr, mem)
}

func recur(sum int, index int, arr []int, mem map[int]bool) {
	num := arr[index]
	if mem[sum] {
		fmt.Println(sum)
	} else {
		mem[sum] = true
		newIndex := index + 1
		if newIndex == len(arr) {
			newIndex = 0
		}
		recur(sum+num, newIndex, arr, mem)
	}
}
