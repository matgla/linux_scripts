dir=$(dirname "$0")
echo $dir
cp $dir/config ~/.config/i3/config 
i3-msg restart
