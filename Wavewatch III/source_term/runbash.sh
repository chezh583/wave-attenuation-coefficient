#!/bin/bash
#SBATCH -N 1
#SBATCH -t 9:00:00
#SBATCH -J mod13
#SBATCH -A naiss2024-22-1138
ulimit -s unlimited
ulimit -c 0

for num in {1..197}
do
	firstline=5
        sed -i "${firstline}s/.*/i=$num/" countcut.py
        cutnum=$(python countcut.py)
        echo "Processing num=$num, with number of cut = $cutnum"
        for icut in $(seq 1 $cutnum)
        do
                line_icut=13
                line_number=12

                ww3_grid > ww3_grid.out
                ww3_strt > ww3_strt.out
                sed -i "${line_number}s/.*/i=$num/" write_ww3bounc.py
                sed -i "${line_icut}s/.*/j=$icut/" write_ww3bounc.py
                python write_ww3bounc.py
                ww3_bounc > ww3_bounc.out
                sed -i "${line_number}s/.*/i=$num/" write_ww3shel.py
                sed -i "${line_icut}s/.*/j=$icut/" write_ww3shel.py
                python write_ww3shel.py
                ww3_shel > ww3_shel.out
                ww3_ounp > ww3_ounp.out
                mv ww3.199001_tab.nc output/
                sed -i "${line_number}s/.*/i=$num/" write_rename.py
                sed -i "${line_icut}s/.*/j=$icut/" write_rename.py
                python write_rename.py
        done
done

