file = open("input.txt", "r")

arr = []
map = {}

for line in file:
    arr.append(int(line))

i = 0
sum = 0

while True:
    sum += arr[i]
    if (sum in map):
        print(sum)
        break
    else:
        map[sum] = True

    if (i + 1) == len(arr):
        i = 0
    else:
        i += 1
