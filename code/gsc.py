from PIL import Image

def read(i):
    pixels = i.load() 
    width, height = i.size
    new_line = 320 - width
    
    odd = False
    
    if width % 2 != 0:
        odd = True
        
    
    
    file_path = input("Enter output library file name: ") + ".inc"
    lib_name = input("Enter macro name: ")
    add_buffer = 0
    with open(file_path, 'w') as file:
        file.write(lib_name + " MACRO x,y\n")
        file.write("push ax\npush bx\n")
        file.write("mov ax, 320\nmov bx, y\nmul bx\nmov bx, ax\nadd bx, x\n")
        
        
        for y in range(height):
            for x in range(int(width/2)):
                pixelright = pixels[x*2 + 1, y] 
                pixelleft = pixels[x*2, y]
                
                if pixels[x*2 + 1, y] == 0 and pixels[x*2, y] == 0:
                    add_buffer += 2
                elif add_buffer != 0:
                    file.write("add bx, " + str(add_buffer) + "\n")
                    add_buffer = 0
                if pixels[x*2 + 1, y] == 0 and pixels[x*2, y] != 0:
                    file.write("mov es:[bx], BYTE PTR " + str(pixels[x*2, y]) + "\n")
                    add_buffer += 2
                if pixels[x*2 + 1, y] != 0 and pixels[x*2, y] == 0:
                    file.write("inc bx\nmov es:[bx], BYTE PTR " + str(pixels[x*2 + 1, y]))
                    add_buffer += 1
                if pixels[x*2 + 1, y] != 0 and pixels[x*2, y] != 0:
                    file.write("mov es:[bx], WORD PTR " + str(pixels[x*2, y] + pixels[x*2 + 1, y] * 2**8) + "\n")
                    add_buffer += 2
                
            if odd:
                file.write("mov es:[bx], BYTE PTR " + str(pixels[width - 1, y]) + "\n")
                add_buffer += 1
            add_buffer += new_line
        file.write("pop bx\npop ax\n")
        file.write("endm\n")       


def main():
    read(Image.open(input("Enter png file name: ")+".png"))
    

main()
