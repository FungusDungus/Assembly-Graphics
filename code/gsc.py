from PIL import Image

def read(i):
    pixels = i.load() # this is not a list, nor is it list()'able
    width, height = i.size

    all_pixels = []
    file_path = "pacman.inc"
    dim = 17
    new_line = 320 - dim
    with open(file_path, 'w') as file:
        file.write("pacmanSHOW MACRO x,y\n")
        file.write("push ax\npush bx\n")
        file.write("mov ax, 320\nmov bx, y\nmul bx\nmov bx, ax\nadd bx, x\n")
        
        for y in range(height):
            for x in range(width):
                cpixel = pixels[x, y]
                file.write("mov es:[bx], BYTE PTR " + str(cpixel) + "\n")
                file.write("inc bx\n")
                all_pixels.append(cpixel)
            file.write("add bx, " + str(new_line) + "\n")
        file.write("pop bx\npop ax\n")
        file.write("endm\n")       
    print(all_pixels)



def main():
    read(Image.open("pacman.png"))
    

main()
