dir=$(dirname "$0")
echo $dir
cp $dir/i3blocks.conf ~/.i3blocks.conf 
i3-msg restart
