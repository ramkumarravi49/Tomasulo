# Delay for functional units
delay = {
    '000000': 8, # ADD
    '000001': 8, # SUB
    '000010': 17, # MUL
    '000011': 40, # FADD
    '000100': 40, # FSUB
    '000101': 80, # FMUL
    '000110': 1, # LD
    '000111': 1, # ST
    '001000': 1, # AND
    '001001': 1, # XOR
    '001010': 1, # NAND
    '001011': 1, # OR
    '001100': 1, # NOT
    '001101': 1, # NOR
    '001110': 9, # NEG
    '001111': 1 } # XNOR

# Opcode for instructions
opcodes = {'ADD': '000000', 'SUB': '000001', 'MUL': '000010', 
'FADD': '000011', 'FSUB': '000100', 'FMUL': '000101', 'LD': '000110',
'ST': '000111', 'AND': '001000', 'XOR': '001001', 'NAND': '001010',
'OR': '001011', 'NOT': '001100', 'NOR': '001101', 'NEG': '001110','XNOR': '001111'}

# Paths to testbenches
test_benches = {
    '000000':'./Adder/tb_int_adder.v', # ADD
    '000001':'./Subractor/tb_int_sub.v', # SUB
    '000010':'./Wallace_multiplier/tb_int_multiplier.v', # MUL
    '000011':'./FP_adder/tb_dfp_adder.v', # FADD
    '000100':'./FP_subractor/tb_dfp_sub.v', # FSUB
    '000101':'./FP_multiplier/tb_dpf_multiplier.v', # FMUL
    '000110':'To be performed', # LD
    '000111':'To be performed', # ST
    '001000':'./ALU/tb_logic.v', # AND
    '001001':'./ALU/tb_logic.v', # XOR
    '001010':'./ALU/tb_logic.v', # NAND
    '001011':'./ALU/tb_logic.v', # OR
    '001100':'./ALU/tb_logic.v', # NOT
    '001101':'./ALU/tb_logic.v', # NOR
    '001110':'./ALU/tb_logic.v', # NEG
    '001111':'./ALU/tb_logic.v'} # XNOR

# Delay for functional units
Delay = {
    '000000': 1, # ADD
    '000001': 1, # SUB
    '000010': 1, # MUL
    '000011': 1, # FADD
    '000100': 1, # FSUB
    '000101': 1, # FMUL
    '000110': 1, # LD
    '000111': 1, # ST
    '001000': 1, # AND
    '001001': 1, # XOR
    '001010': 1, # NAND
    '001011': 1, # OR
    '001100': 1, # NOT
    '001101': 1, # NOR
    '001110': 9, # NEG
    '001111': 1 } # XNOR