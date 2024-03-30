package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"sort"
	"time"
)

const (
	GREEN = "\033[0;32m"
	RED   = "\033[0;31m"
	NC    = "\033[0m"
)

func main() {
	var logFilename string
	flag.StringVar(&logFilename, "f", "", "Set the log filename with absolute or relative path.")
	help := flag.Bool("h", false, "Show this help message.")
	flag.Parse()

	if *help {
		flag.Usage()
		os.Exit(0)
	}

	if logFilename == "" {
		fmt.Printf("%s[!] No parameters assigned.%s\n", RED, NC)
		flag.Usage()
		os.Exit(1)
	}

	time.Sleep(1 * time.Second)

	// Check if the log file exists
	if _, err := os.Stat(logFilename); os.IsNotExist(err) {
		fmt.Printf("%s[!] File doesn't exist '%s'.%s\n", RED, logFilename, NC)
		os.Exit(1)
	}

	fmt.Printf("%s[+] File exist '%s'.%s\n", GREEN, logFilename, NC)

	// Read the log file
	data, err := ioutil.ReadFile(logFilename)
	if err != nil {
		fmt.Printf("%s[!] Error reading file: %v.%s\n", RED, err, NC)
		os.Exit(1)
	}

	// Extract IP Addresses
	ipRegex := regexp.MustCompile(`\b(?:\d{1,3}\.){3}\d{1,3}\b`)
	ipMatches := ipRegex.FindAllString(string(data), -1)

	// Count IP Matches
	ipCounts := make(map[string]int)
	for _, ip := range ipMatches {
		ipCounts[ip]++
	}

	// Convert map to slice for sorting
	type kv struct {
		Key   string
		Value int
	}

	var sortedIps []kv
	for k, v := range ipCounts {
		sortedIps = append(sortedIps, kv{k, v})
	}
	sort.Slice(sortedIps, func(i, j int) bool {
		return sortedIps[i].Value > sortedIps[j].Value
	})

	// Print table header
	fmt.Printf("%s%-15s | %s\n", "\033[1m", "IP Address", "Frequency")
	fmt.Println("----------------------------")

	// Print IP Addresses and their frequencies
	for _, kv := range sortedIps {
		fmt.Printf("%-15s | %d\n", kv.Key, kv.Value)
	}

	fmt.Println("----------------------------")
}
