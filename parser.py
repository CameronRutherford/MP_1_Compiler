import re

memfile_loc = "Working_MP3\\mips.srcs\\sources_1\\imports\\new\\judeTest.dat"
asmFile = "judeTest.asm"

# Information holds the opcode and argument lengths for every instruction
information = {}
information["mov"]  =   ('00000000', 5,  5)
information["add"]  =   ('00000001', 5,  5)
#information["movi"] =   ('10000000', 5, 16) # movi currently broken. Needs a significant hardware revamp to enable
#                                               currently there is no signal going from sign extended immediate to the mov mux.
#                                               This also requires a larger control signal to the mux and revamped opcodes
information["addi"] =   ('10000001', 5, 16)
information["lw"]   =   ('10000100', 5, 16)
information["sw"]   =   ('10000101', 5, 16)
information["beq"]  =   ('01000000', 24, 0)
information["ladd"] =   ('00010001', 5,  5)
information['land'] =   ('00010100', 5,  5)
information["lload"] =  ('10010010', 5,  19)
information["lstore"] = ('10010011', 5,  19)
information["vgastore"] = ('10010111', 5,  19)
information["jmp"]  =   ('00100000', 24, 0)


# Registers maps the english name for the register to the binary value representing the
# register internally
registers = {
    "$d0" : bin(0)[2:].zfill(5),
    "$d1" : bin(1)[2:].zfill(5),
    "$d2" : bin(2)[2:].zfill(5),
    "$d3" : bin(3)[2:].zfill(5),
    "$d4" : bin(4)[2:].zfill(5),
    "$d5" : bin(5)[2:].zfill(5),
    "$d6" : bin(6)[2:].zfill(5),
    "$d7" : bin(7)[2:].zfill(5),
    "$d8" : bin(8)[2:].zfill(5),
    "$d9" : bin(9)[2:].zfill(5),
    "$d10" : bin(10)[2:].zfill(5),
    # List Processor 128 bit argument registers, l is for list
    "$l0" : bin(0)[2:].zfill(5),
    "$l1" : bin(1)[2:].zfill(5),
    "$l2" : bin(2)[2:].zfill(5),
    "$l3" : bin(3)[2:].zfill(5),
    "$l4" : bin(4)[2:].zfill(5),
    "$l5" : bin(5)[2:].zfill(5),
    "$l6" : bin(6)[2:].zfill(5),
    "$l7" : bin(7)[2:].zfill(5),
    "$kb" : bin(8)[2:].zfill(5),
    "$vga" : bin(2**19 - 1)[2:]
}

# Data will hold the name and information of all our variables
data = {}
# lines holds the contents of the assembler code file
lines = []
# Translate variable types into number of bits
# Everything is a dword from now on
data_size_identifiers = { "dword" : 32}

# Get all the code without the comments
with open(asmFile) as f:
    for line in f:
        line = line.partition('#')[0].strip()
        if line != '':
            lines.append(line)

binary_tracker = ''

# If there is a data section, consume it and convert it to hex
if lines[0] == ".data":
    del lines[0]
    while lines[0] != ".code":
        line = lines.pop(0)
        things = line.split(' ')
        var_name = things.pop(0)
        var_size = things.pop(0)
        var_elements = things
        print("Binary tracker : {}".format(binary_tracker))
        offset_from_start = len(binary_tracker) # maybe don't calculate this every time?
        for x in var_elements:
            mask = 2**data_size_identifiers[var_size] - 1
            complement = int(x) & mask
            binary_tracker += format(complement, '0%db' % data_size_identifiers[var_size])
        data[var_name] = (data_size_identifiers[var_size], offset_from_start)

# contains the lines to be written to the machine code file 
hex_output = []

total_chars = (((len(binary_tracker) + 31) // 32)) * 32
binary_tracker = binary_tracker.ljust(total_chars, '0')

# This works - appends all the data to hex_output as nice hex strings in order
while binary_tracker != '':
    current = binary_tracker[:32]
    binary_tracker = binary_tracker[32:]
    to_add = hex(int(current, 2))[2:]
    hex_output.append(to_add.zfill(8))

# Now that we have the data all stored in hex output, write out to the dual_ram_init.coe file to initialize data memory

ram_loc = "Working_MP3\\mips.srcs\\sources_1\dual_ram_init.coe"
default = "memory_initialization_radix=16;\n"
s2 = "memory_initialization_vector="

with open(ram_loc, "w") as f:
    f.write(default)
    things = []
    things.append(s2)
    for hex_code in hex_output:
        things.append(hex_code)
    things.append(";")

    f.write(" ".join(things))

# Add the jump instruction at the start of our code
def jump(offset_from_current):
    opcode = information["jmp"][0]
    arg = bin(offset_from_current)[2:].zfill(24)
    return hex(int(opcode + arg, 2))[2:]

#tbj = jump(len(hex_output) + 1)
#hex_output.insert(0, tbj)
hex_output = []

# start assembling the code
if lines[0] == '.code':
    del lines[0]
else:
    print("NO CODE SECTION!")

# Walk through the code and consume all the labels, adding them to the label dictionary
# Labels are addressed by their name, and we return the offset from the start of the code section
labels = {}
count = len(hex_output)
label_indx = []
for i, line in enumerate(lines):
    # Labels are on their own line starting with a colon, and only use the first word
    if line[0] == ':':   
        label = line.split(' ')[0][1:]
        labels[label] = count
        label_indx.append(i)
    else:
        count += 1

for i in label_indx[::-1]:
    del lines[i]

for line in lines:
    next_hex = ''

    # Process the current instruction
    things = line.split()
    instr = things[0]
    args = things[1:]
    opcode = information[instr][0]

    # if we know about the instruction...
    if instr in information.keys():
        current_bin = ''
        # giant case statement 
        if instr in ['mov', 'add', 'ladd']:
            current_bin = opcode + registers[args[0]] + registers[args[1]]
        elif instr in ['addi']: # movi should go here as well
            current_bin = opcode + registers[args[0]] + bin(int(args[1]))[2:].zfill(19)
            value = int(args[1])
            if value < 0:
                # turn it into binary and take the two's complement
                complement = bin(2**19 + value)[2:]
                assert len(complement) == 19, 'Negative number too negative. Be more positive.'
                current_bin = opcode + registers[args[0]] + complement
        elif instr in ['vgastore']:
            arg2 = registers['$vga']
            current_bin = opcode + registers[args[0]] + arg2
            print('Opcode: {0}, arg0: {1}, arg1: {2}, current bin: {3}'.format(opcode, args[0], arg2, current_bin))
        elif instr in ['lw', 'sw', 'lload', 'lstore', 'vgastore']:
            arg2 = args[1]
            arg2_bin = ''
            # If we are dealing with an exact memory location
            if arg2[0:2] == '0x':
                arg2 = arg2[2:]
                arg2_bin = bin(int(arg2, 16))[2:].zfill(19)
            # If we are dealing with an exact memory location
            elif arg2[0].isdigit():
                arg2_bin = bin(int(arg2))[2:].zfill(19)
            # We are dealing with a variable
            else:
                matches = re.split('[\[ \]]', arg2)
                if len(matches) > 1: # we have a variable with an index
                    variable = matches[0]
                    offset = int(matches[1]) * data[variable][0] + data[variable][1]
                    arg2_bin = str(bin(offset)[2:].zfill(19))
                else: # plain old variable
                    print("{} {} {}".format(data, data[arg2], data[arg2][1]))
                    arg2_bin = str(bin(data[arg2][1])[2:].zfill(19))
            current_bin = opcode + registers[args[0]] + arg2_bin
        elif instr in ['jmp', 'beq']:
            jLoc = args[0]
            # if we're jumping to a label
            if jLoc in labels.keys():
                print(jLoc)
                jLoc = (labels[jLoc] - len(hex_output) - 1) * 4
                print(jLoc)
            else: # otherwise we're jumping a set number of instructions
                jLoc = int(jLoc) * 4
            if jLoc < 0:
                jLoc = (2 ** 24) + jLoc
            arg = bin(jLoc)[2:].zfill(24)
            print(arg)
            current_bin = opcode + arg
        if current_bin != '':
            next_hex = hex(int(current_bin.ljust(32, '0'), 2))[2:].zfill(8)
            hex_output.append(next_hex.upper())
    else:
        print("The function " + instr + "does not exist!")

with open(memfile_loc, "w") as f:
    for x in hex_output:
        f.write(x.lower() + '\n')