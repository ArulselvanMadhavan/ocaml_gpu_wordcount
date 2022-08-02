#!/bin/bash

for i in {1..100}; do cat data/big.txt >> huge.txt; done
