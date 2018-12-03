package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

type person struct {
	x1 int
	x2 int
	y1 int
	y2 int
}

func main() {
	file, _ := os.Open("input.txt")
	// file, _ := os.Open("sample.txt")

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var input []string

	var arr []person

	for scanner.Scan() {
		input = append(input, scanner.Text())
	}

	maxX := -1
	maxY := -1

	for i := 0; i < len(input); i++ {
		r := strings.Split(input[i], "@ ")
		ps := strings.Split(r[1], ": ")
		xy := strings.Split(ps[0], ",")
		len := strings.Split(ps[1], "x")
		x, _ := strconv.Atoi(xy[0])
		y, _ := strconv.Atoi(xy[1])
		lenX, _ := strconv.Atoi(len[0])
		lenY, _ := strconv.Atoi(len[1])

		maxX = max(maxX, x+lenX)
		maxY = max(maxY, y+lenY)

		o := person{
			x1: (x + 1),
			x2: (x + lenX),
			y1: (y + 1),
			y2: (y + lenY),
		}

		arr = append(arr, o)
	}

	// fmt.Println(maxX)
	// fmt.Println(maxY)

	area := 0

	for i := 1; i <= maxX; i++ {
		for j := 1; j <= maxY; j++ {
			count := 0

			for k := 0; k < len(arr); k++ {
				rec := arr[k]
				if rec.x1 <= i && i <= rec.x2 && rec.y1 <= j && j <= rec.y2 {
					count++
				}

				if count == 2 {
					area++
					break
				}
			}
		}
	}

	fmt.Println(area)
}
