import wave
import os

# Program to convert wave files into binary files.
# Binary files can then be read as a sequence of pulses (at 48kHz) to produce sound.

directory = "Samples for project"
i = 1

for filename in os.listdir(directory):
    if filename.endswith(".wav"):

        # #test print
        # print(filename)
        # print(directory)

        w = wave.open(directory + "/" + filename, "rb")
        waveData = w.getparams()
        binStream = w.readframes(w.getnframes())
        print(filename)
        print(list(waveData))

        f = open("sample" + str(i) + ".txt", "w")
        for b in binStream:
            f.write(format(int(str(b)), '08b'))
            f.write("\n")

        print("\n\n")
        f.close()
        w.close()
        i += 1

