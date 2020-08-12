from __future__ import print_function
import websocket
import json
import os

tempFilePath = "C:/Users/Goopsie/Desktop/Py-Lua.txt"

if __name__ == "__main__":
    print("Started, Connecting to Beat Saber...")
    ws = websocket.create_connection("ws://127.0.0.1:6557/socket")

    f = open(tempFilePath, "r+")
    f.seek(0)
    f.truncate()
    
    print("Connected! Waiting for notes...")
    while True:
        result = ws.recv()
        result_dict = json.loads(result)

        if result_dict['event'] == "noteCut":
            noteCut = result_dict['noteCut']
            f.seek(0)
            f.truncate()

            if noteCut['noteType'] == "NoteA":
                f.write('Red ')
            #    print("Red")

            elif noteCut['noteType'] == "NoteB":
                f.write('Blue ')
            #    print("Blue")

            elif noteCut['noteType'] == "Bomb":
                f.write('Bomb ')
            #    print("Bomb")

            f.write(str(noteCut['noteID']))
            f.flush()
    ws.close()
    f.close()


# uli was here
