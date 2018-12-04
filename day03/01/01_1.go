package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type position struct {
	x1 int
	x2 int
	y1 int
	y2 int
}

func toMap(pos position) map[string]int {
	m := make(map[string]int)
	for x := pos.x1; x <= pos.x2; x++ {
		for y := pos.y1; y <= pos.y2; y++ {
			k := strconv.Itoa(x) + "," + strconv.Itoa(y)
			m[k] = 1
		}
	}
	return m
}

func divide(list []position) map[string]int {
	if len(list) == 0 {
		return make(map[string]int)
	}

	if len(list) == 1 {
		return toMap(list[0])
	}

	halfSize := int(len(list) / 2)
	listA := divide(list[:halfSize])
	listB := divide(list[halfSize:])

	mergedMap := map[string]int{}

	for k, v := range listA {
		mergedMap[k] = v
	}

	for k, v := range listB {
		if vv, ok := mergedMap[k]; ok {
			mergedMap[k] = vv + v
		} else {
			mergedMap[k] = v
		}
	}

	return mergedMap
}

func main() {
	file, _ := os.Open("input.txt")
	// file, _ := os.Open("sample.txt")

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var input []string

	var arr []position

	for scanner.Scan() {
		input = append(input, scanner.Text())
	}

	for i := 0; i < len(input); i++ {
		r := strings.Split(input[i], "@ ")
		ps := strings.Split(r[1], ": ")
		xy := strings.Split(ps[0], ",")
		len := strings.Split(ps[1], "x")
		x, _ := strconv.Atoi(xy[0])
		y, _ := strconv.Atoi(xy[1])
		lenX, _ := strconv.Atoi(len[0])
		lenY, _ := strconv.Atoi(len[1])

		o := position{
			x1: (x + 1),
			x2: (x + lenX),
			y1: (y + 1),
			y2: (y + lenY),
		}

		arr = append(arr, o)
	}

	positionMap := divide(arr)

	ans := 0
	for _, v := range positionMap {
		if v >= 2 {
			ans++
		}
	}

	fmt.Println(ans)
}
