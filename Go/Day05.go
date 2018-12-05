package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strings"
	"time"
)

func main() {
	startTime := time.Now().UnixNano() / 1000000
	bytes, err := ioutil.ReadFile("../AoC 2018/AoC 2018/Input/Day05.txt")
	if err != nil {
		panic(err)
	}
	var lines = strings.Split(string(bytes), "\n")

	fmt.Println("Part 1:", len(reduce(lines[0])))

	line := lines[0]
	shortest := math.MaxInt64
	for c := 'a'; c <= 'z'; c++ {
		l2 := strings.Replace(line, string(c), "", -1)
		l3 := strings.Replace(l2, strings.ToUpper(string(c)), "", -1)
		l4 := reduce(l3)
		fmt.Println(string(c), "-->", len(l4))
		if len(l4) < shortest {
			shortest = len(l4)
		}
	}
	fmt.Println("Part 2:", shortest)
	timeTaken := time.Now().UnixNano() / 1000000 - startTime
	fmt.Println("Time:", timeTaken, "ms")
}

func reduce(line string) string {
	for length := -1; length != len(line); {
		length = len(line)
		for i := 0; i < len(line)-1; i++ {
			j := i + 1
			upper := strings.ToUpper(line)
			if upper[i] == upper[j] && line[i] != line[j] {
				for ; i >= 0 && j < len(line) && upper[i] == upper[j] && line[i] != line[j]; {
					i--
					j++
				}
				if i < 0 {
					line = line[j:]
				} else if j >= len(line) {
					line = line[:i]
				} else if j > i+1 {
					line = line[:i+1] + line[j:]
				}
			}
		}
	}
	return line
}
