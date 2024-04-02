# **About RSound**
## What is RSound
[RSound](https://docs.racket-lang.org/rsound/index.html) is a Racket Package created in 2010 and updated since which allows for audio playback, recording, and creation. For the purpose of this exploration activity, I opted to focus on audio playback. While there is audio recording present in this program, I wasn't able to get it to work properly with my microphone setup. It's entirely possible that this will work just fine on someone elses machine, but recording using RSound as stated in the [definition of the function call](https://docs.racket-lang.org/rsound/index.html#%28def._%28%28lib._rsound%2Fmain..rkt%29._record-sound%29%29) is basic.<br><br>While I didn't explore creation for this EA, it seems like that is where this library shines due to its immense amount of audio manipulation features.

## Examples of how RSound is used
If all you're interested in is playing WAV files, its as simple as executing (play (rs-read *path*)). This will then play the WAV file from the beginning to the end, or until you run (stop). 
<br>Additionally, if you want to have a little more control, you can use the pstream abstraction. While this in it of itself doesn't provide much control except for queueing sounds and setting the volume, it can keep track of the current frame the program is on in the file, which can be used to calculate the current second the song is at. This is useful in my program as it's how I calculate the time displayed on the slider bar.

## Why did I choose this package
I wanted to challenge myself with racket. I When I ran across this package, I realized that this would give me a good excuse to practice GUI's in racket.
## Did learning this package have an influence how I learn Racket
I'm not sure if it influenced it in a good way as there were some things I had to do pretty weirdly since this library didn't have support for a couple features I wanted to implement.
## Final thoughts on RSound
RSound is an amazing library for people looking to work with audio. It provides the user with a plethora of manipulation tools and an easy way to save and load WAV files. I would recommend this package to anyone who wants to experiment with audio manipulation in Racket, and I'll likely come back to this library if I ever decide to try and make a game in this language.