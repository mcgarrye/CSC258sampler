import wave
import os

# Program to convert wave files into .txt files, intended for RAM initialization.
# NOTE: Each .txt needs to be manually converted to a .mif before use in Verilog.

# NOTE: Clap1.wav has the wrong sample width.. need to replace


directory = "Samples for project"
i = 1

for filename in os.listdir(directory):
    if filename.endswith(".wav"):

        j = 0

        w = wave.open(directory + "/" + filename, "rb")
        waveData = w.getparams()
        binStream = w.readframes(w.getnframes())
        print(filename)
        print(list(waveData))

        sample_idx_reverse = 88200

        f = open("sample" + str(i) + ".txt", "w")
        f.write("DEPTH = 88200; \n \n")  # at Sample rate of 44.1kHz --> Each sample should have a 2s length
        f.write("WIDTH = " + str(w.getsampwidth()*8) + "; \n \n")
        f.write("ADDRESS_RADIX = DEC;\n")
        f.write("DATA_RADIX = BIN; \n \n \n")

        f.write("--\n")
        f.write("CONTENT\n")
        f.write("BEGIN\n")
        x = 0
        for b in binStream:
            if sample_idx_reverse > 0:
                if x == 0:
                    f.write(str(j) + " :   ")

                f.write(format(int(str(b)), '08b'))
                sample_idx_reverse -= 1
                x += 1

                if x == 3:
                    x = 0
                    f.write(";")
                    f.write("\n")
                    j += 1

        f.write("--\nEND;")
        print("\n\n")
        f.close()
        w.close()
        i += 1

