#!/bin/bash

kill -USR1 $(ps auxwww | grep twoops | grep unicorn  | grep master| awk '{print $2}')
