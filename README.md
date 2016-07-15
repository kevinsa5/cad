Notes:

example ffmpeg commands:

-to make a video from stills:

    ffmpeg -r 30 -start_number 18 -i frame%05d.png -b:v 1000k out.mp4

-to concatenate videos:

    ffmpeg -f concat -i list.txt -c copy output

where `list.txt` contains 

    file 'first.mp4'
    file 'second.mp4'
    ...

