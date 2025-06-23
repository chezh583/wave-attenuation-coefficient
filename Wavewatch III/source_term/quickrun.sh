for num in {1..86}
do
        firstline=5
        sed -i "${firstline}s/.*/i=$num/" countcut.py
        cutnum=$(python countcut.py)
        echo "Processing num=$num, with number of cut = $cutnum"
done

