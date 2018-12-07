package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
)

// var fileName = "sample.txt"
// var worker = 2
// var plusMinutes = 0

var fileName = "input.txt"
var worker = 5
var plusMinutes = 60

func split(arr []string, index int) ([]string, []string) {
	if len(arr)-1 < index {
		return arr, []string{}
	}
	return arr[:index], arr[index:]
}

func customTopologicalSort(graph map[string][]string) int {
	inDegree := make(map[string]int)
	for k, vArr := range graph {
		if _, ok := inDegree[k]; !ok {
			inDegree[k] = 0
		}
		for _, v := range vArr {
			inDegree[v]++
		}
	}

	usedTime := 0

	timeMap := make(map[string]int)

	for i := 1; i <= 26; i++ {
		timeMap[string('A'-1+i)] = plusMinutes + i
	}

	q := []string{}

	for k := range inDegree {
		if inDegree[k] == 0 {
			q = append(q, k)
		}
	}

	sort.Strings(q)

	tasks := []string{}

	q, tasks = split(q, worker)

	for len(q) > 0 {
		u := q[0]
		q = q[1:]

		currentTime := timeMap[u]

		usedTime += currentTime

		for _, v := range q {
			timeMap[v] -= currentTime
		}

		neighbor := []string{}
		if val, ok := graph[u]; ok {
			neighbor = val
		}

		for _, n := range neighbor {
			inDegree[n]--
			if inDegree[n] == 0 {
				tasks = append(tasks, n)
			}
		}

		q, tasks = split(append(q, tasks...), worker)

		sort.SliceStable(q, func(i, j int) bool {
			return timeMap[q[i]] < timeMap[q[j]]
		})
	}

	return usedTime
}

func main() {
	file, _ := os.Open(fileName)

	defer file.Close()

	scanner := bufio.NewScanner(file)

	var input []string

	for scanner.Scan() {
		input = append(input, scanner.Text())
	}

	inputRegex := regexp.MustCompile("Step\\s([A-Z])[a-z\\s]+([A-Z])[a-z\\s]+\\.")
	var graph = make(map[string][]string)

	for _, line := range input {
		matches := inputRegex.FindStringSubmatch(line)
		parent, child := matches[1], matches[2]
		graph[parent] = append(graph[parent], child)
	}

	fmt.Println("====================")
	for p, c := range graph {
		fmt.Printf("%s -> %v\n", p, c)
	}
	fmt.Println("====================")
	minutes := customTopologicalSort(graph)
	fmt.Printf("minutes -> %d\n", minutes)
}
