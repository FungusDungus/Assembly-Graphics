from PIL import Image

def read(i):
    pixels = i.load() 
    width, height = i.size
    new_line = 320 - width
    
    odd = False
    
    if width % 2 != 0:
        odd = True
        
    
    
    file_path = "pacman.inc"
    
    
    with open(file_path, 'w') as file:
        file.write("pacmanSHOW MACRO x,y\n")
        file.write("push ax\npush bx\n")
        file.write("mov ax, 320\nmov bx, y\nmul bx\nmov bx, ax\nadd bx, x\n")
        
        for y in range(height):
            for x in range(int(width/2)):
                file.write("mov es:[bx], WORD PTR " + str(pixels[x*2, y] + pixels[x*2 + 1, y] * 2**8) + "\n")
                file.write("add bx, 2\n")
            if odd:
                file.write("mov es:[bx], BYTE PTR " + str(pixels[width - 1, y]) + "\n")
                file.write("inc bx\n")

            file.write("add bx, " + str(new_line) + "\n")
        file.write("pop bx\npop ax\n")
        file.write("endm\n")       



def main():
    read(Image.open("pacman.png"))
    

main()
