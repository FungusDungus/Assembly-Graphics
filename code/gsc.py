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
        file.write("push ax\npush bx\npush cx\n")
        file.write("mov ax, 320\nmov bx, y\nmul bx\nmov bx, ax\nadd bx, x\n")
        
        previous_pixel = pixels[0,0]
        string_output = ""
        # cxcount = 1
        # loop_index = 0
        for y in range(height):
            for x in range(int(width/2)):
                pixelright = pixels[x*2 + 1, y] 
                pixelleft = pixels[x*2, y]
                
                # if pixelright == previous_pixel and previous_pixel != 0:
                    # cxcount+=1
                    # continue
                # else:
                    # if previous_pixel != 0 and cxcount > 3:
                        # file.write("mov cx, " + str(cxcount) + "\n")
                        # file.write("L" + str(loop_index) + ":\n")
                        # file.write("mov es:[bx], WORD PTR " + str(previous_pixel + previous_pixel * 2**8) + "\n")
                        # file.write("add bx, 2\n")
                        # file.write("loop " + "L" + str(loop_index))
                        # loop_index += 1
          
                    # previous_pixel = pixelright
                    # cxcount = 1
                    
                    
                
                
                
                
                if pixels[x*2 + 1, y] == 0 and pixels[x*2, y] == 0:
                    add_buffer += 2
                elif add_buffer != 0:
                    file.write("add bx, " + str(add_buffer) + "\n")
                    add_buffer = 0
                if pixels[x*2 + 1, y] == 0 and pixels[x*2, y] != 0:
                    file.write("mov es:[bx], BYTE PTR " + str(pixels[x*2, y]) + "\n")
                    add_buffer += 2
                if pixels[x*2 + 1, y] != 0 and pixels[x*2, y] == 0:
                    file.write("inc bx\nmov es:[bx], BYTE PTR " + str(pixels[x*2 + 1, y]) + "\n")
                    add_buffer += 1
                if pixels[x*2 + 1, y] != 0 and pixels[x*2, y] != 0:
                    file.write("mov es:[bx], WORD PTR " + str(pixels[x*2, y] + pixels[x*2 + 1, y] * 2**8) + "\n")
                    add_buffer += 2
                
            if odd:
                file.write("mov es:[bx], BYTE PTR " + str(pixels[width - 1, y]) + "\n")
                add_buffer += 1
            add_buffer += new_line
        file.write("pop cx\npop bx\npop ax\n")
        file.write("endm\n")       

def process(i):
    pixels = i.load()
    width, height = i.size
    new_line = 320 - width # no ragged sprites
    
    output = ""
    with open("dump.txt", 'w') as file:
        output += "DB "
        file.write("DB ")
        for y in range(height):
            for x in range(width):
                
                output += str(pixels[x,y])
                file.write(str(pixels[x,y]))
                if x % 50 != 0:
                    output += ","
                    file.write(",")
                else:
                    output += "\n"
                    file.write("\n")
                    output += "DB "
                    file.write("DB ")
           
    return output
    
def main():
    mode = input("inc or bitmap: ")
    if mode == "inc": # not complete
        read(Image.open("assets/" + input("Enter png file name: ")+".png"))
    if mode == "bitmap":
        print(process(Image.open("assets/" + input("Enter png file name: ")+".png")))
    else:
        print("select a valid mode")

main()
