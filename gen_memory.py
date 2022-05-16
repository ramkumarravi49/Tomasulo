import csv
# Write binary format instruction into text file
with open('main_memory.csv', 'w', newline='') as f:
    data = 0
    ptr = csv.writer(f)
    for addr in range(1024):
        row = [str(format(addr,'0>16b')),str(format(data,'0>64b'))]
        ptr.writerow(row)
        data +=1

