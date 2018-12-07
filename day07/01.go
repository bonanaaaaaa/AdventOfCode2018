package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
)

func topologicalSort(graph map[string][]string) string {
	inDegree := make(map[string]int)
	for k, vArr := range graph {
		if _, ok := inDegree[k]; !ok {
			inDegree[k] = 0
		}
		for _, v := range vArr {
			inDegree[v]++
		}
	}

	q := []string{}

	for k := range inDegree {
		if inDegree[k] == 0 {
			q = append(q, k)
		}
	}

	sort.Strings(q)

	order := ""

	for len(q) > 0 {
		u := q[0]
		q = q[1:]
		order += u

		neighbor := graph[u]

		for _, n := range neighbor {
			inDegree[n]--
			if inDegree[n] == 0 {
				q = append(q, n)
			}
		}

		sort.Strings(q)
	}

	return order
}

func main() {
	fileName := "input.txt"
	// fileName := "sample.txt"
	file, _ := os.Open(fileName)

	defer file.Close()

	scanner := bufio.NewScanner(file)

	graph := make(map[string][]string)
	inputRegex := regexp.MustCompile("Step\\s([A-Z])[a-z\\s]+([A-Z])[a-z\\s]+\\.")

	for scanner.Scan() {
		matches := inputRegex.FindStringSubmatch(scanner.Text())
		parent, child := matches[1], matches[2]
		graph[parent] = append(graph[parent], child)
	}

	fmt.Println(topologicalSort(graph))
}
