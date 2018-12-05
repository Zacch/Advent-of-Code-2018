package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"strings"
	"sync"
	"time"
)


var (
	mutex        sync.Mutex
	waitGroup    sync.WaitGroup
	part2        int
)


const numberOfThreads = 10

func main() {
	startTime := time.Now().UnixNano() / 1000000
	bytes, err := ioutil.ReadFile("../AoC 2018/AoC 2018/Input/Day05.txt")
	if err != nil {
		panic(err)
	}
	var lines = strings.Split(string(bytes), "\n")

	fmt.Println("Part 1:", len(reduce(lines[0])))

	lineChannel := make(chan string, numberOfThreads)
	for n := 0; n < numberOfThreads; n++ {
		waitGroup.Add(1)
		go reduceGoRoutine(lineChannel)
	}

	part2 = math.MaxInt64
	for c := 'a'; c <= 'z'; c++ {
		l2 := strings.Replace(lines[0], string(c), "", -1)
		l3 := strings.Replace(l2, strings.ToUpper(string(c)), "", -1)
		lineChannel <- l3
	}
	close(lineChannel)
	waitGroup.Wait()

	fmt.Println("Part 2:", part2)
	timeTaken := time.Now().UnixNano() / 1000000 - startTime
	fmt.Println("Time:", timeTaken, "ms")
}

func reduceGoRoutine(lineChannel chan string) {
	for line := range lineChannel {
		length := len(reduce(line))

		mutex.Lock()
		if length < part2 {
			part2 = length
		}
		mutex.Unlock()
	}
	waitGroup.Done()
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
