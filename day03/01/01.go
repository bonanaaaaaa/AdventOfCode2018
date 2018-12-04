// package main

// import (
// 	"bufio"
// 	"fmt"
// 	"os"
// 	"strconv"
// 	"strings"
// )

// type position struct {
// 	x1 int
// 	x2 int
// 	y1 int
// 	y2 int
// }

// var mem map[string]bool = make(map[string]bool)

// func intersectArea(rec1, rec2 position) int {
// 	area := 0
// 	for x := rec1.x1; x <= rec1.x2; x++ {
// 		for y := rec1.y1; y <= rec1.y2; y++ {
// 			if rec2.x1 <= x && x <= rec2.x2 && rec2.y1 <= y && y <= rec2.y2 {
// 				k := strconv.Itoa(x) + "," + strconv.Itoa(y)
// 				if _, ok := mem[k]; !ok {
// 					area++
// 				}
// 				mem[k] = true
// 			}
// 		}
// 	}
// 	return area
// }

// func main() {
// 	file, _ := os.Open("input.txt")
// 	// file, _ := os.Open("sample.txt")

// 	defer file.Close()

// 	scanner := bufio.NewScanner(file)

// 	var input []string

// 	var arr []position

// 	for scanner.Scan() {
// 		input = append(input, scanner.Text())
// 	}

// 	for i := 0; i < len(input); i++ {
// 		r := strings.Split(input[i], "@ ")
// 		ps := strings.Split(r[1], ": ")
// 		xy := strings.Split(ps[0], ",")
// 		len := strings.Split(ps[1], "x")
// 		x, _ := strconv.Atoi(xy[0])
// 		y, _ := strconv.Atoi(xy[1])
// 		lenX, _ := strconv.Atoi(len[0])
// 		lenY, _ := strconv.Atoi(len[1])

// 		pos := position{
// 			x1: (x + 1),
// 			x2: (x + lenX),
// 			y1: (y + 1),
// 			y2: (y + lenY),
// 		}

// 		arr = append(arr, pos)
// 	}

// 	ans := 0

// 	for i := 0; i < len(arr); i++ {
// 		for j := i + 1; j < len(arr); j++ {
// 			ans += intersectArea(arr[i], arr[j])
// 		}
// 	}

// 	fmt.Println(ans)
// }
