#!/bin/bash
#SBATCH -N 1
#SBATCH -t 5:00:00
#SBATCH -J nest_WND
#SBATCH -A naiss2024-22-1138
ulimit -s unlimited
ulimit -c 0

matlab -nodisplay  < write_ice_thickness.m


