#!/bin/bash

menudir=$HOME/".menu"

subname=$(ls $menudir | cut -d "_" -f 2 | dmenu)
sub=$(ls $menudir | grep $subname)

exename=$(cat $menudir/$sub | cut -d "," -f 1 | dmenu)
exe=$(cat $menudir/$sub | grep $exename | cut -d "," -f 2)

exec $exe
